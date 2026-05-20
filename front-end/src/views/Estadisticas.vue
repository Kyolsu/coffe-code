<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { API_URL } from '../config/api'

const API_BASE = `${API_URL}/api`
const authStore = useAuthStore()

// ── TIPOS ─────────────────────────────
interface Venta {
  id_orden: number
  total: number
  fecha: string
  estado_orden: string
  id_cliente: number | null
  nombre_cliente: string | null
}

interface Cliente {
  id_cliente: number
  nombre: string
}

interface StatsDia {
  fecha: string
  total: number
  count: number
}

// ── FETCH ─────────────────────────────
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
    return { status: 'error', datos: [] }
  }
}

const fetchSinToken = async (endpoint: string) => {
  try {
    const response = await fetch(`${API_BASE}${endpoint}`)
    const data = await response.json()
    return data
  } catch (err) {
    console.error(`Error en ${endpoint}:`, err)
    return { status: 'error', datos: [] }
  }
}

// ── ESTADO ─────────────────────────────
const isLoading = ref(false)
const ventas = ref<Venta[]>([])
const clientes = ref<Cliente[]>([])
const filtro = ref<'dia' | 'semana' | 'mes'>('semana')
const filtroCliente = ref<string>('todos')

// ── CARGA DE DATOS ─────────────────────
const loadData = async () => {
  isLoading.value = true

  const [ordenesRes, clientesRes] = await Promise.all([
    fetchConToken('/ordenes/mostrar'),
    fetchSinToken('/clientes/mostrar-activos')
  ])

  if (ordenesRes.status === 'ok' && ordenesRes.datos) {
    ventas.value = ordenesRes.datos
      .filter((o: any) => o.estado_orden?.toLowerCase() !== 'cancelada' && o.estado_orden?.toLowerCase() !== 'cancelado')
      .map((o: any) => ({
        id_orden: o.id_orden,
        total: Number(o.total) || 0,
        fecha: o.fecha_creacion ? o.fecha_creacion.split('T')[0] : new Date().toISOString().split('T')[0],
        estado_orden: o.estado_orden,
        id_cliente: o.id_cliente || null,
        nombre_cliente: o.cliente || null
      }))
  }

  if (clientesRes.status === 'ok' && clientesRes.datos) {
    clientes.value = clientesRes.datos
  }

  isLoading.value = false
}

// ── FILTRO ─────────────────────────────
const ventasFiltradas = computed(() => {
  const hoy = new Date()
  hoy.setHours(0, 0, 0, 0)

  return ventas.value.filter(v => {
    const fecha = new Date(v.fecha)
    fecha.setHours(0, 0, 0, 0)
    const diff = (hoy.getTime() - fecha.getTime()) / (1000 * 3600 * 24)

    if (filtro.value === 'dia') {
      if (diff > 1) return false
    }
    if (filtro.value === 'semana') {
      if (diff > 7) return false
    }
    if (filtro.value === 'mes') {
      if (diff > 30) return false
    }

    if (filtroCliente.value === 'sin_cliente') {
      return v.id_cliente === null
    }
    if (filtroCliente.value !== 'todos') {
      return v.id_cliente === Number(filtroCliente.value)
    }

    return true
  }).sort((a, b) => new Date(a.fecha).getTime() - new Date(b.fecha).getTime())
})

// ── AGRUPACIÓN POR DÍA ─────────────────
const ventasPorDia = computed((): StatsDia[] => {
  const mapa = new Map<string, { total: number; count: number }>()

  ventasFiltradas.value.forEach(v => {
    const existente = mapa.get(v.fecha) || { total: 0, count: 0 }
    mapa.set(v.fecha, {
      total: existente.total + v.total,
      count: existente.count + 1
    })
  })

  return Array.from(mapa.entries())
    .map(([fecha, data]) => ({ fecha, ...data }))
    .sort((a, b) => new Date(a.fecha).getTime() - new Date(b.fecha).getTime())
})

// ── KPIs ─────────────────────────────
const totalVentas = computed(() =>
  ventasFiltradas.value.reduce((acc, v) => acc + v.total, 0)
)

const totalOrdenes = computed(() => ventasFiltradas.value.length)

const ticketPromedio = computed(() => {
  if (totalOrdenes.value === 0) return 0
  return totalVentas.value / totalOrdenes.value
})

