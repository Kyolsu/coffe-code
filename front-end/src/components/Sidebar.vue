<script setup lang="ts">
import { ref, computed } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router    = useRouter()
const authStore = useAuthStore()

const isCollapsed = ref(false)

// userRole para lógicas adicionales
const userRole = computed(() => authStore.rol)


// Permisos por vista: 1=dashboard, 2=venta, 3=menu, 4=ordenes, 5=cocina, 6=clientes, 7=estadisticas, 8=usuarios, 9=personalizacion
const puedeDashboard        = computed(() => authStore.tienePermiso(1))
const puedeVenta            = computed(() => authStore.tienePermiso(2))
const puedeMenu             = computed(() => authStore.tienePermiso(3))
const puedeOrdenes          = computed(() => authStore.tienePermiso(4))
const puedeCocina           = computed(() => authStore.tienePermiso(5))
const puedeClientes         = computed(() => authStore.tienePermiso(6))
const puedeEstadisticas     = computed(() => authStore.tienePermiso(7))
const puedeUsuarios         = computed(() => authStore.tienePermiso(8))
const puedePersonalizacion  = computed(() => authStore.tienePermiso(9))
// Permisos por vista: 1=dashboard, 2=venta, 3=menu, 4=ordenes, 5=cocina, 6=clientes, 7=estadisticas, 8=usuarios

const toggleSidebar = () => {
  isCollapsed.value = !isCollapsed.value
}

const handleLogout = () => {
  authStore.logout()
  router.push({ name: 'login' })
}
</script>

