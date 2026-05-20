<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import API_URL from '../config/api'

const API_BASE = `${API_URL}/api`
const authStore = useAuthStore()

// ── TIPOS ──────────────────────────────────────────────
interface IngredienteOpcion {
  id_ingrediente: number
  nombre_ingrediente: string
  es_obligatorio: boolean
  precio_modificador: number
  seleccionado: boolean
}

interface OrderDetail {
  id_orden_detalle: number
  id_orden: number
  id_producto: number
  id_paquete: number | null
  nombre_producto: string
  cantidad: number
  precio_unitario: number
  subtotal: number
  modifiers: IngredienteOpcion[]
  selections: { id_seleccion: number; id_producto: number; nombre_producto: string; id_grupo: number }[]
  selectionModifiers: Map<number, IngredienteOpcion[]>
}

interface Order {
  id_orden: number
  numero_orden: string
  estado_orden: string
  estado_pago: string
  fecha_creacion: string
  total: number
  cliente: string
  detalles: OrderDetail[]
}

// ── ESTADO ─────────────────────────────────────────────
const isLoading = ref(false)
const error = ref<string | null>(null)
let pollInterval: ReturnType<typeof setInterval> | null = null

// ── FETCH ──────────────────────────────────────────────
const fetchConToken = async (endpoint: string, method = 'GET', body: any = null) => {
  try {
    const options: RequestInit = {
      method,
      headers: {
        'Content-Type': 'application/json',
        'auth-token': authStore.token || ''
      }
    }
    if (body) options.body = JSON.stringify(body)
    const response = await fetch(`${API_BASE}${endpoint}`, options)
    const data = await response.json()
    return data
  } catch (err) {
    console.error(`Error en ${endpoint}:`, err)
    return { status: 'error', mensaje: 'Error de conexión' }
  }
}

// ── CARGA DE DATOS ────────────────────────────────────
const orders = ref<Order[]>([])

const loadOrders = async () => {
  isLoading.value = true
  error.value = null

  const res = await fetchConToken('/ordenes/mostrar')

  if (res.status === 'ok' && res.datos) {
    orders.value = res.datos.map((o: any) => ({
      id_orden: o.id_orden,
      numero_orden: o.numero_orden,
      estado_orden: o.estado_orden,
      estado_pago: o.estado_pago,
      fecha_creacion: o.fecha_creacion,
      total: Number(o.total) || 0,
      cliente: o.cliente || 'Público general',
      detalles: []
    }))
  } else {
    error.value = res.mensaje || 'Error al cargar órdenes'
  }

  isLoading.value = false
}

const loadOrderDetails = async (orderId: number) => {
  const res = await fetchConToken('/ordenes/detalles/mostrar')
  if (res.status === 'ok' && res.datos) {
    return res.datos.filter((d: any) => d.id_orden === orderId)
  }
  return []
}

const loadOrderModifiers = async (orderId: number) => {
  const res = await fetchConToken(`/ordenes/modificadores/${orderId}`)
  if (res.status === 'ok' && res.datos) {
    return res.datos
  }
  return []
}

const loadAllPackageSelections = async (orderId: number) => {
  const res = await fetchConToken(`/ordenes/selcciones-paquete/${orderId}`)
  if (res.status === 'ok' && res.datos) {
    return res.datos
  }
  return []
}

