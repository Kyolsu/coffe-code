<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import API_URL from '../config/api'

const router = useRouter()
const authStore = useAuthStore()

const API_BASE = `${API_URL}/api`

// ── TIPOS ──────────────────────────────────────────────
interface OrderItem {
  name: string
  qty: number
  customizations: string[]
  extras: { name: string; qty: number }[]
  modifiers: string[]
  selections?: { name: string; modifiers: string[] }[]
}

interface Order {
  id: number
  id_orden: number
  numero_orden: number
  items: OrderItem[]
  status: 'pendiente'
  createdAt: string
}

// ── ROL ────────────────────────────────────────────────
const userRole = computed(() => authStore.rol || 'cocinero')
const isCocinero = computed(() => {
  const rol = String(userRole.value).toLowerCase()
  return rol === 'cocinero' || rol === 'cajero' || rol === '3'
})

// ── ESTADO ─────────────────────────────────────────────
const isLoading = ref(false)
const error = ref<string | null>(null)
let pollInterval: number | null = null

// Zonas
const zonas = ref<{ id_zona: number; nombre_zona: string }[]>([])
const selectedZona = ref<number | null>(null)

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

const loadZonas = async () => {
  const res = await fetchConToken('/tienda/zonas/mostrar')
  if (res.status === 'ok' && res.datos) {
    zonas.value = res.datos
  }
}

const loadOrders = async () => {
  isLoading.value = true
  error.value = null

  const [ordenesRes, detallesRes, modificadoresRes, seleccionesRes] = await Promise.all([
    fetchConToken('/ordenes/cocina'),
    fetchConToken('/ordenes/detalles/mostrar'),
    fetchConToken('/ordenes/detalles-modificadores/mostrar'),
    fetchConToken('/ordenes/selcciones-paquete')
  ])

  if (ordenesRes.status === 'ok' && ordenesRes.datos) {
    const detalles = detallesRes.datos || []
    const modificadores = modificadoresRes.datos || []
    const selecciones = seleccionesRes.datos || []

    orders.value = ordenesRes.datos
      .filter((o: any) => {
        const estado = (o.estado_orden || '').toLowerCase()
        return estado === 'pendiente' || estado === 'en proceso' || estado === 'preparando'
      })
      .map((o: any) => {
        let ordenDetalles = detalles.filter((d: any) => d.id_orden === o.id_orden)

        if (selectedZona.value !== null) {
          ordenDetalles = ordenDetalles.filter((d: any) => d.id_zona === selectedZona.value)
        }

        const items: OrderItem[] = ordenDetalles.map((d: any) => {
          const detailMods = modificadores.filter((m: any) => m.id_orden_detalle === d.id_orden_detalle)

          const itemMods = detailMods.map((m: any) => m.nombre_ingrediente)

          const itemSelections = d.id_paquete
            ? selecciones
                .filter((s: any) => s.id_orden_detalle === d.id_orden_detalle)
                .map((s: any) => {
                  const selMods = modificadores
                    .filter((m: any) => m.id_seleccion === s.id_seleccion)
                    .map((m: any) => m.nombre_ingrediente)
                  return {
                    name: s.nombre_producto || 'Opción',
                    modifiers: selMods
                  }
                })
            : undefined

          return {
            name: d.nombre_producto || d.nombre_paquete || 'Producto',
            qty: d.cantidad || 1,
            customizations: d.notas ? [d.notas] : [],
            extras: [],
            modifiers: itemMods,
            selections: itemSelections
          }
        })

        return {
          id: o.id_orden,
          id_orden: o.id_orden,
          numero_orden: o.numero_orden || o.id_orden,
          items,
          status: 'pendiente' as const,
          createdAt: o.fecha_creacion ? new Date(o.fecha_creacion).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' }) : '--:--'
        }
      })
      .filter((o: Order) => o.items.length > 0)
  } else {
    error.value = ordenesRes.mensaje || 'Error al cargar órdenes de cocina'
  }

  isLoading.value = false
}

