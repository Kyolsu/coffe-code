<script setup lang="ts">
import { ref } from 'vue'
import { RouterLink } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

const router    = useRouter()
const authStore = useAuthStore()
const isCollapsed = ref(false)

// Rol real desde el store — ya mapeado a string ('admin', 'gerente', etc.)
const userRole = authStore.rol

const toggleSidebar = () => {
  isCollapsed.value = !isCollapsed.value
}

const handleLogout = () => {
  authStore.logout()           // limpia localStorage + estado reactivo
  router.push({ name: 'login' })
}
</script>

<template>
  <aside :class="['sidebar', { 'collapsed': isCollapsed }]">

    <!-- Header: toggle + logo -->
    <div class="sidebar-header">
      <button @click="toggleSidebar" class="toggle-btn" :title="isCollapsed ? 'Expandir menú' : 'Colapsar menú'">
        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M4 6h16M4 12h16M4 18h16" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
      </button>
      <Transition name="fade">
        <div v-if="!isCollapsed" class="logo-container">
          <div class="logo-circle">
            <span>Logo</span>
          </div>
        </div>
      </Transition>
    </div>

    <!-- Nav -->
    <nav class="sidebar-nav">
      <RouterLink to="/dashboard" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
            <path d="M9 21V12h6v9" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Inicio</span>
      </RouterLink>

      <RouterLink to="/venta" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
            <line x1="3" y1="6" x2="21" y2="6" stroke="currentColor" stroke-width="1.5"/>
            <path d="M16 10a4 4 0 01-8 0" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Ventas</span>
      </RouterLink>

      <RouterLink to="/menu" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18 8h1a4 4 0 010 8h-1M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8zM6 2v3M10 2v3M14 2v3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Menú / Productos</span>
      </RouterLink>

      <RouterLink to="/ordenes" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <path d="M9 12h6M9 16h4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Órdenes</span>
      </RouterLink>

      <RouterLink to="/cocina" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M8 3H5a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2V5a2 2 0 00-2-2h-3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <path d="M12 3v9M9 9l3 3 3-3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M7 17h10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Cocina (KD)</span>
      </RouterLink>

      <RouterLink to="/clientes" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="1.5"/>
            <path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Clientes</span>
      </RouterLink>

      <RouterLink to="/estadisticas" class="nav-item">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18 20V10M12 20V4M6 20v-6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </span>
        <span v-if="!isCollapsed" class="nav-label">Estadísticas</span>
      </RouterLink>

      <template v-if="userRole === 'admin' || userRole === 'gerente'">
        <div v-if="!isCollapsed" class="nav-divider"></div>

        <RouterLink to="/usuarios" class="nav-item">
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </span>
          <span v-if="!isCollapsed" class="nav-label">Usuarios</span>
        </RouterLink>

        <RouterLink to="/personalizacion" class="nav-item">
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>
              <path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z" stroke="currentColor" stroke-width="1.5"/>
            </svg>
          </span>
          <span v-if="!isCollapsed" class="nav-label">Personalización</span>
        </RouterLink>
      </template>
    </nav>

    <!-- Footer: logout -->
    <div class="sidebar-footer">
      <button @click="handleLogout" class="logout-btn" :title="isCollapsed ? 'Cerrar sesión' : ''">
        <span class="nav-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
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
  background-color: #080808;
  border-right: 1px solid #1a1a1a;
  display: flex;
  flex-direction: column;
  transition: width 0.25s ease;
  height: 100vh;
  position: sticky;
  top: 0;
  overflow: hidden;
  flex-shrink: 0;
}

.sidebar.collapsed {
  width: 60px;
}

/* ── HEADER ── */
.sidebar-header {
  padding: var(--espacio-4, 16px) var(--espacio-3, 12px);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--espacio-4, 16px);
  border-bottom: 1px solid #141414;
  min-height: 130px;
  justify-content: flex-start;
}

.toggle-btn {
  background: none;
  border: none;
  color: var(--tenant-texto-muted, #78716c);
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

.toggle-btn svg {
  width: 18px;
  height: 18px;
}

.sidebar.collapsed .toggle-btn {
  align-self: center;
}

.toggle-btn:hover {
  color: var(--tenant-texto, #fff);
  background: #1a1a1a;
}

.logo-container {
  width: 100%;
  display: flex;
  justify-content: center;
}

.logo-circle {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  border: 1.5px solid #2a2a2a;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  background: #111;
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
}

.nav-divider {
  height: 1px;
  background: #1a1a1a;
  margin: var(--espacio-2, 8px) var(--espacio-2, 8px);
}

.nav-item {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  color: var(--tenant-texto-muted, #78716c);
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

.nav-icon svg {
  width: 18px;
  height: 18px;
}

.nav-label {
  overflow: hidden;
}

.nav-item:hover {
  background: #141414;
  color: var(--tenant-texto, #fff);
}

.nav-item.router-link-active {
  background: rgba(63, 153, 255, 0.08);
  color: var(--tenant-primario, #3f99ff);
  border-left: none;
  position: relative;
}

.nav-item.router-link-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 20%;
  bottom: 20%;
  width: 3px;
  background: var(--tenant-primario, #3f99ff);
  border-radius: 0 2px 2px 0;
}

.sidebar.collapsed .nav-item.router-link-active::before {
  display: none;
}

/* ── FOOTER ── */
.sidebar-footer {
  padding: var(--espacio-3, 12px) var(--espacio-2, 8px);
  border-top: 1px solid #141414;
}

.logout-btn {
  width: 100%;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  background: transparent;
  border: 1px solid #1e1e1e;
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
}

.sidebar.collapsed .logout-btn {
  gap: 0;
  padding: var(--espacio-2, 8px);
}

.logout-btn:hover {
  background: rgba(253, 141, 141, 0.08);
  border-color: rgba(253, 141, 141, 0.3);
}

/* ── TRANSITION ── */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>