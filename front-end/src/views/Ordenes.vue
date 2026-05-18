<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import Sidebar from '../components/Sidebar.vue'

const API_BASE = 'http://localhost:3000/api'
const authStore = useAuthStore()

// ── TIPOS ──────────────────────────────────────────────
type OrderStatus = 'pendiente' | 'preparacion' | 'lista' | 'entregada' | 'cancelada'

interface OrderItem {
  name: string
  qty: number
  customizations: string[]
  extras: { name: string; qty: number }[]
}

interface Order {
  id: number
  id_orden: number
  numero_orden: number
  status: OrderStatus
  estado_orden: string
  items: OrderItem[]
  createdAt: string
  total: number
}

// ── ESTADO ─────────────────────────────────────────────
const isLoading = ref(false)
const error = ref<string | null>(null)
let pollInterval: number | null = null

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

// ── MAPEO DE ESTADO ────────────────────────────────────
const mapEstadoBackend = (estado: string): OrderStatus => {
  const estadoLower = (estado || '').toLowerCase()
  const mapa: Record<string, OrderStatus> = {
    'pendiente': 'pendiente',
    'en proceso': 'preparacion',
    'preparacion': 'preparacion',
    'preparando': 'preparacion',
    'lista': 'lista',
    'completada': 'entregada',
    'entregada': 'entregada',
    'cancelada': 'cancelada',
    'cancelado': 'cancelada'
  }
  return mapa[estadoLower] || 'pendiente'
}

// ── CARGA DE DATOS ────────────────────────────────────
const orders = ref<Order[]>([])

const loadOrders = async () => {
  isLoading.value = true
  error.value = null

  const [ordenesRes, detallesRes] = await Promise.all([
    fetchConToken('/ordenes/mostrar'),
    fetchConToken('/ordenes/detalles/mostrar')
  ])

  if (ordenesRes.status === 'ok' && ordenesRes.datos) {
    const detalles = detallesRes.datos || []

    orders.value = ordenesRes.datos.map((o: any) => {
      const ordenDetalles = detalles.filter((d: any) => d.id_orden === o.id_orden)
      const items: OrderItem[] = ordenDetalles.map((d: any) => ({
        name: d.nombre_producto || d.nombre_paquete || 'Producto',
        qty: d.cantidad || 1,
        customizations: d.notas ? [d.notas] : [],
        extras: []
      }))

      const total = ordenDetalles.reduce((acc: number, d: any) => acc + (d.subtotal || 0), 0)

      return {
        id: o.id_orden,
        id_orden: o.id_orden,
        numero_orden: o.numero_orden || o.id_orden,
        status: mapEstadoBackend(o.estado_orden),
        estado_orden: o.estado_orden,
        items,
        createdAt: o.fecha_creacion ? new Date(o.fecha_creacion).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' }) : '--:--',
        total: total || o.total || 0
      }
    })
  } else {
    error.value = ordenesRes.mensaje || 'Error al cargar órdenes'
  }

  isLoading.value = false
}

// ── ACCIONES ────────────────────────────────────────────
const editOrder = async (id: number) => {
  const order = orders.value.find(o => o.id === id)
  if (!order) return

  const nuevoEstado = order.status === 'pendiente' ? 'preparacion' : order.status === 'preparacion' ? 'lista' : order.status
  const res = await fetchConToken(`/ordenes/modificar/${id}`, 'PUT', { estado_orden: nuevoEstado })

  if (res.status === 'ok') {
    await loadOrders()
  } else {
    error.value = res.mensaje || 'Error al actualizar orden'
  }
}

const deleteOrder = async (id: number) => {
  if (!confirm('¿Estás seguro de cancelar esta orden?')) return

  const res = await fetchConToken(`/ordenes/cancelar/${id}`, 'DELETE')

  if (res.status === 'ok') {
    orders.value = orders.value.filter(o => o.id !== id)
  } else {
    error.value = res.mensaje || 'Error al cancelar orden'
  }
}