// ── SELECCIÓN Y TECLADO ─────────────────────────────────
const selectedId = ref<number | null>(null)

const selectOrder = (id: number) => {
  selectedId.value = selectedId.value === id ? null : id
}

const markReady = async (id: number) => {
  const res = await fetchConToken(`/ordenes/modificar/${id}`, 'PUT', { estado_orden: 'lista' })

  if (res.status === 'ok') {
    orders.value = orders.value.filter(o => o.id !== id)
    selectedId.value = null
  } else {
    error.value = res.mensaje || 'Error al marcar orden como lista'
  }
}

const handleKeydown = (e: KeyboardEvent) => {
  if (e.key === 'Enter' && selectedId.value !== null) {
    markReady(selectedId.value)
  }
  if (e.key === 'Escape') {
    selectedId.value = null
  }
}

// ── POLLING ─────────────────────────────────────────────
const startPolling = () => {
  pollInterval = window.setInterval(() => {
    loadOrders()
  }, 5000) // 5 segundos para cocina
}

const stopPolling = () => {
  if (pollInterval) {
    clearInterval(pollInterval)
    pollInterval = null
  }
}

onMounted(async () => {
  await loadZonas()
  loadOrders()
  startPolling()
  window.addEventListener('keydown', handleKeydown)
})

watch(selectedZona, () => {
  loadOrders()
})

onUnmounted(() => {
  stopPolling()
  window.removeEventListener('keydown', handleKeydown)
})

// ── NAVEGACIÓN Y LOGOUT ─────────────────────────────────
const goBack = () => {
  router.push({ name: 'dashboard' })
}

const handleLogout = () => {
  localStorage.removeItem('coffe_token')
  router.push({ name: 'login' })
}
</script>

<template>
  <div class="kd-layout">

    <div v-if="isCocinero" class="floating-actions">
      <button class="btn-float btn-regresar" @click="goBack" title="Regresar al Dashboard">
        <svg viewBox="0 0 24 24" fill="none"><path d="M15 19l-7-7 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        Regresar
      </button>
      <button class="btn-float btn-salir" @click="handleLogout" title="Cerrar sesión">
        <svg viewBox="0 0 24 24" fill="none"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        Salir
      </button>
    </div>

    <main class="kd-main">

      <header class="kd-header">
        <div class="kd-header-center">
          <h1 class="kd-title">KD</h1>
          <span class="kd-subtitle">Kitchen Display</span>
        </div>

        <div class="kd-header-right">
          <div class="zona-selector">
            <select v-model="selectedZona" class="zona-select">
              <option :value="null">Todas las zonas</option>
              <option v-for="zona in zonas" :key="zona.id_zona" :value="zona.id_zona">
                {{ zona.nombre_zona }}
              </option>
            </select>
          </div>
          <div class="kd-count">
            <span v-if="isLoading" class="kd-loading">⟳</span>
            <span class="kd-count-number">{{ orders.length }}</span>
            <span class="kd-count-label">pendientes</span>
          </div>
          <div v-if="selectedId !== null" class="kd-hint">
            <kbd>Enter</kbd> para marcar como lista
            &nbsp;·&nbsp;
            <kbd>Esc</kbd> para deseleccionar
          </div>
        </div>
      </header>

      <div v-if="error" class="kd-error">
        {{ error }}
        <button @click="loadOrders">Reintentar</button>
      </div>

      <div class="kd-grid">
        <div v-if="orders.length === 0 && !isLoading" class="kd-empty">
          <svg viewBox="0 0 24 24" fill="none"><path d="M9 11l3 3L22 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          <p>Sin órdenes pendientes</p>
        </div>

        <div
          v-for="order in orders"
          :key="order.id"
          class="order-card"
          :class="{ selected: selectedId === order.id }"
          @click="selectOrder(order.id)"
          @dblclick="markReady(order.id)"
          :tabindex="0"
          @keydown.enter.stop="markReady(order.id)"
        >
          <div class="order-header">
            <span class="order-number">Orden: {{ order.numero_orden }}</span>
            <span class="order-time">{{ order.createdAt }}</span>
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
              <div v-if="item.selections && item.selections.length" class="order-selections">
                <div v-for="sel in item.selections" :key="sel.name" class="selection-item">
                  <span class="selection-name">{{ sel.name }}</span>
                  <div v-if="sel.modifiers.length" class="order-modifiers">
                    <span v-for="m in sel.modifiers" :key="m" class="modifier-tag">{{ m }}</span>
                  </div>
                </div>
              </div>
              <div v-else-if="item.modifiers.length" class="order-modifiers">
                <span v-for="m in item.modifiers" :key="m" class="modifier-tag">{{ m }}</span>
              </div>
              <div v-for="extra in item.extras" :key="extra.name" class="order-extra">
                <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                {{ extra.name }}
                <span class="extra-qty">× {{ extra.qty }}</span>
              </div>
            </div>
          </div>

          <Transition name="fade">
            <button
              v-if="selectedId === order.id"
              class="order-ready-btn"
              @click.stop="markReady(order.id)"
            >
              <svg viewBox="0 0 24 24" fill="none"><polyline points="20,6 9,17 4,12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
              Lista
            </button>
          </Transition>
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
.kd-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
  position: relative;
}

