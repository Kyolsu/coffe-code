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
  modifiers: string[]
  selections: { id_seleccion: number; id_producto: number; nombre_producto: string; id_grupo: number; nombre_grupo?: string }[]
  selectionModifiers: Map<number, IngredienteOpcion[]>
  isPackage?: boolean
}

interface Order {
  id_orden: number
  numero_orden: string
  estado_orden: string
  estado_pago: string
  fecha_creacion: string
  total: number
  cliente: string
  tipo_orden?: string
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
const cachedDetails = ref<any[]>([])
const cachedModifiers = ref<any[]>([])
const cachedSelections = ref<any[]>([])

const loadOrders = async () => {
  isLoading.value = true
  error.value = null

  const [res, detallesRes, modificadoresRes, seleccionesRes] = await Promise.all([
    fetchConToken('/ordenes/mostrar'),
    loadOrderDetails(),
    loadOrderModifiers(),
    loadAllPackageSelections()
  ])

  cachedDetails.value = detallesRes
  cachedModifiers.value = modificadoresRes
  cachedSelections.value = seleccionesRes

  if (res.status === 'ok' && res.datos) {
    orders.value = res.datos.map((o: any) => ({
      id_orden: o.id_orden,
      numero_orden: o.numero_orden,
      estado_orden: o.estado_orden,
      estado_pago: o.estado_pago,
      fecha_creacion: o.fecha_creacion,
      total: Number(o.total) || 0,
      cliente: o.cliente || 'Público general',
      tipo_orden: o.tipo_orden,
      detalles: []
    }))
  } else {
    error.value = res.mensaje || 'Error al cargar órdenes'
  }

  isLoading.value = false
}

const loadOrderDetails = async () => {
  const res = await fetchConToken('/ordenes/detalles/mostrar')
  if (res.status === 'ok' && res.datos) {
    return res.datos
  }
  return []
}

const loadOrderModifiers = async () => {
  const res = await fetchConToken('/ordenes/detalles-modificadores/mostrar')
  if (res.status === 'ok' && res.datos) {
    return res.datos
  }
  return []
}

const loadAllPackageSelections = async () => {
  const res = await fetchConToken('/ordenes/paquete-seleccion/mostrar')
  if (res.status === 'ok' && res.datos) {
    return res.datos
  }
  return []
}

// ── FILTRO: quitar canceladas/entregadas de más de 1 min ─────────────
const activeFilter = ref('activa')
const filterOptions = [
  { label: 'Activas', value: 'activa' },
  { label: 'Pendientes', value: 'pendiente' },
  { label: 'Listas', value: 'lista' },
  { label: 'Canceladas', value: 'cancelada' },
  { label: 'Entregadas', value: 'entregada' },
]

const ONE_MINUTE = 60 * 1000

const filteredOrders = computed(() => {
  let result = orders.value

  if (activeFilter.value === 'activa') {
    result = result.filter(o => {
      if (o.estado_orden === 'cancelada' || o.estado_orden === 'entregada') {
        const createdAt = new Date(o.fecha_creacion).getTime()
        if (Date.now() - createdAt > ONE_MINUTE) return false
      }
      return true
    })
  } else {
    result = result.filter(o => o.estado_orden === activeFilter.value)
  }

  return result
})

// ── EXPANDIR FILAS ─────────────────────────────────────
const expandedOrders = ref<Set<number>>(new Set())
const loadingDetails = ref<Set<number>>(new Set())

const toggleExpand = async (orderId: number) => {
  if (expandedOrders.value.has(orderId)) {
    expandedOrders.value.delete(orderId)
    return
  }

  const order = orders.value.find(o => o.id_orden === orderId)
  if (!order) return

  if (order.detalles.length === 0 && !loadingDetails.value.has(orderId)) {
    loadingDetails.value.add(orderId)

    const detalles = cachedDetails.value.filter((d: any) => d.id_orden === orderId)
    const allModifiers = cachedModifiers.value
    const allSelections = cachedSelections.value

    order.detalles = detalles.map((d: any) => {
      const detailMods = allModifiers.filter((m: any) => m.id_orden_detalle === d.id_orden_detalle)

      const detailSelections = allSelections
        .filter((s: any) => s.id_orden_detalle === d.id_orden_detalle)
        .map((s: any) => ({
          id_seleccion: s.id_seleccion,
          id_producto: s.id_producto,
          nombre_producto: s.nombre_producto,
          id_grupo: s.id_paquete_grupo,
          nombre_grupo: s.nombre_grupo
        }))

      return {
        id_orden_detalle: d.id_orden_detalle,
        id_orden: d.id_orden,
        id_producto: d.id_producto,
        id_paquete: d.id_paquete,
        nombre_producto: d.nombre_producto || d.nombre_paquete || 'Producto',
        cantidad: d.cantidad,
        precio_unitario: d.precio_unitario,
        subtotal: d.subtotal,
        modifiers: detailMods.map((m: any) => m.nombre_ingrediente as string),
        selections: detailSelections,
        selectionModifiers: new Map(),
        isPackage: !!d.id_paquete
      }
    })

    loadingDetails.value.delete(orderId)
  }

  expandedOrders.value.add(orderId)
}

// ── MODAL EDITAR ──────────────────────────────────────
const showEditModal = ref(false)
const editingOrder = ref<Order | null>(null)
const editingDetails = ref<OrderDetail[]>([])
const editingDetailModifiers = ref<Map<number, IngredienteOpcion[]>>(new Map())

const openEditModal = async (order: Order, event: Event) => {
  event.stopPropagation()
  editingOrder.value = order
  showEditModal.value = true

  const detalles = cachedDetails.value.filter((d: any) => d.id_orden === order.id_orden)
  const allModifiers = cachedModifiers.value
  const allSelections = cachedSelections.value

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
        id_grupo: s.id_paquete_grupo,
        nombre_grupo: s.nombre_grupo
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

      const resMods = cachedModifiers.value
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

        const resMods = cachedModifiers.value
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
  } else {
    error.value = res.mensaje || 'Error al actualizar estado'
  }
}

