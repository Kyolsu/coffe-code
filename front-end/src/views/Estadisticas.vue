<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ─────────────────────────────
interface Venta {
  id: number
  total: number
  fecha: string
}

// ── MOCK DATA (luego lo conectas a órdenes) ─────────────
const ventas = ref<Venta[]>([
  { id: 1, total: 120, fecha: '2026-03-15' },
  { id: 2, total: 80,  fecha: '2026-03-16' },
  { id: 3, total: 150, fecha: '2026-03-17' },
  { id: 4, total: 60,  fecha: '2026-03-18' },
  { id: 5, total: 200, fecha: '2026-03-19' },
])

// ── FILTRO ────────────────────────────
const filtro = ref<'dia' | 'semana' | 'mes'>('semana')

const ventasFiltradas = computed(() => {
  const hoy = new Date()

  return ventas.value.filter(v => {
    const fecha = new Date(v.fecha)
    const diff = (hoy.getTime() - fecha.getTime()) / (1000 * 3600 * 24)

    if (filtro.value === 'dia') return diff <= 1
    if (filtro.value === 'semana') return diff <= 7
    if (filtro.value === 'mes') return diff <= 30

    return true
  })
})

// ── TOTAL ─────────────────────────────
const totalVentas = computed(() =>
  ventasFiltradas.value.reduce((acc, v) => acc + v.total, 0)
)

// ── GRÁFICA (SVG SIMPLE) ──────────────
const puntos = computed(() => {
  const max = Math.max(...ventasFiltradas.value.map(v => v.total), 1)

  return ventasFiltradas.value.map((v, i) => {
    const x = (i / (ventasFiltradas.value.length - 1 || 1)) * 280
    const y = 100 - (v.total / max) * 80
    return `${x},${y}`
  }).join(' ')
})
</script>

<template>
  <div class="layout">
    <Sidebar />

    <main class="main">

      <!-- HEADER -->
      <header class="header">
        <h1>Estadísticas</h1>

        <div class="filters">
          <button @click="filtro = 'dia'">Día</button>
          <button @click="filtro = 'semana'">Semana</button>
          <button @click="filtro = 'mes'">Mes</button>
        </div>
      </header>

      <!-- CARDS -->
      <div class="cards">

        <!-- TOTAL -->
        <div class="card">
          <span>Total ventas</span>
          <h2>${{ totalVentas }}</h2>
        </div>

        <!-- GRÁFICA -->
        <div class="card chart">
          <span>Ventas</span>

          <svg viewBox="0 0 300 120">
            <polyline
              :points="puntos"
              fill="none"
              stroke="#3f99ff"
              stroke-width="3"
            />
          </svg>
        </div>

      </div>

      <!-- HISTORIAL -->
      <div class="card table">
        <h3>Historial</h3>

        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Fecha</th>
              <th>Total</th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="v in ventasFiltradas" :key="v.id">
              <td>{{ v.id }}</td>
              <td>{{ v.fecha }}</td>
              <td>${{ v.total }}</td>
            </tr>
          </tbody>
        </table>

      </div>

    </main>
  </div>
</template>

<style scoped>
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

.filters button {
  margin-left: 10px;
  padding: 8px 12px;
  background: #3f99ff;
  border: none;
  color: white;
  border-radius: 6px;
  cursor: pointer;
}

/* CARDS */
.cards {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 15px;
  margin-bottom: 20px;
}

.card {
  background: #111;
  padding: 15px;
  border-radius: 10px;
  color: white;
}

.chart svg {
  width: 100%;
  height: 120px;
}

/* TABLE */
.table table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

.table th, .table td {
  padding: 10px;
  border-bottom: 1px solid #222;
}

.table th {
  text-align: left;
  color: #aaa;
}
</style>
