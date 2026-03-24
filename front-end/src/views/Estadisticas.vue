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

      <header class="header">
        <h1>Estadísticas</h1>

        <div class="filters">
          <button 
            :class="{ active: filtro === 'dia' }" 
            @click="filtro = 'dia'"
          >
            Día
          </button>
          <button 
            :class="{ active: filtro === 'semana' }" 
            @click="filtro = 'semana'"
          >
            Semana
          </button>
          <button 
            :class="{ active: filtro === 'mes' }" 
            @click="filtro = 'mes'"
          >
            Mes
          </button>
        </div>
      </header>

      <div class="cards">

        <div class="card">
          <span>Total ventas</span>
          <h2>${{ totalVentas }}</h2>
        </div>

        <div class="card chart">
          <span>Ventas</span>

          <svg viewBox="0 0 300 120">
            <polyline
              :points="puntos"
              fill="none"
              class="chart-line"
              stroke-width="3"
            />
          </svg>
        </div>

      </div>

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
/* ── LAYOUT ── */
.layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
  color: var(--tenant-texto);
  font-family: var(--tenant-fuente, sans-serif);
}

.main {
  flex: 1;
  padding: var(--espacio-5, 20px);
  overflow-y: auto;
}

/* ── HEADER ── */
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--espacio-5, 20px);
}

.header h1 {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
}

.filters {
  display: flex;
  gap: var(--espacio-2, 8px);
}

.filters button {
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  border-radius: 6px;
  cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif);
  font-weight: var(--font-weight-medium, 500);
  font-size: var(--font-size-sm, 13px);
  transition: background 0.15s, border-color 0.15s, color 0.15s;
}

.filters button:hover {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  color: var(--tenant-texto);
}

.filters button.active {
  background: var(--tenant-primario);
  border-color: var(--tenant-primario);
  color: #fff;
}

/* ── CARDS ── */
.cards {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: var(--espacio-4, 15px);
  margin-bottom: var(--espacio-5, 20px);
}

.card {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  padding: var(--espacio-5, 20px);
  border-radius: 12px;
  display: flex;
  flex-direction: column;
}

.card span {
  font-size: var(--font-size-sm, 13px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-weight: var(--font-weight-medium, 500);
}

.card h2 {
  margin: 10px 0 0 0;
  font-size: 2.5rem;
  color: var(--tenant-texto);
  font-weight: var(--font-weight-bold, 600);
}

/* Gráfica */
.chart svg {
  width: 100%;
  height: 120px;
  margin-top: 10px;
}

.chart-line {
  stroke: var(--tenant-primario);
  transition: all 0.3s ease;
}

/* ── TABLA ── */
.table h3 {
  margin: 0 0 15px 0;
  font-size: var(--font-size-lg, 18px);
  color: var(--tenant-texto);
}

.table table {
  width: 100%;
  border-collapse: collapse;
}

.table th, .table td {
  padding: 12px 10px;
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  text-align: left;
}

.table th {
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.table td {
  font-size: var(--font-size-base, 15px);
  color: var(--tenant-texto);
}

.table tbody tr {
  transition: background 0.15s;
}

.table tbody tr:hover {
  background: color-mix(in srgb, var(--tenant-texto) 2%, transparent);
}
</style>