const markAsLista = (orderId: number, event: Event) => {
  event.stopPropagation()
  updateOrderStatus(orderId, 'lista')
}

const markAsDelivered = (orderId: number, event: Event) => {
  event.stopPropagation()
  updateOrderStatus(orderId, 'entregada')
}

const cancelOrder = (orderId: number, event: Event) => {
  event.stopPropagation()
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
        <div class="header-left">
          <h1 class="page-title">Órdenes</h1>
          <span v-if="isLoading" class="loading-indicator">⟳</span>
        </div>
        <div class="header-right">
          <div class="filter-tabs">
            <button
              v-for="f in filterOptions"
              :key="f.value"
              class="filter-tab"
              :class="{ active: activeFilter === f.value }"
              @click="activeFilter = f.value"
            >
              {{ f.label }}
            </button>
          </div>
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

      <!-- TABLE -->
      <div class="orders-table-wrapper">
        <table class="orders-table" v-if="filteredOrders.length > 0">
          <thead>
            <tr>
              <th class="col-num">#</th>
              <th class="col-tipo">Tipo</th>
              <th class="col-cliente">Cliente</th>
              <th class="col-items">Items</th>
              <th class="col-total">Total</th>
              <th class="col-estado">Estado</th>
              <th class="col-hora">Hora</th>
              <th class="col-acciones">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <template v-for="order in filteredOrders" :key="order.id_orden">
              <tr
                class="order-row"
                :class="[order.estado_orden, { expanded: expandedOrders.has(order.id_orden) }]"
                @click="toggleExpand(order.id_orden)"
              >
                <td class="col-num">
                  <span class="order-num">{{ order.numero_orden }}</span>
                </td>
                <td class="col-tipo">
                  <span v-if="order.tipo_orden === 'para_llevar'" class="badge-tipo">📦 PL</span>
                  <span v-else-if="order.tipo_orden === 'delivery'" class="badge-tipo">🚴 D</span>
                  <span v-else class="badge-tipo">🍽️ Local</span>
                </td>
                <td class="col-cliente">{{ order.cliente }}</td>
                <td class="col-items">
                  <span v-if="loadingDetails.has(order.id_orden)" class="items-preview">Cargando...</span>
                  <span v-else-if="order.detalles.length > 0" class="items-preview">
                    {{ order.detalles.map(d => d.nombre_producto).join(', ') }}
                  </span>
                  <span v-else class="items-preview">{{ order.detalles.length }} item(s)</span>
                </td>
                <td class="col-total">${{ formatPrice(order.total) }}</td>
                <td class="col-estado">
                  <span class="status-badge" :style="{ color: statusMeta[order.estado_orden]?.color }">
                    <span class="status-dot" :style="{ background: statusMeta[order.estado_orden]?.color }"></span>
                    {{ statusMeta[order.estado_orden]?.label }}
                  </span>
                </td>
                <td class="col-hora">{{ formatTime(order.fecha_creacion) }}</td>
                <td class="col-acciones" @click.stop>
                  <button
                    v-if="order.estado_orden === 'pendiente' || order.estado_orden === 'en_preparacion'"
                    class="btn-acc btn-acc--lista"
                    @click="markAsLista(order.id_orden, $event)"
                    title="Marcar como lista"
                  >
                    ✓ Lista
                  </button>
                  <button
                    v-if="order.estado_orden === 'lista'"
                    class="btn-acc btn-acc--entregar"
                    @click="markAsDelivered(order.id_orden, $event)"
                    title="Marcar como entregada"
                  >
                    ✓ Entregar
                  </button>
                  <button
                    v-if="order.estado_orden !== 'cancelada' && order.estado_orden !== 'entregada'"
                    class="btn-acc btn-acc--edit"
                    @click="openEditModal(order, $event)"
                    title="Editar modificadores"
                  >
                    ✏️
                  </button>
                  <button
                    v-if="order.estado_orden !== 'cancelada' && order.estado_orden !== 'entregada'"
                    class="btn-acc btn-acc--cancel"
                    @click="cancelOrder(order.id_orden, $event)"
                    title="Cancelar"
                  >
                    ✕
                  </button>
                </td>
              </tr>

              <!-- Expanded details row -->
              <tr v-if="expandedOrders.has(order.id_orden)" class="detail-row">
                <td colspan="8">
                  <div v-if="loadingDetails.has(order.id_orden)" class="order-detail-panel">
                    <p class="loading-details">Cargando detalles...</p>
                  </div>
                  <div v-else class="order-detail-panel">
                    <h4>Detalle de orden {{ order.numero_orden }}</h4>
                    <div class="detail-items">
                      <div v-for="detail in order.detalles" :key="detail.id_orden_detalle" class="detail-item">
                        <div class="detail-item-header">
                          <span class="detail-name">
                            {{ detail.nombre_producto }}
                            <span v-if="detail.id_paquete" class="badge-paq">PAQ</span>
                          </span>
                          <span class="detail-qty">×{{ detail.cantidad }}</span>
                          <span class="detail-price">${{ formatPrice(detail.subtotal) }}</span>
                        </div>
                        <div v-if="detail.modifiers && detail.modifiers.length > 0" class="detail-mods">
                          <span v-for="(mod, idx) in detail.modifiers" :key="idx" class="mod-tag">{{ mod }}</span>
                        </div>
                        <div v-if="detail.selections && detail.selections.length > 0" class="detail-selections">
                          <div v-for="sel in detail.selections" :key="sel.id_seleccion" class="selection-entry">
                            <span class="sel-grupo" v-if="sel.nombre_grupo">{{ sel.nombre_grupo }}:</span>
                            <span class="sel-producto">{{ sel.nombre_producto }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="detail-footer">
                      <span class="detail-total-label">Total:</span>
                      <span class="detail-total-value">${{ formatPrice(order.total) }}</span>
                    </div>
                  </div>
                </td>
              </tr>
            </template>
          </tbody>
        </table>

        <div v-else class="orders-empty">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <p>Sin órdenes en esta categoría</p>
        </div>
      </div>

      <div class="watermark">
        <span class="watermark-label">Software</span>
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
              <span class="detailname">{{ detail.nombre_producto }}</span>
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
  flex-wrap: wrap;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
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

.filter-tabs {
  display: flex;
  gap: 4px;
  background: color-mix(in srgb, var(--tenant-texto) 6%, transparent);
  border-radius: 10px;
  padding: 4px;
}

.filter-tab {
  padding: 6px 14px;
  border: none;
  background: transparent;
  color: var(--tenant-texto-muted, #78716c);
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s;
  white-space: nowrap;
}

.filter-tab:hover {
  color: var(--tenant-texto);
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
}

.filter-tab.active {
  background: var(--tenant-primario);
  color: #fff;
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

/* ── TABLE ── */
.orders-table-wrapper {
  flex: 1;
  overflow-y: auto;
  overflow-x: auto;
  scrollbar-width: thin;
  scrollbar-color: color-mix(in srgb, var(--tenant-texto) 10%, transparent) transparent;
}

.orders-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.orders-table thead {
  position: sticky;
  top: 0;
  z-index: 10;
}

.orders-table th {
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  color: var(--tenant-texto-muted, #78716c);
  font-weight: 600;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  padding: 10px 12px;
  text-align: left;
  white-space: nowrap;
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
}

.orders-table td {
  padding: 12px;
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 6%, transparent);
  vertical-align: middle;
}

.order-row {
  cursor: pointer;
  transition: background 0.12s;
}

.order-row:hover {
  background: color-mix(in srgb, var(--tenant-texto) 3%, transparent);
}

.order-row.expanded {
  background: color-mix(in srgb, var(--tenant-primario) 5%, transparent);
}

/* Status color left bar */
.order-row.pendiente td:first-child { border-left: 3px solid #f59e0b; }
.order-row.en_preparacion td:first-child { border-left: 3px solid #3b82f6; }
.order-row.lista td:first-child { border-left: 3px solid #22c55e; }
.order-row.entregada td:first-child { border-left: 3px solid #6b7280; }
.order-row.cancelada td:first-child { border-left: 3px solid #ef4444; }

.col-num { width: 90px; }
.col-tipo { width: 100px; }
.col-cliente { min-width: 130px; }
.col-items { min-width: 100px; }
.col-total { width: 90px; text-align: right; }
.col-estado { width: 130px; }
.col-hora { width: 70px; text-align: center; }
.col-acciones { width: 200px; }

.order-num {
  font-weight: 700;
  color: var(--tenant-texto);
}

.badge-tipo {
  font-size: 10px;
  font-weight: 600;
  padding: 2px 6px;
  border-radius: 6px;
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
}

.items-preview {
  font-size: 12px;
  color: var(--tenant-texto-muted);
}

.col-total {
  font-weight: 700;
  color: var(--tenant-texto);
  text-align: right;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  font-weight: 600;
}

.status-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
}

.col-acciones {
  display: flex;
  gap: 4px;
  flex-wrap: nowrap;
}

.btn-acc {
  padding: 5px 10px;
  border: none;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.12s;
  white-space: nowrap;
}

.btn-acc--lista {
  background: #22c55e;
  color: #fff;
}
.btn-acc--lista:hover { background: #16a34a; }

.btn-acc--entregar {
  background: #3b82f6;
  color: #fff;
}
.btn-acc--entregar:hover { background: #2563eb; }

.btn-acc--edit {
  background: color-mix(in srgb, var(--tenant-primario) 15%, transparent);
  color: var(--tenant-primario);
  border: 1px solid color-mix(in srgb, var(--tenant-primario) 30%, transparent);
}
.btn-acc--edit:hover { background: color-mix(in srgb, var(--tenant-primario) 25%, transparent); }

.btn-acc--cancel {
  background: color-mix(in srgb, #ef4444 12%, transparent);
  color: #ef4444;
  border: 1px solid color-mix(in srgb, #ef4444 25%, transparent);
}
.btn-acc--cancel:hover { background: color-mix(in srgb, #ef4444 20%, transparent); }

/* ── EXPANDED DETAIL ROW ── */
.detail-row td {
  padding: 0;
  border-bottom: 2px solid color-mix(in srgb, var(--tenant-primario) 20%, transparent);
}

.order-detail-panel {
  background: color-mix(in srgb, var(--tenant-texto) 3%, transparent);
  padding: 16px 20px;
}

.loading-details { text-align: center; color: var(--tenant-texto-muted); padding: 20px; }

.order-detail-panel h4 {
  margin: 0 0 12px 0;
  font-size: 14px;
  font-weight: 700;
  color: var(--tenant-texto);
}

.detail-items {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.detail-item {
  background: #fff;
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  border-radius: 8px;
  padding: 10px 12px;
}

.detail-item-header {
  display: flex;
  align-items: center;
  gap: 8px;
}

.detail-name {
  flex: 1;
  font-weight: 600;
  color: var(--tenant-texto);
  display: flex;
  align-items: center;
  gap: 6px;
}

.badge-paq {
  font-size: 9px;
  background: var(--tenant-primario);
  color: #fff;
  padding: 1px 4px;
  border-radius: 3px;
  font-weight: 700;
}

.detail-qty {
  color: var(--tenant-primario);
  font-weight: 700;
  min-width: 30px;
}

.detail-price {
  color: var(--tenant-texto-muted);
  font-weight: 600;
  min-width: 70px;
  text-align: right;
}

.detail-selections {
  margin-top: 6px;
  padding-left: 12px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.detail-mods {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-top: 4px;
  padding-left: 8px;
}

.mod-tag {
  font-size: 11px;
  color: var(--tenant-primario);
  background: color-mix(in srgb, var(--tenant-primario) 12%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-primario) 20%, transparent);
  border-radius: 4px;
  padding: 1px 6px;
}

.selection-entry {
  font-size: 12px;
  color: var(--tenant-texto-muted);
  display: flex;
  gap: 4px;
}

.sel-grupo {
  font-weight: 600;
  text-transform: uppercase;
  font-size: 10px;
}

.detail-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px dashed color-mix(in srgb, var(--tenant-texto) 15%, transparent);
}

.detail-total-label {
  font-weight: 600;
  color: var(--tenant-texto-muted);
}

.detail-total-value {
  font-weight: 700;
  color: var(--tenant-texto);
  font-size: 16px;
}

/* ── EMPTY ── */
.orders-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 0;
  color: color-mix(in srgb, var(--tenant-texto) 30%, transparent);
}

.orders-empty svg {
  width: 48px;
  height: 48px;
}

/* ── WATERMARK ── */
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
  max-width: 520px;
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

.close-btn:hover { color: #ef4444; }

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

.detailname {
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

.modifier-row:hover { border-color: var(--tenant-primario); }

.mod-name { flex: 1; font-size: 14px; color: #111827; }
.mod-price { font-size: 13px; color: #16a34a; font-weight: 500; }
.mod-required { font-size: 10px; background: #fee2e2; color: #dc2626; padding: 2px 6px; border-radius: 4px; font-weight: 700; text-transform: uppercase; }
.no-mods { font-size: 13px; color: #9ca3af; padding: 8px; margin: 0; }

.package-selections { display: flex; flex-direction: column; gap: 10px; margin-top: 8px; }
.selection-group { background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 8px; padding: 10px; }
.selection-header { font-weight: 600; font-size: 13px; color: #374151; margin-bottom: 8px; padding-bottom: 6px; border-bottom: 1px dashed #d1d5db; }
.package-note { font-size: 13px; color: #9ca3af; padding: 8px 0; font-style: italic; }

.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  border-top: 1px solid #e5e7eb;
  padding-top: 16px;
  margin-top: 16px;
}

.btn { padding: 10px 20px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; }
.btn--secondary { background: #f3f4f6; color: #111827; }
.btn--primary { background: var(--tenant-primario); color: #fff; }
</style>