// ── POLLING ─────────────────────────────────────────────
const startPolling = () => {
  stopPolling()
  pollInterval = window.setInterval(() => {
    loadOrders()
  }, 15000) // 15 segundos
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

// ── FILTRO POR STATUS ───────────────────────────────────
const statusFilters: { label: string; value: OrderStatus | 'todas' }[] = [
  { label: 'Todas',       value: 'todas'       },
  { label: 'Pendientes',  value: 'pendiente'   },
  { label: 'Preparación', value: 'preparacion' },
  { label: 'Listas',      value: 'lista'       },
  { label: 'Entregadas',  value: 'entregada'   },
  { label: 'Canceladas',  value: 'cancelada'   },
]
const activeFilter = ref<OrderStatus | 'todas'>('todas')

const filteredOrders = computed(() =>
  activeFilter.value === 'todas'
    ? orders.value
    : orders.value.filter(o => o.status === activeFilter.value)
)

// ── COLORES POR STATUS ──────────────────────────────────
// Se cambiaron los colores estáticos por variables temáticas
const statusMeta: Record<OrderStatus, { label: string; color: string }> = {
  pendiente:   { label: 'Pendiente',   color: 'var(--color-advertencia, #f59e0b)' },
  preparacion: { label: 'Preparación', color: 'var(--tenant-primario, #3b82f6)' },
  lista:       { label: 'Lista',       color: 'var(--color-exitoso, #22c55e)' },
  entregada:   { label: 'Entregada',   color: 'var(--tenant-texto-muted, #6b7280)' },
  cancelada:   { label: 'Cancelada',   color: 'var(--color-error, #ef4444)' },
}
</script>

<template>
  <div class="ordenes-layout">
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
          :key="order.id"
          class="order-card"
          :style="{ '--status-color': statusMeta[order.status].color }"
        >
          <div class="order-header">
            <span class="order-number">Orden: {{ order.numero_orden }}</span>
            <span class="order-time">{{ order.createdAt }}</span>
          </div>

          <div class="status-badge">
            <span
              class="status-dot"
              :style="{ background: statusMeta[order.status].color }"
            ></span>
            <span
              class="status-label"
              :style="{ color: statusMeta[order.status].color }"
            >
              {{ statusMeta[order.status].label }}
            </span>
          </div>

          <div class="order-items">
            <div v-for="(item, i) in order.items" :key="i" class="order-item">
              <div class="order-item-header">
                <span class="order-item-name">{{ item.name }}</span>
                <span class="order-item-qty">× {{ item.qty }}</span>
              </div>
              <div v-if="item.customizations.length" class="order-customizations">
                <span v-for="c in item.customizations" :key="c" class="custom-tag">{{ c }}</span>
              </div>
              <div v-for="extra in item.extras" :key="extra.name" class="order-extra">
                <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                {{ extra.name }}
                <span class="extra-qty">× {{ extra.qty }}</span>
              </div>
            </div>
          </div>

          <div class="order-footer">
            <span class="order-total">${{ order.total }}</span>
            <div class="order-actions">
              <button class="card-btn card-btn--edit" @click="editOrder(order.id)" title="Editar orden">
                <svg viewBox="0 0 24 24" fill="none">
                  <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
              <button class="card-btn card-btn--delete" @click="deleteOrder(order.id)" title="Cancelar orden">
                <svg viewBox="0 0 24 24" fill="none">
                  <polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/>
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="watermark">
        <span class="watermark-label">Software por</span>
        <strong class="watermark-brand">CoffeeCode</strong>
      </div>
    </main>
  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
.ordenes-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
}

.ordenes-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: var(--espacio-5, 20px) var(--espacio-6, 24px);
  gap: var(--espacio-4, 16px);
  overflow: hidden;
  position: relative;
}

/* ── HEADER ── */
.ordenes-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--espacio-4, 16px);
}

.filter-bar {
  display: flex;
  gap: var(--espacio-2, 8px);
  flex-wrap: wrap;
}