const loadModifiers = async (productId: number, existingIds: number[] = []) => {
  const res = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${productId}`)
  if (res.status === 'ok' && res.datos) {
    return res.datos.map((i: any) => ({
      id_ingrediente: i.id_ingrediente,
      nombre_ingrediente: i.nombre_ingrediente,
      es_obligatorio: i.es_obligatorio,
      precio_modificador: Number(i.precio_modificador || 0),
      seleccionado: existingIds.includes(i.id_ingrediente)
    }))
  }
  return []
}

// ── MODAL EDITAR ──────────────────────────────────────
const showEditModal = ref(false)
const editingOrder = ref<Order | null>(null)
const editingDetails = ref<OrderDetail[]>([])
const editingDetailModifiers = ref<Map<number, IngredienteOpcion[]>>(new Map())

const openEditModal = async (order: Order) => {
  editingOrder.value = order
  showEditModal.value = true

  const detalles = await loadOrderDetails(order.id_orden)
  const allModifiers = await loadOrderModifiers(order.id_orden)
  const allSelections = await loadAllPackageSelections(order.id_orden)

  editingDetails.value = detalles.map((d: any) => ({
    id_orden_detalle: d.id_orden_detalle,
    id_orden: d.id_orden,
    id_producto: d.id_producto,
    id_paquete: d.id_paquete,
    nombre_producto: d.nombre_producto || d.nombre_paquete || 'Producto',
    cantidad: d.cantidad,
    precio_unitario: d.precio_unitario,
    subtotal: d.subtotal,
    modifiers: [],
    selections: [],
    selectionModifiers: new Map()
  }))

  for (const detail of editingDetails.value) {
    const detailMods = allModifiers.filter((m: any) => m.id_orden_detalle === detail.id_orden_detalle)

    if (detail.id_producto && !detail.id_paquete) {
      const productoRes = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${detail.id_producto}`)
      if (productoRes.status === 'ok' && productoRes.datos) {
        const existingIds = detailMods.map((m: any) => m.id_ingrediente)
        const mods = productoRes.datos.map((i: any) => ({
          id_ingrediente: i.id_ingrediente,
          nombre_ingrediente: i.nombre_ingrediente,
          es_obligatorio: i.es_obligatorio,
          precio_modificador: Number(i.precio_modificador || 0),
          seleccionado: existingIds.includes(i.id_ingrediente)
        }))
        editingDetailModifiers.value.set(detail.id_orden_detalle, mods)
      }
    } else if (detail.id_paquete) {
      const detailSelections = allSelections.filter((s: any) => s.id_orden_detalle === detail.id_orden_detalle)
      detail.selections = detailSelections.map((s: any) => ({
        id_seleccion: s.id_seleccion,
        id_producto: s.id_producto,
        nombre_producto: s.nombre_producto,
        id_grupo: s.id_paquete_grupo
      }))

      for (const sel of detail.selections) {
        const selMods = allModifiers.filter((m: any) => m.id_seleccion === sel.id_seleccion)
        const productoRes = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${sel.id_producto}`)
        if (productoRes.status === 'ok' && productoRes.datos) {
          const existingIds = selMods.map((m: any) => m.id_ingrediente)
          const mods = productoRes.datos.map((i: any) => ({
            id_ingrediente: i.id_ingrediente,
            nombre_ingrediente: i.nombre_ingrediente,
            es_obligatorio: i.es_obligatorio,
            precio_modificador: Number(i.precio_modificador || 0),
            seleccionado: existingIds.includes(i.id_ingrediente)
          }))
          detail.selectionModifiers.set(sel.id_seleccion, mods)
        }
      }
    }
  }
}

const closeEditModal = () => {
  showEditModal.value = false
  editingOrder.value = null
  editingDetails.value = []
  editingDetailModifiers.value = new Map()
}

const saveModifiers = async () => {
  if (!editingOrder.value) return

  for (const detail of editingDetails.value) {
    if (detail.id_producto && !detail.id_paquete) {
      const mods = editingDetailModifiers.value.get(detail.id_orden_detalle) || []
      const selectedIds = mods.filter(m => m.seleccionado).map(m => m.id_ingrediente)

      const resMods = await loadOrderModifiers(editingOrder.value.id_orden)
      const existingMods = resMods.filter((m: any) => m.id_orden_detalle === detail.id_orden_detalle)
      const existingIds = existingMods.map((m: any) => m.id_ingrediente)

      for (const mod of mods) {
        const isSelected = selectedIds.includes(mod.id_ingrediente)
        const wasSelected = existingIds.includes(mod.id_ingrediente)

        if (isSelected && !wasSelected) {
          await fetchConToken('/ordenes/detalles-modificadores/', 'POST', {
            id_detalle: detail.id_orden_detalle,
            id_ingrediente: mod.id_ingrediente,
            accion: 'agregar',
            precio: mod.precio_modificador
          })
        } else if (!isSelected && wasSelected) {
          await fetchConToken('/ordenes/detalles-modificadores/', 'DELETE', {
            id_detalle: detail.id_orden_detalle,
            id_ingrediente: mod.id_ingrediente
          })
        }
      }
    } else if (detail.id_paquete && detail.selections.length > 0) {
      for (const sel of detail.selections) {
        const selMods = detail.selectionModifiers.get(sel.id_seleccion) || []
        const selectedIds = selMods.filter(m => m.seleccionado).map(m => m.id_ingrediente)

        const resMods = await loadOrderModifiers(editingOrder.value.id_orden)
        const existingSelMods = resMods.filter((m: any) => m.id_seleccion === sel.id_seleccion)
        const existingIds = existingSelMods.map((m: any) => m.id_ingrediente)

        for (const mod of selMods) {
          const isSelected = selectedIds.includes(mod.id_ingrediente)
          const wasSelected = existingIds.includes(mod.id_ingrediente)

          if (isSelected && !wasSelected) {
            await fetchConToken('/ordenes/detalles-modificadores/', 'POST', {
              id_detalle: detail.id_orden_detalle,
              id_ingrediente: mod.id_ingrediente,
              accion: 'agregar',
              precio: mod.precio_modificador,
              id_seleccion: sel.id_seleccion
            })
          } else if (!isSelected && wasSelected) {
            await fetchConToken('/ordenes/detalles-modificadores/', 'DELETE', {
              id_detalle: detail.id_orden_detalle,
              id_ingrediente: mod.id_ingrediente,
              id_seleccion: sel.id_seleccion
            })
          }
        }
      }
    }
  }

  alert('Modificadores actualizados')
  closeEditModal()
  await loadOrders()
}

// ── CAMBIAR ESTADO ─────────────────────────────────────
const updateOrderStatus = async (orderId: number, newStatus: string) => {
  const res = await fetchConToken(`/ordenes/modificar/${orderId}`, 'PUT', { estado_orden: newStatus })

  if (res.status === 'ok') {
    await loadOrders()

    if (newStatus === 'cancelada') {
      setTimeout(() => {
        orders.value = orders.value.filter(o => o.id_orden !== orderId)
      }, 60000)
    } else if (newStatus === 'entregada') {
      setTimeout(() => {
        orders.value = orders.value.filter(o => o.id_orden !== orderId)
      }, 10000)
    }
  } else {
    error.value = res.mensaje || 'Error al actualizar estado'
  }
}

const markAsLista = (orderId: number) => updateOrderStatus(orderId, 'lista')
const markAsDelivered = (orderId: number) => updateOrderStatus(orderId, 'entregada')
const cancelOrder = (orderId: number) => {
  if (!confirm('¿Cancelar esta orden?')) return
  updateOrderStatus(orderId, 'cancelada')
}

// ── POLLING ─────────────────────────────────────────────
const startPolling = () => {
  stopPolling()
  pollInterval = setInterval(() => {
    loadOrders()
  }, 15000)
}

const stopPolling = () => {
  if (pollInterval) {
    clearInterval(pollInterval)
    pollInterval = null
  }
}

onMounted(() => {
  loadOrders()
  startPolling()
})

onUnmounted(() => {
  stopPolling()
})

// ── FILTRO ─────────────────────────────────────────────
const statusFilters: { label: string; value: string }[] = [
  { label: 'Todas', value: 'todas' },
  { label: 'Pendientes', value: 'pendiente' },
  { label: 'Preparación', value: 'en_preparacion' },
  { label: 'Listas', value: 'lista' },
  { label: 'Entregadas', value: 'entregada' },
  { label: 'Canceladas', value: 'cancelada' },
]
const activeFilter = ref('todas')

const filteredOrders = computed(() => {
  if (activeFilter.value === 'todas') return orders.value
  return orders.value.filter(o => o.estado_orden === activeFilter.value)
})

// ── HELPERS ────────────────────────────────────────────
const statusMeta: Record<string, { label: string; color: string }> = {
  'pendiente': { label: 'Pendiente', color: '#f59e0b' },
  'en_preparacion': { label: 'En preparación', color: '#3b82f6' },
  'lista': { label: 'Lista', color: '#22c55e' },
  'entregada': { label: 'Entregada', color: '#6b7280' },
  'cancelada': { label: 'Cancelada', color: '#ef4444' },
}

const formatTime = (fecha: string) => {
  if (!fecha) return '--:--'
  const d = new Date(fecha)
  return d.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })
}

const formatPrice = (value: any) => {
  const num = Number(value) || 0
  return num.toFixed(2)
}

const openPublicView = () => {
  window.open('/vista-publica', '_blank')
}
</script>

<template>
  <div class="ordenes-layout">
    <Sidebar />
    <main class="ordenes-main">

      <header class="ordenes-header">
        <div class="filter-bar">
          <button
            v-for="f in statusFilters"
            :key="f.value"
            class="filter-chip"
            :class="{ active: activeFilter === f.value }"
            @click="activeFilter = f.value"
          >
            {{ f.label }}
          </button>
        </div>
        <div class="header-right">
          <h1 class="page-title">Órdenes</h1>
          <span v-if="isLoading" class="loading-indicator">⟳</span>
          <button class="btn-public" @click="openPublicView" title="Abrir vista pública">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M18 13v6a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2h6"/>
              <polyline points="15 3 21 3 21 9"/>
              <line x1="10" y1="14" x2="21" y2="3"/>
            </svg>
            Vista pública
          </button>
        </div>
      </header>

      <div v-if="error" class="error-banner">
        {{ error }}
        <button @click="loadOrders">Reintentar</button>
      </div>

      <div class="orders-grid">
        <div v-if="filteredOrders.length === 0 && !isLoading" class="orders-empty">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <p>Sin órdenes en esta categoría</p>
        </div>

        <div
          v-for="order in filteredOrders"
          :key="order.id_orden"
          class="order-card"
          :class="order.estado_orden"
        >
          <div class="order-header">
            <div class="order-info">
              <span class="order-number">{{ order.numero_orden }}</span>
              <span class="order-client">{{ order.cliente }}</span>
            </div>
            <span class="order-time">{{ formatTime(order.fecha_creacion) }}</span>
          </div>

          <div class="status-badge" :style="{ color: statusMeta[order.estado_orden]?.color || '#6b7280' }">
            <span class="status-dot" :style="{ background: statusMeta[order.estado_orden]?.color || '#6b7280' }"></span>
            {{ statusMeta[order.estado_orden]?.label || order.estado_orden }}
          </div>

          <div class="order-items">
            <div v-for="detail in order.detalles" :key="detail.id_orden_detalle" class="order-item">
              <span class="item-qty">×{{ detail.cantidad }}</span>
              <span class="item-name">{{ detail.nombre_producto }}</span>
              <span class="item-price">${{ formatPrice(detail.subtotal) }}</span>
            </div>
          </div>

          <div class="order-total-row">
            <span>Total</span>
            <span class="order-total-value">${{ formatPrice(order.total) }}</span>
          </div>

          <div class="order-actions">
            <button
              v-if="order.estado_orden === 'pendiente' || order.estado_orden === 'en_preparacion'"
              class="action-btn action-btn--lista"
              @click="markAsLista(order.id_orden)"
              title="Marcar como lista"
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="20 6 9 17 4 12"/>
              </svg>
              Lista
            </button>

            <button
              v-if="order.estado_orden === 'lista'"
              class="action-btn action-btn--deliver"
              @click="markAsDelivered(order.id_orden)"
              title="Marcar como entregada"
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 11-5.93-9.14"/>
                <polyline points="22 4 12 14.01 9 11.01"/>
              </svg>
              Entregar
            </button>

            <button
              v-if="order.estado_orden !== 'cancelada' && order.estado_orden !== 'entregada'"
              class="action-btn action-btn--edit"
              @click="openEditModal(order)"
              title="Editar modificadores"
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/>
                <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
              </svg>
            </button>

            <button
              v-if="order.estado_orden !== 'cancelada' && order.estado_orden !== 'entregada'"
              class="action-btn action-btn--cancel"
              @click="cancelOrder(order.id_orden)"
              title="Cancelar orden"
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <line x1="15" y1="9" x2="9" y2="15"/>
                <line x1="9" y1="9" x2="15" y2="15"/>
              </svg>
            </button>
          </div>
        </div>
      </div>

      <div class="watermark">
        <span class="watermark-label">Software por</span>
        <strong class="watermark-brand">CoffeeCode</strong>
      </div>
    </main>

    <!-- MODAL EDITAR MODIFICADORES -->
    <div v-if="showEditModal && editingOrder" class="modal-overlay" @click.self="closeEditModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>Editar: {{ editingOrder.numero_orden }}</h3>
          <button class="close-btn" @click="closeEditModal">✕</button>
        </div>

        <div class="modal-body">
          <div v-for="detail in editingDetails" :key="detail.id_orden_detalle" class="detail-section">
            <div class="detail-header">
              <span class="detail-name">{{ detail.nombre_producto }}</span>
              <span class="detail-qty">×{{ detail.cantidad }}</span>
            </div>

            <div v-if="!detail.id_paquete" class="modifiers-list">
              <label
                v-for="mod in (editingDetailModifiers.get(detail.id_orden_detalle) || [])"
                :key="mod.id_ingrediente"
                class="modifier-row"
              >
                <input type="checkbox" v-model="mod.seleccionado" :disabled="mod.es_obligatorio" />
                <span class="mod-name">{{ mod.nombre_ingrediente }}</span>
                <span v-if="mod.precio_modificador > 0" class="mod-price">+${{ mod.precio_modificador }}</span>
                <span v-if="mod.es_obligatorio" class="mod-required">Requerido</span>
              </label>
              <p v-if="(editingDetailModifiers.get(detail.id_orden_detalle) || []).length === 0" class="no-mods">
                Sin modificadores
              </p>
            </div>

            <div v-else-if="detail.selections.length > 0" class="package-selections">
              <div v-for="sel in detail.selections" :key="sel.id_seleccion" class="selection-group">
                <div class="selection-header">
                  {{ sel.nombre_producto }}
                </div>
                <div class="modifiers-list">
                  <label
                    v-for="mod in (detail.selectionModifiers.get(sel.id_seleccion) || [])"
                    :key="mod.id_ingrediente"
                    class="modifier-row"
                  >
                    <input type="checkbox" v-model="mod.seleccionado" :disabled="mod.es_obligatorio" />
                    <span class="mod-name">{{ mod.nombre_ingrediente }}</span>
                    <span v-if="mod.precio_modificador > 0" class="mod-price">+${{ mod.precio_modificador }}</span>
                    <span v-if="mod.es_obligatorio" class="mod-required">Requerido</span>
                  </label>
                  <p v-if="(detail.selectionModifiers.get(sel.id_seleccion) || []).length === 0" class="no-mods">
                    Sin modificadores
                  </p>
                </div>
              </div>
            </div>
            <div v-else class="package-note">
              Paquete sin selections
            </div>
          </div>
        </div>

        <div class="modal-actions">
          <button class="btn btn--secondary" @click="closeEditModal">Cancelar</button>
          <button class="btn btn--primary" @click="saveModifiers">Guardar cambios</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.ordenes-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
}

.ordenes-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 20px 24px;
  gap: 16px;
  overflow: hidden;
  position: relative;
}

.ordenes-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.filter-bar {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.filter-chip {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  color: var(--tenant-texto-muted, #78716c);
  border-radius: 50px;
  padding: 4px 16px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s;
}

.filter-chip:hover {
  border-color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
  color: var(--tenant-texto);
}

.filter-chip.active {
  background: var(--tenant-primario);
  border-color: var(--tenant-primario);
  color: #fff;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title {
  margin: 0;
  font-size: 30px;
  font-weight: 600;
  color: var(--tenant-texto);
}

.loading-indicator {
  font-size: 18px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.btn-public {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  background: var(--tenant-primario);
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
}

.btn-public svg {
  width: 16px;
  height: 16px;
}

.error-banner {
  background: color-mix(in srgb, var(--color-error, #ef4444) 10%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-error, #ef4444) 30%, transparent);
  color: var(--color-error, #ef4444);
  padding: 12px;
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.error-banner button {
  background: var(--color-error, #ef4444);
  color: white;
  border: none;
  padding: 4px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

.orders-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: minmax(200px, auto);
  gap: 16px;
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: color-mix(in srgb, var(--tenant-texto) 10%, transparent) transparent;
  align-content: start;
  min-height: 0;
}

.order-card {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1.5px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 16px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  transition: border-color 0.15s;
  position: relative;
}

.order-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 15%;
  bottom: 15%;
  width: 3px;
  border-radius: 0 2px 2px 0;
}

.order-card.pendiente::before { background: #f59e0b; }
.order-card.en_preparacion::before { background: #3b82f6; }
.order-card.lista::before { background: #22c55e; }
.order-card.entregada::before { background: #6b7280; }
.order-card.cancelada::before { background: #ef4444; }

.order-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  padding-bottom: 8px;
  gap: 8px;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.order-number {
  font-size: 17px;
  font-weight: 600;
  color: var(--tenant-texto);
}

.order-client {
  font-size: 12px;
  color: var(--tenant-texto-muted);
}

.order-time {
  font-size: 11px;
  color: var(--tenant-texto-muted);
  background: color-mix(in srgb, var(--tenant-texto) 6%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent);
  border-radius: 20px;
  padding: 2px 8px;
  white-space: nowrap;
}

.status-badge {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.status-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
}

.order-items {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
  overflow-y: auto;
  scrollbar-width: none;
}

.order-items::-webkit-scrollbar { display: none; }

.order-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.item-qty {
  color: var(--tenant-primario);
  font-weight: 600;
  min-width: 28px;
}

.item-name {
  flex: 1;
  color: var(--tenant-texto);
}

.item-price {
  color: var(--tenant-texto-muted);
  font-size: 13px;
}

.order-total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  padding-top: 8px;
  font-size: 14px;
  color: var(--tenant-texto-muted);
}

.order-total-value {
  font-size: 16px;
  font-weight: 700;
  color: var(--tenant-texto);
}

.order-actions {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 10px;
  border: none;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
}

.action-btn svg {
  width: 14px;
  height: 14px;
}

.action-btn--lista {
  background: #22c55e;
  color: #fff;
}

.action-btn--lista:hover {
  background: #16a34a;
}

.action-btn--deliver {
  background: #3b82f6;
  color: #fff;
}

.action-btn--deliver:hover {
  background: #2563eb;
}

.action-btn--edit {
  background: color-mix(in srgb, var(--tenant-primario) 15%, transparent);
  color: var(--tenant-primario);
  border: 1px solid color-mix(in srgb, var(--tenant-primario) 30%, transparent);
}

.action-btn--edit:hover {
  background: color-mix(in srgb, var(--tenant-primario) 25%, transparent);
}

.action-btn--cancel {
  background: color-mix(in srgb, #ef4444 15%, transparent);
  color: #ef4444;
  border: 1px solid color-mix(in srgb, #ef4444 30%, transparent);
}

.action-btn--cancel:hover {
  background: color-mix(in srgb, #ef4444 25%, transparent);
}

.orders-empty {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  padding: 48px 0;
  color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
}

.orders-empty svg {
  width: 48px;
  height: 48px;
}

.watermark {
  position: absolute;
  bottom: 20px;
  right: 24px;
  text-align: right;
  display: flex;
  flex-direction: column;
  gap: 1px;
  pointer-events: none;
}

.watermark-label {
  font-size: 11px;
  color: var(--tenant-texto-muted);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.watermark-brand {
  font-size: 17px;
  font-weight: 600;
  color: var(--tenant-primario);
}

/* ── MODAL ── */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: #fff;
  padding: 20px;
  border-radius: 16px;
  width: 90%;
  max-width: 480px;
  max-height: 85vh;
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #e5e7eb;
  padding-bottom: 12px;
  margin-bottom: 16px;
}

.modal-header h3 {
  margin: 0;
  font-size: 18px;
  color: #111827;
}

.close-btn {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #6b7280;
  padding: 4px 8px;
}

.close-btn:hover {
  color: #ef4444;
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.detail-section {
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  padding: 12px;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.detail-name {
  font-weight: 600;
  color: #111827;
}

.detail-qty {
  color: var(--tenant-primario);
  font-weight: 600;
}

.modifiers-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.modifier-row {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  cursor: pointer;
}

.modifier-row:hover {
  border-color: var(--tenant-primario);
}

.mod-name {
  flex: 1;
  font-size: 14px;
  color: #111827;
}

.mod-price {
  font-size: 13px;
  color: #16a34a;
  font-weight: 500;
}

.mod-required {
  font-size: 10px;
  background: #fee2e2;
  color: #dc2626;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 700;
  text-transform: uppercase;
}

.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  border-top: 1px solid #e5e7eb;
  padding-top: 16px;
  margin-top: 16px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
}

.btn--secondary {
  background: #f3f4f6;
  color: #111827;
}

.btn--primary {
  background: var(--tenant-primario);
  color: #fff;
}

.package-note {
  font-size: 13px;
  color: var(--tenant-texto-muted);
  padding: 8px 0;
  font-style: italic;
}

.no-mods {
  font-size: 13px;
  color: var(--tenant-texto-muted);
  padding: 8px;
  margin: 0;
}

.package-selections {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 8px;
}

.selection-group {
  background: #f3f4f6;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 10px;
}

.selection-header {
  font-weight: 600;
  font-size: 13px;
  color: #374151;
  margin-bottom: 8px;
  padding-bottom: 6px;
  border-bottom: 1px dashed #e5e7eb;
}
</style>