const ordenesPorEstado = computed(() => {
  const mapa = new Map<string, number>()
  ventasFiltradas.value.forEach(v => {
    const estado = v.estado_orden || 'desconocido'
    mapa.set(estado, (mapa.get(estado) || 0) + 1)
  })
  return Object.fromEntries(mapa)
})

// ── GRÁFICA ─────────────────────────────
const puntosGrafica = computed(() => {
  const datos = ventasPorDia.value
  if (datos.length === 0) return ''

  const max = Math.max(...datos.map(d => d.total), 1)
  const width = 280
  const height = 80

  return datos.map((d, i) => {
    const x = datos.length === 1 ? width / 2 : (i / (datos.length - 1)) * width
    const y = height - (d.total / max) * (height - 10)
    return `${x},${y}`
  }).join(' ')
})

const pathArea = computed(() => {
  const datos = ventasPorDia.value
  if (datos.length === 0) return ''

  const max = Math.max(...datos.map(d => d.total), 1)
  const width = 280
  const height = 80

  const puntos = datos.map((d, i) => {
    const x = datos.length === 1 ? width / 2 : (i / (datos.length - 1)) * width
    const y = height - (d.total / max) * (height - 10)
    return `${x},${y}`
  })

  const primerPunto = puntos[0]?.replace(',', ',')
  const ultimoPunto = puntos[puntos.length - 1]?.replace(',', ',')

  return `M${primerPunto} L${puntos.join(' L')} L${ultimoPunto} L${ultimoPunto?.split(',')[0]},${height} L${primerPunto?.split(',')[0]},${height} Z`
})

onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="layout">
    <main class="main">

      <header class="header">
        <div class="header-left">
          <h1>Estadísticas</h1>
          <span v-if="isLoading" class="loading-indicator">⟳</span>
        </div>

        <div class="filters">
          <select v-model="filtroCliente" class="filtro-cliente">
            <option value="todos">Todos los clientes</option>
            <option value="sin_cliente">Sin registro</option>
            <option v-for="c in clientes" :key="c.id_cliente" :value="String(c.id_cliente)">
              {{ c.nombre }}
            </option>
          </select>

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

      <div class="kpi-grid">
        <div class="card kpi">
          <span>Total Ventas</span>
          <h2>${{ totalVentas.toFixed(2) }}</h2>
        </div>

        <div class="card kpi">
          <span>Órdenes</span>
          <h2>{{ totalOrdenes }}</h2>
        </div>

        <div class="card kpi">
          <span>Ticket Promedio</span>
          <h2>${{ ticketPromedio.toFixed(2) }}</h2>
        </div>
      </div>

      <div class="charts-row">
        <div class="card chart">
          <span>Ventas por Día</span>

          <svg viewBox="0 0 300 100" class="chart-svg">
            <defs>
              <linearGradient id="areaGradient" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" style="stop-color:var(--tenant-primario);stop-opacity:0.3" />
                <stop offset="100%" style="stop-color:var(--tenant-primario);stop-opacity:0" />
              </linearGradient>
            </defs>

            <path
              v-if="pathArea"
              :d="pathArea"
              fill="url(#areaGradient)"
              class="chart-area"
            />

            <polyline
              v-if="puntosGrafica"
              :points="puntosGrafica"
              fill="none"
              class="chart-line"
              stroke-width="3"
              stroke-linecap="round"
              stroke-linejoin="round"
            />

            <g v-for="(d, i) in ventasPorDia" :key="d.fecha">
              <circle
                :cx="ventasPorDia.length === 1 ? 140 : (i / (ventasPorDia.length - 1)) * 280"
                :cy="80 - (d.total / Math.max(...ventasPorDia.map(x => x.total), 1)) * 70"
                r="4"
                class="chart-dot"
              />
              <text
                v-if="ventasPorDia.length <= 7"
                :x="ventasPorDia.length === 1 ? 140 : (i / (ventasPorDia.length - 1)) * 280"
                y="95"
                class="chart-label"
              >
                {{ new Date(d.fecha).toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit' }) }}
              </text>
            </g>
          </svg>
        </div>

        <div class="card chart">
          <span>Órdenes por Estado</span>

          <div class="estado-list">
            <div
              v-for="(count, estado) in ordenesPorEstado"
              :key="estado"
              class="estado-item"
            >
              <span class="estado-label">{{ estado }}</span>
              <div class="estado-bar-container">
                <div
                  class="estado-bar"
                  :style="{ width: `${(count / totalOrdenes) * 100}%` }"
                ></div>
              </div>
              <span class="estado-count">{{ count }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="card table">
        <h3>Historial de Órdenes</h3>

        <table>
          <thead>
            <tr>
              <th>ID Orden</th>
              <th>Fecha</th>
              <th>Cliente</th>
              <th>Estado</th>
              <th>Total</th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="v in ventasFiltradas.slice(0, 20)" :key="v.id_orden">
              <td>#{{ v.id_orden }}</td>
              <td>{{ new Date(v.fecha).toLocaleDateString('es-MX') }}</td>
              <td>{{ v.nombre_cliente || '—' }}</td>
              <td>
                <span :class="['estado-badge', v.estado_orden?.toLowerCase()]">
                  {{ v.estado_orden }}
                </span>
              </td>
              <td>${{ v.total.toFixed(2) }}</td>
            </tr>
          </tbody>
        </table>

        <p v-if="ventasFiltradas.length === 0" class="no-data">
          No hay datos en el período seleccionado
        </p>
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

.header-left {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
}

.header h1 {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
}

.loading-indicator {
  font-size: 18px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.filters {
  display: flex;
  gap: var(--espacio-2, 8px);
  align-items: center;
}

.filtro-cliente {
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  color: var(--tenant-texto);
  border-radius: 6px;
  cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif);
  font-size: var(--font-size-sm, 13px);
  min-width: 140px;
}

.filtro-cliente option {
  background: var(--tenant-fondo);
  color: var(--tenant-texto);
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

/* ── KPIs ── */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--espacio-4, 16px);
  margin-bottom: var(--espacio-5, 20px);
}

.kpi {
  text-align: center;
  padding: var(--espacio-5, 20px);
}

.kpi span {
  display: block;
  font-size: var(--font-size-sm, 13px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.kpi h2 {
  margin: 8px 0 0 0;
  font-size: 2rem;
  color: var(--tenant-texto);
  font-weight: var(--font-weight-bold, 600);
}

/* ── CHARTS ROW ── */
.charts-row {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: var(--espacio-4, 16px);
  margin-bottom: var(--espacio-5, 20px);
}

.card {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  padding: var(--espacio-5, 20px);
  border-radius: 12px;
}

.card span {
  display: block;
  font-size: var(--font-size-sm, 13px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-weight: var(--font-weight-medium, 500);
  margin-bottom: var(--espacio-3, 12px);
}

/* Gráfica */
.chart-svg {
  width: 100%;
  height: 100px;
}

.chart-line {
  stroke: var(--tenant-primario);
  transition: all 0.3s ease;
}

.chart-area {
  fill: url(#areaGradient);
}

.chart-dot {
  fill: var(--tenant-primario);
}

.chart-label {
  font-size: 9px;
  fill: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-anchor: middle;
}

/* Estados */
.estado-list {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
}

.estado-item {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
}

.estado-label {
  width: 90px;
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto);
  text-transform: capitalize;
}

.estado-bar-container {
  flex: 1;
  height: 8px;
  background: color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 4px;
  overflow: hidden;
}

.estado-bar {
  height: 100%;
  background: var(--tenant-primario);
  border-radius: 4px;
  transition: width 0.3s ease;
}

.estado-count {
  width: 30px;
  text-align: right;
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto);
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

.estado-badge {
  padding: 2px 8px;
  border-radius: 4px;
  font-size: var(--font-size-xs, 11px);
  text-transform: capitalize;
}

.estado-badge.pendiente,
.estado-badge.en proceso {
  background: color-mix(in srgb, var(--color-advertencia, #f59e0b) 15%, transparent);
  color: var(--color-advertencia, #f59e0b);
}

.estado-badge.lista,
.estado-badge.completada,
.estado-badge.entregada {
  background: color-mix(in srgb, var(--color-exitoso, #22c55e) 15%, transparent);
  color: var(--color-exitoso, #22c55e);
}

.estado-badge.cancelada,
.estado-badge.cancelado {
  background: color-mix(in srgb, var(--color-error, #ef4444) 15%, transparent);
  color: var(--color-error, #ef4444);
}

.no-data {
  text-align: center;
  color: color-mix(in srgb, var(--tenant-texto) 40%, transparent);
  padding: var(--espacio-6, 24px);
}
</style>