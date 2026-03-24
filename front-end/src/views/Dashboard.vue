<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const router    = useRouter()
const authStore = useAuthStore()

// Nombre real desde el store (lo guardó el login)
const userName = computed(() => authStore.nombreUsuario ?? 'Usuario')

// Funciones de navegación para las tarjetas
const irAVistaPublica = () => router.push({ name: 'vista-publica' })
const irAVenta = () => router.push({ name: 'venta' })
const irAClientes = () => router.push({ name: 'clientes' })
const irAMenu = () => router.push({ name: 'menu' })
</script>

<template>
  <div class="dashboard-layout">
    <Sidebar />

    <main class="dashboard-content">
      <header class="dashboard-header">
        <div class="header-left">
          <p class="header-greeting">Panel de control</p>
          <h1>¡Bienvenido, <span class="accent">{{ userName }}</span>!</h1>
        </div>
        <div class="user-profile">
          <div class="profile-avatar">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="profile-info">
            <span class="profile-name">{{ userName }}</span>
            <span class="profile-role">Administrador</span>
          </div>
        </div>
      </header>

      <div class="dashboard-grid">

        <!-- Vista Pública -->
        <div class="card clickable card--action" @click="irAVistaPublica">
          <div class="card-icon card-icon--globe">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.5"/>
              <path d="M12 3c-2.4 3-4 5.6-4 9s1.6 6 4 9M12 3c2.4 3 4 5.6 4 9s-1.6 6-4 9M3 12h18" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="card-body">
            <h3 class="card-title">Vista Pública</h3>
            <p class="card-desc">Ir al menú del cliente</p>
          </div>
          <div class="card-arrow">
            <svg viewBox="0 0 24 24" fill="none"><path d="M5 12h14M13 6l6 6-6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>

        <!-- Producto más vendido -->
        <div class="card card--product">
          <div class="card-label">Producto más vendido</div>
          <div class="product-highlight">
            <div class="product-emoji">⭐</div>
            <div class="product-info">
              <span class="product-name">Próximamente</span>
              <span class="product-badge">Top ventas</span>
            </div>
          </div>
        </div>

        <!-- Iniciar Venta -->
        <div class="card clickable card--cta" @click="irAVenta">
          <div class="card-icon card-icon--sale">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
              <line x1="3" y1="6" x2="21" y2="6" stroke="currentColor" stroke-width="1.5"/>
              <path d="M16 10a4 4 0 01-8 0" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="card-body">
            <h3 class="card-title">Iniciar Venta</h3>
            <p class="card-desc">Nueva transacción</p>
          </div>
          <div class="card-arrow">
            <svg viewBox="0 0 24 24" fill="none"><path d="M5 12h14M13 6l6 6-6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>

        <!-- Gráfico de actividad -->
        <div class="card card--chart">
          <div class="card-label">Actividad de ventas</div>
          <div class="chart-wrapper">
            <svg class="chart-svg" viewBox="0 0 280 110" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg">
              <!-- Área rellena bajo la línea -->
              <defs>
                <linearGradient id="chartGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stop-color="var(--tenant-primario)" stop-opacity="0.25"/>
                  <stop offset="100%" stop-color="var(--tenant-primario)" stop-opacity="0"/>
                </linearGradient>
              </defs>
              <path
                d="M0,88 C20,78 30,65 46,60 C62,55 72,75 93,58 C114,42 118,30 140,28 C162,26 168,50 186,42 C205,34 215,18 280,10 L280,110 L0,110 Z"
                fill="url(#chartGradient)"
              />
              <!-- Línea principal -->
              <path
                d="M0,88 C20,78 30,65 46,60 C62,55 72,75 93,58 C114,42 118,30 140,28 C162,26 168,50 186,42 C205,34 215,18 280,10"
                fill="none"
                stroke="var(--tenant-primario)"
                stroke-width="2"
                stroke-linecap="round"
              />
              <!-- Puntos -->
              <circle cx="0"   cy="88" r="3" fill="var(--tenant-primario)"/>
              <circle cx="46"  cy="60" r="3" fill="var(--tenant-primario)"/>
              <circle cx="93"  cy="58" r="3" fill="var(--tenant-primario)"/>
              <circle cx="140" cy="28" r="3.5" fill="var(--tenant-primario)"/>
              <circle cx="186" cy="42" r="3" fill="var(--tenant-primario)"/>
              <circle cx="280" cy="10" r="3" fill="var(--tenant-primario)"/>
            </svg>
            <div class="chart-labels">
              <span>Lun</span><span>Mar</span><span>Mié</span><span>Jue</span><span>Vie</span><span>Sáb</span>
            </div>
          </div>
        </div>

        <!-- Clientes -->
        <div class="card clickable card--action" @click="irAClientes">
          <div class="card-icon card-icon--clients">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="card-body">
            <h3 class="card-title">Clientes</h3>
            <p class="card-desc">Ver directorio</p>
          </div>
          <div class="card-arrow">
            <svg viewBox="0 0 24 24" fill="none"><path d="M5 12h14M13 6l6 6-6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>

        <!-- Productos -->
        <div class="card clickable card--action" @click="irAMenu">
          <div class="card-icon card-icon--products">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <rect x="3" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/>
              <rect x="14" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/>
              <rect x="3" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/>
              <rect x="14" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/>
            </svg>
          </div>
          <div class="card-body">
            <h3 class="card-title">Productos</h3>
            <p class="card-desc">Gestionar menú</p>
          </div>
          <div class="card-arrow">
            <svg viewBox="0 0 24 24" fill="none"><path d="M5 12h14M13 6l6 6-6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
          </div>
        </div>

      </div>

      <div class="watermark">
        <span class="watermark-label">Software por</span>
        <strong class="watermark-brand">CoffeeCode</strong>
      </div>
    </main>
  </div>
