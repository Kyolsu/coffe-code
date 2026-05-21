<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { API_URL } from '../config/api'

const router = useRouter()
const authStore = useAuthStore()
const API_BASE = `${API_URL}/api`

const userName = computed(() => authStore.nombreUsuario ?? 'Usuario')

const fechaActual = computed(() => {
  const opciones: Intl.DateTimeFormatOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
  return new Date().toLocaleDateString('es-MX', opciones)
})

const fetchConToken = async (endpoint: string) => {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, {
      headers: { 'auth-token': authStore.token || '', 'Content-Type': 'application/json' }
    })
    return await res.json()
  } catch { return { status: 'error', datos: [] } }
}

const fetchSinToken = async (endpoint: string) => {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`)
    return await res.json()
  } catch { return { status: 'error', datos: [] } }
}

const ventasHoy = ref(0)
const ordenesHoy = ref(0)
const clientesTotal = ref(0)
const ventasSemanales = ref<{ fecha: string; total: number }[]>([])
const actividadReciente = ref<any[]>([])

const getFechaLocal = (fechaISO: string | null | undefined): string => {
  if (!fechaISO) return ''
  const d = new Date(fechaISO)
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

const formatFechaCorta = (fecha: string): string => {
  const partes = fecha.split('-')
  if (partes.length !== 3) return fecha
  return `${partes[2]}/${partes[1]}`
}

const loadDashboardData = async () => {
  const [ordenesRes, clientesRes] = await Promise.all([
    fetchConToken('/ordenes/mostrar'),
    fetchSinToken('/clientes/mostrar-activos')
  ])

  const hoy = new Date()
  hoy.setHours(0, 0, 0, 0)
  const fechaHoyStr = getFechaLocal(hoy.toISOString())

  const todasOrdenes = ordenesRes.datos || []
  const ventasDelDia = todasOrdenes.filter((o: any) => {
    const fechaOrden = getFechaLocal(o.fecha_creacion)
    return fechaOrden === fechaHoyStr && o.estado_orden?.toLowerCase() !== 'cancelada'
  })

  ventasHoy.value = ventasDelDia.reduce((acc: number, o: any) => acc + (Number(o.total) || 0), 0)
  ordenesHoy.value = ventasDelDia.length

  clientesTotal.value = (clientesRes.datos || []).length

  const mapaSemanal = new Map<string, number>()
  const hace7dias = new Date(hoy)
  hace7dias.setDate(hace7dias.getDate() - 6)

  todasOrdenes.forEach((o: any) => {
    if (o.estado_orden?.toLowerCase() === 'cancelada') return
    const fechaOrden = getFechaLocal(o.fecha_creacion)
    if (fechaOrden >= getFechaLocal(hace7dias.toISOString())) {
      mapaSemanal.set(fechaOrden, (mapaSemanal.get(fechaOrden) || 0) + (Number(o.total) || 0))
    }
  })

  for (let i = 0; i < 7; i++) {
    const d = new Date(hace7dias)
    d.setDate(d.getDate() + i)
    const fechaStr = getFechaLocal(d.toISOString())
    if (!mapaSemanal.has(fechaStr)) {
      mapaSemanal.set(fechaStr, 0)
    }
  }

  ventasSemanales.value = Array.from(mapaSemanal.entries())
    .map(([fecha, total]) => ({ fecha, total }))
    .sort((a, b) => a.fecha.localeCompare(b.fecha))

  actividadReciente.value = todasOrdenes
    .filter((o: any) => o.estado_orden?.toLowerCase() !== 'cancelada')
    .sort((a: any, b: any) => new Date(b.fecha_creacion).getTime() - new Date(a.fecha_creacion).getTime())
    .slice(0, 5)

  const maxVenta = Math.max(...ventasSemanales.value.map(d => d.total), 1)
}

const formatCurrency = (value: number) => {
  return value.toLocaleString('es-MX', { style: 'currency', currency: 'MXN', minimumFractionDigits: 2 })
}

const formatTime = (fechaISO: string) => {
  const d = new Date(fechaISO)
  return d.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })
}

const chartPoints = computed(() => {
  const datos = ventasSemanales.value
  if (datos.length === 0) return ''
  const max = Math.max(...datos.map(d => d.total), 1)
  const width = 260
  const height = 110
  return datos.map((d, i) => {
    const x = (i / Math.max(datos.length - 1, 1)) * width
    const y = height - (d.total / max) * (height - 10)
    return `${x},${y}`
  }).join(' ')
})

const chartArea = computed(() => {
  const datos = ventasSemanales.value
  if (datos.length === 0) return ''
  const max = Math.max(...datos.map(d => d.total), 1)
  const width = 260
  const height = 110
  const puntos = datos.map((d, i) => {
    const x = (i / Math.max(datos.length - 1, 1)) * width
    const y = height - (d.total / max) * (height - 10)
    return `${x},${y}`
  })
  if (puntos.length === 0) return ''
  const first = puntos[0]!.split(',')
  const last = puntos[puntos.length - 1]!.split(',')
  return `M${puntos[0]} L${puntos.join(' L')} L${last[0]},${height} L${first[0]},${height} Z`
})

const chartDots = computed(() => {
  const datos = ventasSemanales.value
  if (datos.length === 0) return []
  const max = Math.max(...datos.map(d => d.total), 1)
  const width = 260
  const height = 110
  return datos.map((d, i) => ({
    x: (i / Math.max(datos.length - 1, 1)) * width,
    y: height - (d.total / max) * (height - 10),
    fecha: d.fecha
  }))
})

const chartLabels = computed(() => {
  return ventasSemanales.value.map(d => formatFechaCorta(d.fecha))
})

const irAVistaPublica = () => window.open('/menu-publico', '_blank')
const irAVenta = () => router.push({ name: 'venta' })
const irAClientes = () => router.push({ name: 'clientes' })
const irAMenu = () => router.push({ name: 'menu' })

onMounted(() => {
  loadDashboardData()
})
</script>

<template>
  <main class="dashboard-content">
    
    <header class="dashboard-header">
      <div class="header-left">
        <h1 class="greeting">¡Hola, <span class="accent">{{ userName }}</span>! 👋</h1>
        <p class="date-subtitle">{{ fechaActual }}</p>
      </div>
      <div class="user-profile">
        <div class="profile-avatar">
          {{ userName.charAt(0).toUpperCase() }}
        </div>
        <div class="profile-info">
          <span class="profile-name">{{ userName }}</span>
          <span class="profile-role">Administrador</span>
        </div>
      </div>
    </header>

    <section class="kpi-section">
      <div class="kpi-card">
        <div class="kpi-icon icon-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg></div>
        <div class="kpi-data">
          <span class="kpi-label">Ventas de hoy</span>
          <span class="kpi-value">{{ formatCurrency(ventasHoy) }}</span>
        </div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon icon-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg></div>
        <div class="kpi-data">
          <span class="kpi-label">Órdenes del día</span>
          <span class="kpi-value">{{ ordenesHoy }}</span>
        </div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon icon-orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"></path></svg></div>
        <div class="kpi-data">
          <span class="kpi-label">Clientes</span>
          <span class="kpi-value">{{ clientesTotal }}</span>
        </div>
      </div>
    </section>

    <section class="actions-section">
      <h2 class="section-title">Acciones Rápidas</h2>
      <div class="actions-grid">
        
        <div class="action-card cta-card" @click="irAVenta">
          <div class="card-content">
            <div class="cta-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
            </div>
            <div class="cta-text">
              <h3>Nueva Venta</h3>
              <p>Abrir terminal POS</p>
            </div>
          </div>
          <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"></path></svg>
        </div>

        <div class="action-card" @click="irAVistaPublica">
          <div class="card-content">
            <div class="mini-icon icon-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg></div>
            <div class="cta-text">
              <h3>Vista Pública</h3>
              <p>Menú para clientes</p>
            </div>
          </div>
        </div>

        <div class="action-card" @click="irAMenu">
          <div class="card-content">
            <div class="mini-icon icon-gray"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h18v18H3zM21 9H3M21 15H3M9 3v18M15 3v18"></path></svg></div>
            <div class="cta-text">
              <h3>Inventario</h3>
              <p>Gestionar productos</p>
            </div>
          </div>
        </div>

        <div class="action-card" @click="irAClientes">
          <div class="card-content">
            <div class="mini-icon icon-orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg></div>
            <div class="cta-text">
              <h3>Directorio</h3>
              <p>Gestión de clientes</p>
            </div>
          </div>
        </div>

      </div>
    </section>

    <section class="bottom-section">
      <div class="chart-container">
        <h2 class="section-title">Ventas por Día</h2>
        <div class="chart-wrapper">
          <svg class="chart-svg" viewBox="0 0 260 110" preserveAspectRatio="none">
            <defs>
              <linearGradient id="chartGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stop-color="var(--tenant-primario)" stop-opacity="0.3"/>
                <stop offset="100%" stop-color="var(--tenant-primario)" stop-opacity="0"/>
              </linearGradient>
            </defs>
            <path v-if="chartArea" :d="chartArea" fill="url(#chartGradient)"/>
            <polyline v-if="chartPoints" :points="chartPoints" fill="none" stroke="var(--tenant-primario)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <circle v-for="(dot, i) in chartDots" :key="i" :cx="dot.x" :cy="dot.y" r="3" fill="var(--tenant-primario)"/>
          </svg>
          <div class="chart-labels">
            <span v-for="(label, i) in chartLabels" :key="i">{{ label }}</span>
          </div>
        </div>
      </div>

      <div class="activity-container">
        <h2 class="section-title">Actividad Reciente</h2>
        <div v-if="actividadReciente.length > 0" class="activity-list">
          <div v-for="item in actividadReciente" :key="item.id_orden" class="activity-item">
            <div class="activity-info">
              <span class="activity-ticket">{{ item.numero_orden || `#${item.id_orden}` }}</span>
              <span class="activity-time">{{ formatTime(item.fecha_creacion) }}</span>
            </div>
            <span class="activity-total">{{ formatCurrency(Number(item.total) || 0) }}</span>
          </div>
        </div>
        <div v-else class="empty-activity">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
          <p>No hay actividad registrada aún.</p>
          <span>Las últimas ventas aparecerán aquí.</span>
        </div>
      </div>
    </section>

    <div class="watermark">
      <span class="watermark-label">Software</span>
      <strong class="watermark-brand">CoffeeCode</strong>
    </div>
  </main>
</template>

<style scoped>
/* ── CONTENEDOR PRINCIPAL ── */
.dashboard-content {
  flex: 1;
  padding: var(--espacio-6, 24px) var(--espacio-8, 32px);
  position: relative;
  display: flex;
  flex-direction: column;
  gap: var(--espacio-8, 32px);
  overflow-y: auto;
  background-color: var(--tenant-fondo, #f9fafb);
  min-height: 100vh;
}

/* ── HEADER ── */
.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-left { display: flex; flex-direction: column; gap: 4px; }
.greeting { margin: 0; font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #111827); line-height: 1.1; }
.accent { color: var(--tenant-primario, #002D72); }
.date-subtitle { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); text-transform: capitalize; }

.user-profile { display: flex; align-items: center; gap: var(--espacio-3, 12px); background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 50px; padding: 6px 16px 6px 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
.profile-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--tenant-secundario, #5C2D6D); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 16px; flex-shrink: 0; }
.profile-info { display: flex; flex-direction: column; gap: 2px; }
.profile-name { font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #111827); line-height: 1; }
.profile-role { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); line-height: 1; }

.section-title { font-size: var(--font-size-md, 17px); font-weight: 600; color: var(--tenant-texto, #111827); margin: 0 0 var(--espacio-4, 16px) 0; }

/* ── KPIs ── */
.kpi-section { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: var(--espacio-4, 16px); }
.kpi-card { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 12px; padding: var(--espacio-4, 16px); display: flex; align-items: center; gap: var(--espacio-4, 16px); box-shadow: 0 1px 2px rgba(0,0,0,0.02); }
.kpi-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.kpi-icon svg { width: 24px; height: 24px; }
.icon-green { background: rgba(22, 163, 74, 0.1); color: var(--color-exitoso, #16a34a); }
.icon-blue { background: rgba(37, 99, 235, 0.1); color: var(--color-info, #2563eb); }
.icon-orange { background: rgba(217, 119, 6, 0.1); color: var(--color-advertencia, #d97706); }
.kpi-data { display: flex; flex-direction: column; gap: 4px; }
.kpi-label { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); font-weight: 500; }
.kpi-value { font-size: var(--font-size-xl, 24px); font-weight: 700; color: var(--tenant-texto, #111827); line-height: 1; }

/* ── ACCIONES RÁPIDAS ── */
/* Bajé la proporción de la primera tarjeta de 2fr a 1.2fr para que no se vea tan larga */
.actions-grid { display: grid; grid-template-columns: 1.2fr 1fr 1fr 1fr; gap: var(--espacio-4, 16px); }
.action-card { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 12px; padding: var(--espacio-4, 16px); cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; justify-content: space-between; }
.action-card:hover { transform: translateY(-2px); border-color: var(--tenant-primario, #002D72); box-shadow: 0 4px 12px rgba(0, 45, 114, 0.08); }
.card-content { display: flex; align-items: center; gap: var(--espacio-3, 12px); }
.cta-text h3 { margin: 0 0 2px 0; font-size: var(--font-size-base, 15px); font-weight: 600; color: var(--tenant-texto, #111827); }
.cta-text p { margin: 0; font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); }

/* Main CTA */
.cta-card { background: linear-gradient(135deg, var(--tenant-primario) 0%, #0040a0 100%); color: white; border: none; }
.cta-card .cta-text h3, .cta-card .cta-text p { color: white; }
.cta-icon { background: rgba(255,255,255,0.2); width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
.cta-icon svg { width: 22px; height: 22px; color: white; }

/* Aquí limitamos la flecha rebelde */
.arrow-icon { width: 20px; height: 20px; flex-shrink: 0; color: white; opacity: 0.7; transition: transform 0.2s, opacity 0.2s; }
.cta-card:hover .arrow-icon { transform: translateX(4px); opacity: 1; }

/* Secondary Actions */
.mini-icon { width: 38px; height: 38px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
.mini-icon svg { width: 18px; height: 18px; }
.icon-purple { background: rgba(92, 45, 109, 0.1); color: var(--tenant-secundario, #5C2D6D); }
.icon-gray { background: rgba(107, 114, 128, 0.1); color: #6b7280; }
.icon-orange { background: rgba(217, 119, 6, 0.1); color: var(--color-advertencia, #d97706); }

/* ── BOTTOM SECTION ── */
.bottom-section { display: grid; grid-template-columns: 2fr 1fr; gap: var(--espacio-6, 24px); }

.chart-container, .activity-container { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 12px; padding: var(--espacio-5, 20px); display: flex; flex-direction: column; }
.chart-wrapper { flex: 1; display: flex; flex-direction: column; margin-top: 8px; }
.chart-svg { width: 100%; height: 160px; }
.chart-labels { display: flex; justify-content: space-between; padding: 0 4px; margin-top: 8px; }
.chart-labels span { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); }

/* ── ACTIVITY LIST ── */
.activity-list { display: flex; flex-direction: column; gap: 12px; }
.activity-item { display: flex; justify-content: space-between; align-items: center; padding: 10px 12px; background: color-mix(in srgb, var(--tenant-texto) 3%, transparent); border-radius: 8px; }
.activity-info { display: flex; flex-direction: column; gap: 2px; }
.activity-ticket { font-size: var(--font-size-sm, 13px); font-weight: 600; color: var(--tenant-texto, #111827); }
.activity-time { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); }
.activity-total { font-size: var(--font-size-sm, 13px); font-weight: 700; color: var(--tenant-primario, #002D72); }

/* ── WATERMARK ── */
.watermark { position: absolute; bottom: var(--espacio-4, 16px); right: var(--espacio-8, 32px); text-align: right; display: flex; flex-direction: column; gap: 1px; pointer-events: none; opacity: 0.6; }
.watermark-label { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); text-transform: uppercase; letter-spacing: 0.08em; }
.watermark-brand { font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-primario, #002D72); letter-spacing: -0.02em; }

/* Responsive adjustments */
@media (max-width: 1024px) {
  .actions-grid { grid-template-columns: 1fr 1fr; }
  .cta-card { grid-column: span 2; }
  .bottom-section { grid-template-columns: 1fr; }
}
</style>