<template>
  <aside :class="['sidebar', { 'collapsed': isCollapsed }]">

    <!-- Header: toggle + logo -->
    <div class="sidebar-header">
      <button @click="toggleSidebar" class="toggle-btn" :title="isCollapsed ? 'Expandir' : 'Colapsar'">
        <svg viewBox="0 0 24 24" fill="none">
          <path d="M4 6h16M4 12h16M4 18h16" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
      </button>
      <Transition name="fade">
        <div v-if="!isCollapsed" class="logo-container">
          <div class="logo-circle"><span>Logo</span></div>
        </div>
      </Transition>
    </div>

    <!-- Nav -->
    <nav class="sidebar-nav">

      <RouterLink v-if="puedeDashboard" to="/dashboard" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
            <path d="M9 21V12h6v9" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Inicio</span>
      </RouterLink>

      <RouterLink v-if="puedeVenta" to="/venta" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
            <line x1="3" y1="6" x2="21" y2="6" stroke="currentColor" stroke-width="1.5"/>
            <path d="M16 10a4 4 0 01-8 0" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Ventas</span>
      </RouterLink>

      <RouterLink v-if="puedeMenu" to="/menu" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M18 8h1a4 4 0 010 8h-1M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8zM6 2v3M10 2v3M14 2v3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Inventario</span>
      </RouterLink>

      <RouterLink v-if="puedeOrdenes" to="/ordenes" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <path d="M9 12h6M9 16h4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Órdenes</span>
      </RouterLink>

      <!-- KD — visible para admin, gerente y cocinero -->
      <RouterLink v-if="puedeCocina" to="/cocina" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <rect x="2" y="3" width="20" height="14" rx="2" stroke="currentColor" stroke-width="1.5"/>
            <path d="M8 21h8M12 17v4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <path d="M7 8l3 3 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Cocina (KD)</span>
      </RouterLink>

      <RouterLink v-if="puedeClientes" to="/clientes" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="1.5"/>
            <path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Clientes</span>
      </RouterLink>

      <RouterLink v-if="puedeEstadisticas" to="/estadisticas" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M18 20V10M12 20V4M6 20v-6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Estadísticas</span>
      </RouterLink>

      <a href="/menu-publico" target="_blank" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
            <line x1="8" y1="21" x2="16" y2="21"></line>
            <line x1="12" y1="17" x2="12" y2="21"></line>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Vista Pública</span>
      </a>

      <!-- Solo usuarios con permiso 4 (administrar usuarios) -->
      <template v-if="puedeUsuarios || puedePersonalizacion">
        <div v-if="!isCollapsed" class="nav-divider"></div>

        <RouterLink v-if="puedeUsuarios" to="/usuarios" class="nav-item">
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </span>
          <span v-if="!isCollapsed" class="nav-label">Usuarios</span>
        </RouterLink>

        <RouterLink v-if="puedePersonalizacion" to="/personalizacion" class="nav-item">
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M12 2L2 7l10 5 10-5-10-5z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
              <path d="M2 17l10 5 10-5M2 12l10 5 10-5" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
            </svg>
          </span>
          <span v-if="!isCollapsed" class="nav-label">Personalizar</span>
        </RouterLink>

      </template>

    </nav>

    <!-- Footer: perfil + logout -->
    <div class="sidebar-footer">
      <RouterLink to="/perfil" class="perfil-link" :title="isCollapsed ? 'Mi perfil' : ''">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
            <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="perfil-nombre-text">{{ authStore.nombreUsuario ?? 'Mi perfil' }}</span>
      </RouterLink>

      <button @click="handleLogout" class="logout-btn" :title="isCollapsed ? 'Cerrar sesión' : ''">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed">Salir</span>
      </button>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 220px;
  background-color: var(--color-oscuro-fondo, #141110);
  border-right: 1px solid var(--color-oscuro-borde, #2e2420);
  display: flex;
  flex-direction: column;
  transition: width 0.25s ease;
  height: 100vh;
  position: sticky;
  top: 0;
  overflow: hidden;
  flex-shrink: 0;
}

.sidebar.collapsed { width: 60px; }

/* ── HEADER ── */
.sidebar-header {
  padding: var(--espacio-4, 16px) var(--espacio-3, 12px);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--espacio-4, 16px);
  border-bottom: 1px solid var(--color-oscuro-borde, #2e2420);
  min-height: 130px;
  justify-content: flex-start;
}

.toggle-btn {
  background: none;
  border: none;
  color: var(--color-oscuro-texto-muted, #9a8070);
  cursor: pointer;
  align-self: flex-start;
  padding: var(--espacio-1, 4px);
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s, background 0.2s;
  width: 32px;
  height: 32px;
}

.toggle-btn svg { width: 18px; height: 18px; }
.sidebar.collapsed .toggle-btn { align-self: center; }
.toggle-btn:hover {
  color: var(--color-oscuro-texto, #f0ebe5);
  background: rgba(255,255,255,0.05);
}

.logo-container { width: 100%; display: flex; justify-content: center; }

.logo-circle {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  border: 1.5px solid var(--color-oscuro-borde, #2e2420);
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: var(--font-size-xs, 11px);
  color: var(--color-oscuro-texto-muted, #9a8070);
  background: rgba(255,255,255,0.03);
  font-weight: var(--font-weight-medium, 500);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* ── NAV ── */
.sidebar-nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: var(--espacio-3, 12px) var(--espacio-2, 8px);
  gap: 2px;
  overflow-y: auto;
  overflow-x: hidden;
  scrollbar-width: none;
}

.sidebar-nav::-webkit-scrollbar { display: none; }

.nav-divider {
  height: 1px;
  background: var(--color-oscuro-borde, #2e2420);
  margin: var(--espacio-2, 8px) var(--espacio-2, 8px);
}

.nav-item {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  color: var(--color-oscuro-texto-muted, #9a8070);
  text-decoration: none;
  border-radius: 8px;
  transition: background 0.15s, color 0.15s;
  white-space: nowrap;
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  overflow: hidden;
}

.sidebar.collapsed .nav-item {
  justify-content: center;
  padding: var(--espacio-2, 8px);
  gap: 0;
}

.nav-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

.nav-icon svg { width: 18px; height: 18px; }
.nav-label { overflow: hidden; }

.nav-item:hover {
  background: rgba(255,255,255,0.05);
  color: var(--color-oscuro-texto, #f0ebe5);
}

.nav-item.router-link-active {
  background: rgba(194, 96, 10, 0.15);
  color: var(--tenant-primario, #c2600a);
  position: relative;
}

.nav-item.router-link-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 20%;
  bottom: 20%;
  width: 3px;
  background: var(--tenant-primario, #c2600a);
  border-radius: 0 2px 2px 0;
}

.sidebar.collapsed .nav-item.router-link-active::before { display: none; }

/* ── FOOTER ── */
.sidebar-footer {
  padding: var(--espacio-3, 12px) var(--espacio-2, 8px);
  border-top: 1px solid var(--color-oscuro-borde, #2e2420);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-1, 4px);
}

/* Link de perfil propio */
.perfil-link {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  border-radius: 8px;
  text-decoration: none;
  color: var(--color-oscuro-texto-muted, #9a8070);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  transition: background 0.15s, color 0.15s;
  overflow: hidden;
  white-space: nowrap;
}

.perfil-link:hover {
  background: rgba(255,255,255,0.05);
  color: var(--color-oscuro-texto, #f0ebe5);
}

.perfil-link.router-link-active {
  background: rgba(194, 96, 10, 0.15);
  color: var(--tenant-primario, #c2600a);
}

.sidebar.collapsed .perfil-link {
  justify-content: center;
  padding: var(--espacio-2, 8px);
  gap: 0;
}

.perfil-nombre-text {
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.logout-btn {
  width: 100%;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  background: transparent;
  border: 1px solid rgba(253, 141, 141, 0.15);
  color: var(--color-cancelar, #fd8d8d);
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-3, 12px);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  transition: background 0.15s, border-color 0.15s;
  white-space: nowrap;
  overflow: hidden;
  font-family: var(--tenant-fuente, sans-serif);
}

.sidebar.collapsed .logout-btn { gap: 0; padding: var(--espacio-2, 8px); }
.logout-btn:hover {
  background: rgba(253, 141, 141, 0.08);
  border-color: rgba(253, 141, 141, 0.3);
}

/* ── TRANSITIONS ── */
.fade-enter-active, .fade-leave-active { transition: opacity 0.15s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>