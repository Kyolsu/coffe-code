<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'

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
  orderNumber: number
  status: OrderStatus
  items: OrderItem[]
  createdAt: string
  total: number
}

// ── ESTADO ─────────────────────────────────────────────

// TODO: GET /ordenes — reemplazar mock con datos de API
const orders = ref<Order[]>([
  {
    id: 1, orderNumber: 45, status: 'pendiente', createdAt: '10:02', total: 100,
    items: [
      { name: 'Chilaquiles',    qty: 1, customizations: ['Verde', 'Queso', 'Crema'], extras: [{ name: 'Pollo', qty: 1 }] },
      { name: 'Plato de fruta', qty: 3, customizations: ['Miel', 'Granola'],          extras: [] },
    ],
  },
  {
    id: 2, orderNumber: 46, status: 'preparacion', createdAt: '10:05', total: 55,
    items: [{ name: 'Enchiladas', qty: 2, customizations: ['Rojas'], extras: [] }],
  },
  {
    id: 3, orderNumber: 47, status: 'lista', createdAt: '10:08', total: 106,
    items: [
      { name: 'Café americano', qty: 1, customizations: [],             extras: [] },
      { name: 'Cappuccino',     qty: 2, customizations: ['Sin azúcar'], extras: [] },
    ],
  },
  {
    id: 4, orderNumber: 48, status: 'entregada', createdAt: '10:10', total: 75,
    items: [{ name: 'Huevos rancheros', qty: 1, customizations: ['Salsa roja'], extras: [{ name: 'Tocino', qty: 2 }] }],
  },
  {
    id: 5, orderNumber: 49, status: 'pendiente', createdAt: '10:12', total: 75,
    items: [{ name: 'Jugo de naranja', qty: 3, customizations: [], extras: [] }],
  },
  {
    id: 6, orderNumber: 50, status: 'cancelada', createdAt: '10:15', total: 90,
    items: [{ name: 'Paquete desayuno', qty: 1, customizations: ['Sin frijoles'], extras: [{ name: 'Extra crema', qty: 1 }] }],
  },
])

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
const statusMeta: Record<OrderStatus, { label: string; color: string }> = {
  pendiente:   { label: 'Pendiente',   color: 'var(--color-orden-pendiente, #f59e0b)' },
  preparacion: { label: 'Preparación', color: 'var(--color-orden-preparacion, #3b82f6)' },
  lista:       { label: 'Lista',       color: 'var(--color-orden-lista, #22c55e)' },
  entregada:   { label: 'Entregada',   color: 'var(--color-orden-entregada, #6b7280)' },
  cancelada:   { label: 'Cancelada',   color: 'var(--color-orden-cancelada, #ef4444)' },
}

// ── ACCIONES ────────────────────────────────────────────
const editOrder   = (id: number) => { /* TODO: abrir modal de edición — PATCH /ordenes/:id */ console.log('edit', id) }
const deleteOrder = (id: number) => { /* TODO: DELETE /ordenes/:id */ orders.value = orders.value.filter(o => o.id !== id) }
</script>

<template>
  <div class="ordenes-layout">
    <Sidebar />

    <main class="ordenes-main">

      <!-- Header -->
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
        <h1 class="page-title">Órdenes</h1>
      </header>

      <!-- Grid -->
      <div class="orders-grid">
        <div
          v-for="order in filteredOrders"
          :key="order.id"
          class="order-card"
          :style="{ '--status-color': statusMeta[order.status].color }"
        >
          <!-- Cabecera -->
          <div class="order-header">
            <span class="order-number">Orden: {{ order.orderNumber }}</span>
            <span class="order-time">{{ order.createdAt }}</span>
          </div>

          <!-- Badge de estado -->
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

          <!-- Items -->
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

          <!-- Footer: total + acciones -->
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

        <!-- Estado vacío -->
        <div v-if="filteredOrders.length === 0" class="orders-empty">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <p>Sin órdenes en esta categoría</p>
        </div>
      </div>

      <!-- Watermark -->
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
  background-color: var(--tenant-fondo, #000);
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
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
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
  border-color: #2a2a2a;
  color: var(--tenant-texto, #fff);
}

.filter-chip.active {
  background: var(--tenant-primario, #3f99ff);
  border-color: var(--tenant-primario, #3f99ff);
  color: #fff;
}

.page-title {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
  white-space: nowrap;
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
  scrollbar-color: #1e1e1e transparent;
  align-content: start;
  min-height: 0;
}

/* ── TARJETA ── */
.order-card {
  background: #0e0e0e;
  border: 1.5px solid #1c1c1c;
  border-radius: 16px;
  padding: var(--espacio-4, 16px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
  transition: border-color 0.15s;
  position: relative;
}

.order-card:hover {
  border-color: #2a2a2a;
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
  border-bottom: 1px solid #1a1a1a;
  padding-bottom: var(--espacio-2, 8px);
}

.order-number {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
}

.order-time {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  background: #181818;
  border: 1px solid #222;
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
  color: var(--tenant-texto, #fff);
}

.order-item-qty {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-primario, #3f99ff);
}

.order-customizations {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.custom-tag {
  font-size: var(--font-size-xs, 11px);
  color: var(--color-advertencia, #d9a106);
  background: rgba(217, 161, 6, 0.08);
  border: 1px solid rgba(217, 161, 6, 0.15);
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
  color: var(--tenant-primario, #3f99ff);
}

/* Footer */
.order-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-top: 1px solid #1a1a1a;
  padding-top: var(--espacio-2, 8px);
}

.order-total {
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
}

.order-actions {
  display: flex;
  gap: var(--espacio-2, 8px);
}

.card-btn {
  width: 30px;
  height: 30px;
  border-radius: 8px;
  border: 1px solid #1e1e1e;
  background: #111;
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
  background: rgba(63, 153, 255, 0.1);
  border-color: rgba(63, 153, 255, 0.25);
  color: var(--tenant-primario, #3f99ff);
}

.card-btn--delete {
  color: var(--tenant-texto-muted, #78716c);
}

.card-btn--delete:hover {
  background: rgba(220, 38, 38, 0.1);
  border-color: rgba(220, 38, 38, 0.25);
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
  color: #2a2a2a;
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
  color: var(--tenant-primario, #3f99ff);
  letter-spacing: -0.02em;
}
</style>