<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ─────────────────────────────
type OrderStatus = 'pendiente' | 'preparacion' | 'entregada'
type Origen = 'A' | 'B'



interface Order {
  id: number
  orderNumber: number
  origen: Origen
  status: OrderStatus

  createdAt: string

}

// ── CONTADOR (0–99) ───────────────────
const contador = ref(0)

const generarNumeroOrden = () => {
  contador.value = (contador.value + 1) % 100
  return contador.value
}

// ── ESTADO ────────────────────────────
const orders = ref<Order[]>([])

// ── CREAR ORDEN ───────────────────────
const crearOrden = (origen: Origen) => {
  orders.value.push({
    id: Date.now(),
    orderNumber: generarNumeroOrden(),
    origen,
    status: 'pendiente',
    createdAt: new Date().toLocaleTimeString()
  })
}

// ── CAMBIO DE ESTADO (flujo) ──────────
const avanzarEstado = (order: Order) => {
  if (order.status === 'pendiente') {
    order.status = 'preparacion'
  } else if (order.status === 'preparacion') {
    order.status = 'entregada'
  }
}

// ── COLUMNAS ──────────────────────────
const pendientes = computed(() =>
  orders.value.filter(o => o.status === 'pendiente')
)

const preparacion = computed(() =>
  orders.value.filter(o => o.status === 'preparacion')
)

const entregadas = computed(() =>
  orders.value.filter(o => o.status === 'entregada')
)

// ── FORMATO ───────────────────────────
const formato = (o: Order) => `${o.orderNumber}${o.origen}`
</script>

<template>
  <div class="layout">
    <Sidebar />

    <main class="main">

      <!-- HEADER -->
      <header class="header">
        <h1>Pedidos</h1>

        <div>
          <button @click="crearOrden('A')">Nuevo A</button>
          <button @click="crearOrden('B')">Nuevo B</button>
        </div>
      </header>

      <!-- COLUMNAS -->
      <div class="board">

        <!-- PENDIENTES -->
        <div class="column red">
          <h2>Pendientes</h2>

          <div class="list">
            <div
              v-for="o in pendientes"
              :key="o.id"
              class="card"
              @click="avanzarEstado(o)"
            >
              {{ formato(o) }}
            </div>
          </div>
        </div>

        <!-- PREPARACIÓN -->
        <div class="column yellow">
          <h2>En preparación</h2>

          <div class="list">
            <div
              v-for="o in preparacion"
              :key="o.id"
              class="card"
              @click="avanzarEstado(o)"
            >
              {{ formato(o) }}
            </div>
          </div>
        </div>

        <!-- ENTREGADAS -->
        <div class="column green">
          <h2>Entregados</h2>

          <div class="list">
            <div
              v-for="o in entregadas"
              :key="o.id"
              class="card"
            >
              {{ formato(o) }}
            </div>
          </div>
        </div>


      </div>

    </main>
  </div>
</template>

<style scoped>
/* LAYOUT */
.layout {
  display: flex;
  min-height: 100vh;
  background: #111;
}

.main {
  flex: 1;
  padding: 20px;
}

/* HEADER */
.header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

button {
  margin-left: 10px;
  padding: 10px;
  background: #3f99ff;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}

/* BOARD */
.board {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
  height: calc(100vh - 120px);
}

/* COLUMN */
.column {
  background: #ddd;
  border-radius: 10px;
  padding: 10px;
}

.column h2 {
  text-align: center;
  padding: 10px;
  border-radius: 8px;
}

/* COLORS */
.red h2 {
  background: #c92a00;
  color: white;
}

.yellow h2 {
  background: #e0c95a;
}

.green h2 {
  background: #6ccf4f;
}

/* LIST */
.list {
  margin-top: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

/* CARD */
.card {
  background: white;
  padding: 15px 20px;
  border-radius: 20px;
  font-weight: bold;
  cursor: pointer;
}
</style>

