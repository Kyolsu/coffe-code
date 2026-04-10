<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

// Nombre real desde el store
const userName = computed(() => authStore.nombreUsuario ?? 'Usuario')

// Fecha actual formateada
const fechaActual = computed(() => {
  const opciones: Intl.DateTimeFormatOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
  return new Date().toLocaleDateString('es-MX', opciones)
})

// Funciones de navegación
const irAVistaPublica = () => router.push({ name: 'vista-publica' })
const irAVenta = () => router.push({ name: 'venta' })
const irAClientes = () => router.push({ name: 'clientes' })
const irAMenu = () => router.push({ name: 'menu' })
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
          <span class="kpi-value">$0.00</span>
        </div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon icon-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg></div>
        <div class="kpi-data">
          <span class="kpi-label">Órdenes del día</span>
          <span class="kpi-value">0</span>
        </div>
      </div>
      <div class="kpi-card">
        <div class="kpi-icon icon-orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"></path></svg></div>
        <div class="kpi-data">
          <span class="kpi-label">Nuevos Clientes</span>
          <span class="kpi-value">0</span>
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
        <h2 class="section-title">Resumen de Ventas de la Semana</h2>
        <div class="chart-wrapper">
          <svg class="chart-svg" viewBox="0 0 280 110" preserveAspectRatio="none">
            <defs>
              <linearGradient id="chartGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stop-color="var(--tenant-primario)" stop-opacity="0.3"/>
                <stop offset="100%" stop-color="var(--tenant-primario)" stop-opacity="0"/>
              </linearGradient>
            </defs>
            <path d="M0,88 C20,78 30,65 46,60 C62,55 72,75 93,58 C114,42 118,30 140,28 C162,26 168,50 186,42 C205,34 215,18 280,10 L280,110 L0,110 Z" fill="url(#chartGradient)"/>
            <path d="M0,88 C20,78 30,65 46,60 C62,55 72,75 93,58 C114,42 118,30 140,28 C162,26 168,50 186,42 C205,34 215,18 280,10" fill="none" stroke="var(--tenant-primario)" stroke-width="2" stroke-linecap="round"/>
            <circle cx="0" cy="88" r="3" fill="var(--tenant-primario)"/>
            <circle cx="46" cy="60" r="3" fill="var(--tenant-primario)"/>
            <circle cx="93" cy="58" r="3" fill="var(--tenant-primario)"/>
            <circle cx="140" cy="28" r="3.5" fill="var(--tenant-primario)"/>
            <circle cx="186" cy="42" r="3" fill="var(--tenant-primario)"/>
            <circle cx="280" cy="10" r="3.5" fill="var(--tenant-primario)"/>
          </svg>
          <div class="chart-labels">
            <span>Lun</span><span>Mar</span><span>Mié</span><span>Jue</span><span>Vie</span><span>Sáb</span>
          </div>
        </div>
      </div>

      <div class="activity-container">
        <h2 class="section-title">Actividad Reciente</h2>
        <div class="empty-activity">
           <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
           <p>No hay actividad registrada aún.</p>
           <span>Las últimas ventas aparecerán aquí.</span>
        </div>
      </div>
    </section>

    <div class="watermark">
      <span class="watermark-label">Software por</span>
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

.empty-activity { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; color: var(--tenant-texto-muted, #6b7280); padding: var(--espacio-4, 16px) 0; }
.empty-activity svg { width: 32px; height: 32px; opacity: 0.5; margin-bottom: 12px; }
.empty-activity p { margin: 0 0 4px 0; font-size: var(--font-size-sm, 13px); font-weight: 500; color: var(--tenant-texto, #111827); }
.empty-activity span { font-size: var(--font-size-xs, 11px); }

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