.filter-chip {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  color: var(--tenant-texto-muted, #78716c);
  border-radius: 50px;
  padding: var(--espacio-1, 4px) var(--espacio-4, 16px);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  cursor: pointer;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
  font-family: var(--tenant-fuente, sans-serif);
  white-space: nowrap;
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
  gap: var(--espacio-2, 8px);
}

.page-title {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
  white-space: nowrap;
}

.loading-indicator {
  font-size: 18px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.error-banner {
  background: color-mix(in srgb, var(--color-error, #ef4444) 10%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-error, #ef4444) 30%, transparent);
  color: var(--color-error, #ef4444);
  padding: var(--espacio-3, 12px);
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--espacio-3, 12px);
}

.error-banner button {
  background: var(--color-error, #ef4444);
  color: white;
  border: none;
  padding: 4px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: var(--font-size-sm, 13px);
}

/* ── GRID ── */
.orders-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: minmax(180px, auto);
  gap: var(--espacio-4, 16px);
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: color-mix(in srgb, var(--tenant-texto) 10%, transparent) transparent;
  align-content: start;
  min-height: 0;
}

/* ── TARJETA ── */
.order-card {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1.5px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 16px;
  padding: var(--espacio-4, 16px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
  transition: border-color 0.15s;
  position: relative;
}

.order-card:hover {
  border-color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
}

/* Línea de color izquierda según status */
.order-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 15%;
  bottom: 15%;
  width: 3px;
  background: var(--status-color);
  border-radius: 0 2px 2px 0;
  opacity: 0.7;
}

/* Cabecera */
.order-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  padding-bottom: var(--espacio-2, 8px);
}

.order-number {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
}

.order-time {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  background: color-mix(in srgb, var(--tenant-texto) 6%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent);
  border-radius: 20px;
  padding: 2px 8px;
}

/* Badge status */
.status-badge {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
}

.status-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-label {
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

/* Items */
.order-items {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--espacio-2, 8px);
  overflow-y: auto;
  scrollbar-width: none;
}

.order-items::-webkit-scrollbar { display: none; }

.order-item {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.order-item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-item-name {
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
}

.order-item-qty {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-primario);
}

.order-customizations {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.custom-tag {
  font-size: var(--font-size-xs, 11px);
  color: var(--color-advertencia, #d9a106);
  background: color-mix(in srgb, var(--color-advertencia, #d9a106) 8%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-advertencia, #d9a106) 15%, transparent);
  border-radius: 4px;
  padding: 1px 6px;
}

.order-extra {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  padding-left: var(--espacio-2, 8px);
}

.order-extra svg {
  width: 10px;
  height: 10px;
  flex-shrink: 0;
}

.extra-qty {
  color: var(--tenant-primario);
}

/* Footer */
.order-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-top: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  padding-top: var(--espacio-2, 8px);
}

.order-total {
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
}

.order-actions {
  display: flex;
  gap: var(--espacio-2, 8px);
}

.card-btn {
  width: 30px;
  height: 30px;
  border-radius: 8px;
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
}

.card-btn svg {
  width: 14px;
  height: 14px;
}

.card-btn--edit {
  color: var(--tenant-texto-muted, #78716c);
}

.card-btn--edit:hover {
  background: color-mix(in srgb, var(--tenant-primario) 10%, transparent);
  border-color: color-mix(in srgb, var(--tenant-primario) 25%, transparent);
  color: var(--tenant-primario);
}

.card-btn--delete {
  color: var(--tenant-texto-muted, #78716c);
}

.card-btn--delete:hover {
  background: color-mix(in srgb, var(--color-error, #dc2626) 10%, transparent);
  border-color: color-mix(in srgb, var(--color-error, #dc2626) 25%, transparent);
  color: var(--color-error, #dc2626);
}

/* ── VACÍO ── */
.orders-empty {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-4, 16px);
  padding: var(--espacio-12, 48px) 0;
  color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
}

.orders-empty svg {
  width: 48px;
  height: 48px;
}

.orders-empty p {
  margin: 0;
  font-size: var(--font-size-base, 15px);
}

/* ── WATERMARK ── */
.watermark {
  position: absolute;
  bottom: var(--espacio-5, 20px);
  right: var(--espacio-6, 24px);
  text-align: right;
  display: flex;
  flex-direction: column;
  gap: 1px;
  pointer-events: none;
}

.watermark-label {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.watermark-brand {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-primario);
  letter-spacing: -0.02em;
}
</style>