.kd-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: var(--espacio-5, 20px) var(--espacio-6, 24px);
  gap: var(--espacio-4, 16px);
  overflow: hidden;
  min-height: 0;
  position: relative;
}

/* ── ACCIONES FLOTANTES (Cocinero) ── */
.floating-actions {
  position: fixed;
  top: var(--espacio-4, 16px);
  left: var(--espacio-4, 16px);
  z-index: 100;
  display: flex;
  gap: var(--espacio-2, 8px);
}

.btn-float {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  border-radius: 10px;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif);
  transition: background 0.15s, border-color 0.15s;
}

.btn-float svg {
  width: 16px;
  height: 16px;
}

/* Regresar */
.btn-regresar {
  background: color-mix(in srgb, var(--tenant-texto) 6%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent);
  color: var(--tenant-texto);
}

.btn-regresar:hover {
  background: color-mix(in srgb, var(--tenant-texto) 12%, transparent);
  border-color: color-mix(in srgb, var(--tenant-texto) 30%, transparent);
}

/* Salir */
.btn-salir {
  background: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 8%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-cancelar, #fd8d8d) 20%, transparent);
  color: var(--color-cancelar, #fd8d8d);
}

.btn-salir:hover {
  background: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 15%, transparent);
  border-color: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 35%, transparent);
}


/* ── HEADER ── */
.kd-header {
  display: flex;
  align-items: center;
  justify-content: flex-end; /* Empuja el panel derecho a la esquina */
  position: relative;
  min-height: 48px;
}

/* Título Centrado Absoluto */
.kd-header-center {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: baseline;
  gap: var(--espacio-3, 12px);
  white-space: nowrap;
}

