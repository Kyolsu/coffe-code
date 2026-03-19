<script setup lang="ts">
import { ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'

const router = useRouter()

// Estado para retraer/expandir el menú
const isCollapsed = ref(false)

// Mock temporal del rol del usuario (puedes cambiarlo a 'cajero' para probar que se ocultan opciones)
const userRole = ref('admin')

const toggleSidebar = () => {
  isCollapsed.value = !isCollapsed.value
}

const handleLogout = () => {
  localStorage.removeItem('coffe_token')
  router.push({ name: 'login' })
}
</script>

<template>
  <aside :class="['sidebar', { 'collapsed': isCollapsed }]">
    <div class="sidebar-header">
      <button @click="toggleSidebar" class="toggle-btn">
        ☰
      </button>
      <div v-if="!isCollapsed" class="logo-container">
        <div class="logo-circle">Logo</div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <RouterLink to="/dashboard" class="nav-item">🏠 <span v-if="!isCollapsed">Inicio</span></RouterLink>
      <RouterLink to="/venta" class="nav-item">🛒 <span v-if="!isCollapsed">Ventas</span></RouterLink>
      <RouterLink to="/menu" class="nav-item">🍴 <span v-if="!isCollapsed">Menú/Productos</span></RouterLink>
      <RouterLink to="/ordenes" class="nav-item">📋 <span v-if="!isCollapsed">Órdenes</span></RouterLink>
      <RouterLink to="/clientes" class="nav-item">👥 <span v-if="!isCollapsed">Clientes</span></RouterLink>
      <RouterLink to="/estadisticas" class="nav-item">📊 <span v-if="!isCollapsed">Estadísticas</span></RouterLink>
      
      <template v-if="userRole === 'admin' || userRole === 'gerente'">
        <RouterLink to="/usuarios" class="nav-item">👤 <span v-if="!isCollapsed">Usuarios</span></RouterLink>
        <RouterLink to="/personalizacion" class="nav-item">⚙️ <span v-if="!isCollapsed">Personalización</span></RouterLink>
      </template>
    </nav>

    <div class="sidebar-footer">
      <button @click="handleLogout" class="logout-btn" title="Cerrar sesión">
        🚪 <span v-if="!isCollapsed">Salir</span>
      </button>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 250px;
  background-color: #1a1a1a;
  border-right: 1px solid #333;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  height: 100vh;
  position: sticky;
  top: 0;
}

.sidebar.collapsed {
  width: 60px;
}

.sidebar-header {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.toggle-btn {
  background: none;
  border: none;
  color: var(--tenant-texto, #fff);
  font-size: 1.5rem;
  cursor: pointer;
  align-self: flex-start;
}

.sidebar.collapsed .toggle-btn {
  align-self: center;
}

.logo-circle {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  border: 2px solid var(--tenant-texto, #fff);
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 0.9rem;
}

.sidebar-nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 1rem 0;
  gap: 0.5rem;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem 1.5rem;
  color: var(--tenant-texto, #fff);
  text-decoration: none;
  transition: background 0.2s;
  white-space: nowrap;
}

.sidebar.collapsed .nav-item {
  justify-content: center;
  padding: 0.75rem 0;
}

.nav-item:hover, .nav-item.router-link-active {
  background-color: #333;
  color: var(--tenant-primario, #3f99ff);
  border-left: 4px solid var(--tenant-primario, #3f99ff);
}

.sidebar-footer {
  padding: 1rem;
}

.logout-btn {
  width: 100%;
  padding: 0.75rem;
  background-color: var(--color-error, #dc2626);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}
</style>