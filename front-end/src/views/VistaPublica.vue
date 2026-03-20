<script setup lang="ts">
import { ref } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ─────────────────────────────
type Estado = 'pendiente' | 'preparacion' | 'entregado'
type Origen = 'A' | 'B'

interface Pedido {
  id: number
  numero: number
  origen: Origen
  estado: Estado
}

// ── ESTADO ────────────────────────────
const pedidos = ref<Pedido[]>([])
const contador = ref(0)

// ── GENERAR PEDIDO ────────────────────
const generarPedido = (origen: Origen) => {
  contador.value = (contador.value + 1) % 100

  pedidos.value.push({
    id: Date.now(),
    numero: contador.value,
    origen,
    estado: 'pendiente'
  })
}

// ── CAMBIAR ESTADO ────────────────────
const cambiarEstado = (pedido: Pedido) => {
  if (pedido.estado === 'pendiente') {
    pedido.estado = 'preparacion'
  } else if (pedido.estado === 'preparacion') {
    pedido.estado = 'entregado'
  }
}

// ── FILTROS ───────────────────────────
const pendientes = () => pedidos.value.filter(p => p.estado === 'pendiente')
const preparacion = () => pedidos.value.filter(p => p.estado === 'preparacion')
const entregados = () => pedidos.value.filter(p => p.estado === 'entregado')

// ── FORMATO ───────────────────────────
const formatoPedido = (p: Pedido) => `${p.numero}${p.origen}`
</script>

<template>
  <div class="layout">
    <Sidebar />

    <main class="main">

      <!-- HEADER -->
      <header class="header">
        <h1 class="title">Control de Pedidos</h1>

        <div class="acciones">
          <button @click="generarPedido('A')">Nuevo A</button>
          <button @click="generarPedido('B')">Nuevo B</button>
        </div>
      </header>

      <!-- COLUMNAS -->
      <div class="tablero">

        <!-- PENDIENTES -->
        <div class="columna pendiente">
          <h2>Pedidos en espera</h2>

          <div class="lista">
            <div
              v-for="p in pendientes()"
              :key="p.id"
              class="pedido"
              @click="cambiarEstado(p)"
            >
              {{ formatoPedido(p) }}
            </div>
          </div>
        </div>

        <!-- PREPARACION -->
        <div class="columna preparacion">
          <h2>Pedidos en preparación</h2>

          <div class="lista">
            <div
              v-for="p in preparacion()"
              :key="p.id"
              class="pedido"
              @click="cambiarEstado(p)"
            >
              {{ formatoPedido(p) }}
            </div>
          </div>
        </div>

        <!-- ENTREGADOS -->
        <div class="columna entregado">
          <h2>Pedidos completados</h2>

          <div class="lista">
            <div
              v-for="p in entregados()"
              :key="p.id"
              class="pedido"
            >
              {{ formatoPedido(p) }}
            </div>
          </div>
        </div>

      </div>

    </main>
  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
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
  align-items: center;
  margin-bottom: 20px;
}

.title {
  color: white;
}

.acciones button {
  margin-left: 10px;
  padding: 10px;
  border: none;
  border-radius: 8px;
  background: #3f99ff;
  color: white;
  cursor: pointer;
}

/* TABLERO */
.tablero {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  height: calc(100vh - 120px);
}

/* COLUMNAS */
.columna {
  background: #ddd;
  border-radius: 10px;
  padding: 10px;
  display: flex;
  flex-direction: column;
}

.columna h2 {
  text-align: center;
  padding: 10px;
  margin: 0;
  border-radius: 8px;
  font-size: 16px;
}

/* COLORES */
.pendiente h2 {
  background: #c92a00;
  color: white;
}

.preparacion h2 {
  background: #e0c95a;
}

.entregado h2 {
  background: #6ccf4f;
  color: white;
}

/* LISTA */
.lista {
  margin-top: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

/* PEDIDOS */
.pedido {
  background: #e38b73;
  padding: 12px 20px;
  border-radius: 20px;
  cursor: pointer;
  font-weight: bold;
}

.preparacion .pedido {
  background: #e6dd9c;
}

.entregado .pedido {
  background: #8be36f;
}
</style>