.kd-title {
  margin: 0;
  font-size: var(--font-size-3xl, 38px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
  line-height: 1;
}

.kd-subtitle {
  font-size: var(--font-size-sm, 13px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.1em;
}

/* Panel Derecho */
.kd-header-right {
  display: flex;
  align-items: center;
  gap: var(--espacio-4, 16px);
}

.kd-count {
  display: flex;
  align-items: baseline;
  gap: var(--espacio-2, 8px);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 10px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
}

.kd-count-number {
  font-size: var(--font-size-xl, 24px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--color-advertencia, #f59e0b);
  line-height: 1;
}

.kd-loading {
  font-size: 16px;
  animation: spin 1s linear infinite;
  margin-right: 4px;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.kd-error {
  background: color-mix(in srgb, var(--color-error, #ef4444) 10%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-error, #ef4444) 30%, transparent);
  color: var(--color-error, #ef4444);
  padding: var(--espacio-3, 12px);
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.kd-error button {
  background: var(--color-error, #ef4444);
  color: white;
  border: none;
  padding: 4px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.kd-count-label {
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.kd-hint {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

kbd {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 20%, transparent);
  border-radius: 4px;
  padding: 1px 6px;
  font-size: var(--font-size-xs, 11px);
  font-family: var(--tenant-fuente, monospace);
  color: var(--tenant-texto);
}

/* ── GRID DE ÓRDENES ── */
.kd-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: minmax(160px, auto);
  gap: var(--espacio-4, 16px);
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: color-mix(in srgb, var(--tenant-texto) 10%, transparent) transparent;
  align-content: start;
  min-height: 0;
}

/* ── TARJETA DE ORDEN ── */
.order-card {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1.5px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 16px;
  padding: var(--espacio-4, 16px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
  cursor: pointer;
  transition: border-color 0.15s, box-shadow 0.15s, transform 0.15s;
  position: relative;
  outline: none;
}

.order-card:hover {
  border-color: color-mix(in srgb, var(--tenant-primario) 40%, transparent);
  transform: translateY(-1px);
}

.order-card.selected {
  border-color: var(--color-exitoso, #22c55e);
  box-shadow: 0 0 0 1px var(--color-exitoso, #22c55e),
              0 8px 24px color-mix(in srgb, var(--color-exitoso, #22c55e) 12%, transparent);
}

/* Cabecera de la orden */
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
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent);
  border-radius: 20px;
  padding: 2px 8px;
}

/* Items dentro de la orden */
.order-items {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
  overflow-y: auto;
  scrollbar-width: none;
}

.order-items::-webkit-scrollbar {
  display: none;
}

.order-item {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-1, 4px);
}

.order-item-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--espacio-2, 8px);
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
  white-space: nowrap;
}

/* Personalizaciones */
.order-customizations {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espacio-1, 4px);
}

.custom-tag {
  font-size: var(--font-size-xs, 11px);
  color: var(--color-advertencia, #d97706);
  background: color-mix(in srgb, var(--color-advertencia, #d97706) 12%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-advertencia, #d97706) 20%, transparent);
  border-radius: 4px;
  padding: 1px 6px;
}

.order-selections {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-1, 4px);
  padding-left: var(--espacio-3, 12px);
  margin-top: 2px;
}

.selection-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.selection-name {
  font-size: var(--font-size-xs, 12px);
  font-weight: 600;
  color: var(--tenant-texto);
}

.order-modifiers {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espacio-1, 4px);
  padding-left: var(--espacio-2, 8px);
  margin-top: 2px;
}

.modifier-tag {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-primario);
  background: color-mix(in srgb, var(--tenant-primario) 12%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-primario) 20%, transparent);
  border-radius: 4px;
  padding: 1px 6px;
}

/* Extras */
.order-extra {
  display: flex;
  align-items: center;
  gap: var(--espacio-1, 4px);
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
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

/* Botón "Lista" al seleccionar */
.order-ready-btn {
  width: 100%;
  padding: var(--espacio-2, 8px);
  background: color-mix(in srgb, var(--color-exitoso, #22c55e) 10%, transparent);
  border: 1px solid color-mix(in srgb, var(--color-exitoso, #22c55e) 25%, transparent);
  border-radius: 10px;
  color: var(--color-exitoso, #22c55e);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-2, 8px);
  font-family: var(--tenant-fuente, sans-serif);
  transition: background 0.15s;
}

.order-ready-btn:hover {
  background: color-mix(in srgb, var(--color-exitoso, #22c55e) 18%, transparent);
}

.order-ready-btn svg {
  width: 16px;
  height: 16px;
}

/* Estado vacío */
.kd-empty {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-4, 16px);
  padding: var(--espacio-12, 48px) 0;
  color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
}

.kd-empty svg {
  width: 48px;
  height: 48px;
}

.kd-empty p {
  margin: 0;
  font-size: var(--font-size-base, 15px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
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
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.watermark-brand {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-primario);
  letter-spacing: -0.02em;
}

/* ── TRANSICIONES ── */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s, transform 0.15s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(4px);
}
</style>