<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ──────────────────────────────────────────────
type OrderStatus = 'pendiente' | 'preparacion' | 'lista' | 'entregada'
type Origen = 'A' | 'B'

interface OrderItem {
  name: string
  qty: number
  customizations: string[]
  extras: { name: string; qty: number }[]
}

interface Order {
  id: number
  orderNumber: number
  origen: Origen
  status: OrderStatus
  items: OrderItem[]
  createdAt: string
  total: number
}

// ── CONTADOR GLOBAL (0–99) ─────────────────────────────
const contador = ref(0)

const generarNumeroOrden = () => {
  contador.value = (contador.value + 1) % 100
  return contador.value
}

// ── ESTADO ─────────────────────────────────────────────
const orders = ref<Order[]>([])

// MOCK INICIAL
orders.value = [
  {
    id: 1,
    orderNumber: 45,
    origen: 'A',
    status: 'pendiente',
    createdAt: '10:02',
    total: 100,
    items: [
      { name: 'Chilaquiles', qty: 1, customizations: ['Verde'], extras: [] },
    ],
  },
]

// ── CREAR ORDEN ────────────────────────────────────────
const crearOrden = (origen: Origen) => {
  orders.value.push({
    id: Date.now(),
    orderNumber: generarNumeroOrden(),
    origen,
    status: 'pendiente',
    createdAt: new Date().toLocaleTimeString(),
    total: 0,
    items: []
  })
}

// ── FILTRO POR STATUS ───────────────────────────────────
const statusFilters: { label: string; value: OrderStatus | 'todas' }[] = [
  { label: 'Todas', value: 'todas' },
  { label: 'Pendientes', value: 'pendiente' },
  { label: 'Preparación', value: 'preparacion' },
  { label: 'Listas', value: 'lista' },
  { label: 'Entregadas', value: 'entregada' },
]

const activeFilter = ref<OrderStatus | 'todas'>('todas')

const filteredOrders = computed(() =>
  activeFilter.value === 'todas'
    ? orders.value
    : orders.value.filter(o => o.status === activeFilter.value)
)

// ── DATOS PARA TABLERO ─────────────────────────────────
const ordenesPendientes = computed(() =>
  orders.value.filter(o => o.status === 'pendiente')
)

const ordenesPreparacion = computed(() =>
  orders.value.filter(o =>
    o.status === 'preparacion' || o.status === 'lista'
  )
)

const ordenesEntregadas = computed(() =>
  orders.value.filter(o => o.status === 'entregada')
)

// ── COLORES POR STATUS ──────────────────────────────────
const statusMeta: Record<OrderStatus, { label: string; color: string }> = {
  pendiente:   { label: 'Pendiente',   color: '#f59e0b' },
  preparacion: { label: 'Preparación', color: '#3b82f6' },
  lista:       { label: 'Lista',       color: '#22c55e' },
  entregada:   { label: 'Entregada',   color: '#6b7280' },
}

// ── ACCIONES ────────────────────────────────────────────
const editOrder = (id: number) => {
  console.log('edit', id)
}

const deleteOrder = (id: number) => {
  if (confirm('¿Eliminar orden?')) {
    orders.value = orders.value.filter(o => o.id !== id)
  }
}
</script>

<template>
  <div class="ordenes-layout">
    <Sidebar />

    <main class="ordenes-main">

      <!-- HEADER -->
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

        <!-- BOTONES NUEVA ORDEN -->
        <div>
          <button @click="crearOrden('A')" class="btn">Nueva A</button>
          <button @click="crearOrden('B')" class="btn">Nueva B</button>
        </div>
      </header>

      <!-- GRID -->
      <div class="orders-grid">
        <div
          v-for="order in filteredOrders"
          :key="order.id"
          class="order-card"
          :style="{ '--status-color': statusMeta[order.status].color }"
        >
          <!-- CABECERA -->
          <div class="order-header">
            <span class="order-number">
              Orden: {{ order.orderNumber }}{{ order.origen }}
            </span>
            <span class="order-time">{{ order.createdAt }}</span>
          </div>

          <!-- STATUS -->
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

          <!-- ITEMS -->
          <div class="order-items">
            <div v-for="(item, i) in order.items" :key="i">
              {{ item.name }} × {{ item.qty }}
            </div>
          </div>

          <!-- FOOTER -->
          <div class="order-footer">
            <span>${{ order.total }}</span>

            <div class="order-actions">
              <button @click="editOrder(order.id)">✏️</button>
              <button @click="deleteOrder(order.id)">🗑️</button>
            </div>
          </div>
        </div>

        <!-- VACÍO -->
        <div v-if="filteredOrders.length === 0" class="orders-empty">
          Sin órdenes
        </div>
      </div>

    </main>
  </div>
</template>

<style scoped>
.ordenes-layout {
  display: flex;
  min-height: 100vh;
  background: #000;
}

.ordenes-main {
  flex: 1;
  padding: 20px;
}

.ordenes-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  
}

.btn {
  margin-left: 10px;
  padding: 8px;
  background: #3f99ff;
  color: white;
  border: none;
  border-radius: 8px;
}

.orders-grid {
  margin-top: 20px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;

}

.order-card {
  background: #111;
  padding: 10px;
  border-radius: 10px;

}

.order-number {
  color: white;
}

.orders-empty {
  color: gray;
}
</style>