</template>

<style scoped>
.dashboard-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo, #f5f0eb);
}

/* ── CONTENT ── */
.dashboard-content {
  flex: 1;
  padding: var(--espacio-8, 32px) var(--espacio-8, 32px) var(--espacio-6, 24px);
  position: relative;
  display: flex;
  flex-direction: column;
  gap: var(--espacio-6, 24px);
  overflow-y: auto;
}

/* ── HEADER ── */
.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.header-greeting {
  margin: 0;
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto-muted, #7c6a5a);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  font-weight: var(--font-weight-medium, 500);
}

.dashboard-header h1 {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
  line-height: 1.1;
}

.accent {
  color: var(--tenant-primario, #c2600a);
}

.user-profile {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 50px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px) var(--espacio-2, 8px) var(--espacio-2, 8px);
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}

.profile-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(194, 96, 10, 0.1);
  border: 1.5px solid rgba(194, 96, 10, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--tenant-primario, #c2600a);
  flex-shrink: 0;
}

.profile-avatar svg {
  width: 18px;
  height: 18px;
}

.profile-info {
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.profile-name {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
  line-height: 1;
}

.profile-role {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #7c6a5a);
  line-height: 1;
}

/* ── GRID ── */
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto auto;
  gap: var(--espacio-4, 16px);
  flex: 1;
}

/* ── CARDS ── */
.card {
  background-color: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 16px;
  padding: var(--espacio-5, 20px);
  display: flex;
  flex-direction: column;
  color: var(--tenant-texto, #1c1410);
  transition: border-color 0.2s, transform 0.2s, box-shadow 0.2s;
  position: relative;
  overflow: hidden;
}

.card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 16px;
  opacity: 0;
  transition: opacity 0.2s;
  background: radial-gradient(circle at 30% 30%, rgba(194, 96, 10, 0.03), transparent 60%);
}

.clickable {
  cursor: pointer;
}

.clickable:hover {
  transform: translateY(-3px);
  border-color: var(--tenant-primario, #c2600a);
  box-shadow: 0 8px 24px rgba(194, 96, 10, 0.1);
}

.clickable:hover::before {
  opacity: 1;
}

.card-label {
  font-size: var(--font-size-xs, 11px);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--tenant-texto-muted, #7c6a5a);
  font-weight: var(--font-weight-medium, 500);
  margin-bottom: var(--espacio-3, 12px);
}

/* Action cards */
.card--action {
  flex-direction: row;
  align-items: center;
  gap: var(--espacio-4, 16px);
  min-height: 90px;
}

.card--action .card-body {
  flex: 1;
}

.card-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.card-icon svg {
  width: 20px;
  height: 20px;
}

.card-icon--globe {
  background: rgba(194, 96, 10, 0.1);
  color: var(--tenant-primario, #c2600a);
}

.card-icon--sale {
  background: rgba(22, 163, 74, 0.1);
  color: var(--color-exitoso, #16a34a);
}

.card-icon--clients {
  background: rgba(217, 119, 6, 0.1);
  color: var(--color-advertencia, #d97706);
}

.card-icon--products {
  background: rgba(107, 114, 128, 0.1);
  color: #6b7280;
}

.card-title {
  margin: 0 0 2px;
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
}

.card-desc {
  margin: 0;
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #7c6a5a);
}

.card-arrow {
  color: var(--color-borde, #e8ddd5);
  width: 18px;
  height: 18px;
  flex-shrink: 0;
  transition: color 0.2s, transform 0.2s;
}

.card-arrow svg {
  width: 18px;
  height: 18px;
}

.clickable:hover .card-arrow {
  color: var(--tenant-primario, #c2600a);
  transform: translateX(3px);
}

/* CTA card (Iniciar Venta) */
.card--cta {
  border-color: rgba(22, 163, 74, 0.3);
  background: linear-gradient(135deg, #fff 0%, rgba(22, 163, 74, 0.04) 100%);
}

.card--cta:hover {
  border-color: rgba(22, 163, 74, 0.6) !important;
}

/* Product card */
.card--product {
  flex-direction: column;
  justify-content: space-between;
}

.product-highlight {
  display: flex;
  align-items: center;
  gap: var(--espacio-4, 16px);
  margin-top: auto;
}

.product-emoji {
  font-size: 2.5rem;
  line-height: 1;
}

.product-info {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-1, 4px);
}

.product-name {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
}

.product-badge {
  display: inline-block;
  background: rgba(194, 96, 10, 0.1);
  color: var(--tenant-primario, #c2600a);
  border: 1px solid rgba(194, 96, 10, 0.2);
  border-radius: 20px;
  padding: 2px 10px;
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
}

/* Chart card — spans 2 rows */
.card--chart {
  grid-column: 1 / 2;
  grid-row: 2 / 4;
  justify-content: flex-start;
  min-height: 200px;
}

.chart-wrapper {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--espacio-2, 8px);
  margin-top: var(--espacio-2, 8px);
}

.chart-svg {
  flex: 1;
  width: 100%;
  height: 100%;
  min-height: 120px;
}

.chart-labels {
  display: flex;
  justify-content: space-between;
  padding: 0 2px;
}

.chart-labels span {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #7c6a5a);
}

/* ── WATERMARK ── */
.watermark {
  position: absolute;
  bottom: var(--espacio-6, 24px);
  right: var(--espacio-8, 32px);
  text-align: right;
  display: flex;
  flex-direction: column;
  gap: 1px;
  pointer-events: none;
}

.watermark-label {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #7c6a5a);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.watermark-brand {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-primario, #c2600a);
  letter-spacing: -0.02em;
}
</style>