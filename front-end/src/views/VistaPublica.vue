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

// ── CAMBIO DE ESTADO ──────────────────
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
              class="card pendiente"
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
              class="card preparacion"
              @click="avanzarEstado(o)"
            >
              {{ formato(o) }}
            </div>
          </div>
        </div>

        <!-- ENTREGADOS -->
        <div class="column green">
          <h2>Entregados</h2>

          <div class="list">
            <div
              v-for="o in entregadas"
              :key="o.id"
              class="card entregada"
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
  background: #000;
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

.header h1 {
  color: white;
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
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  border-radius: 12px;
  padding: 10px;
}

.column h2 {
  text-align: center;
  padding: 10px;
  border-radius: 8px;
  color: white;
}

/* COLORS HEADER */
.red h2 {
  background: #c92a00;

}

.yellow h2 {
  background: #e0c95a;
  color: black;
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

/* CARD BASE */
.card {

  padding: 15px 20px;
  border-radius: 20px;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.1s, opacity 0.1s;
}

/* HOVER */
.card:hover {
  transform: scale(1.05);
  opacity: 0.9;
}

/* ESTADOS */
.pendiente {
  background: #e74c3c;
  color: white;
}

.preparacion {
  background: #f1c40f;
  color: black;
}

.entregada {
  background: #2ecc71;
  color: white;
  cursor: default;
}
</style>

