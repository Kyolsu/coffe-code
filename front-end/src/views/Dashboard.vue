<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'

const router = useRouter()

// Mock del nombre de usuario
const userName = ref('Admin')

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
        <h1>¡Bienvenido {{ userName }}!</h1>
        <div class="user-profile">
          <div class="profile-icon">👤</div>
        </div>
      </header>

      <div class="dashboard-grid">
        
        <div class="card clickable" @click="irAVistaPublica">
          <h3>Vista Pública</h3>
        </div>

        <div class="card highlight">
          <h3>Producto más vendido</h3>
          <div class="mock-image">☕ Café Americano</div>
        </div>

        <div class="card clickable" @click="irAVenta">
          <h3>Iniciar Venta</h3>
        </div>

        <div class="card chart-container">
          <h3>Gráfico de actividad</h3>
          <div class="mock-chart">
            📈 Simulación de gráfico aquí
          </div>
        </div>

        <div class="card clickable" @click="irAClientes">
          <h3>Clientes</h3>
        </div>

        <div class="card clickable" @click="irAMenu">
          <h3>Productos</h3>
        </div>

      </div>

      <div class="watermark">
        Logo del software<br>
        <strong>CoffeeCode</strong>
      </div>
    </main>
  </div>
</template>

<style scoped>
.dashboard-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo, #000);
}

.dashboard-content {
  flex: 1;
  padding: 2rem;
  position: relative;
  display: flex;
  flex-direction: column;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  color: var(--tenant-primario, #3f99ff);
  font-size: 1.5rem;
  border-bottom: 2px solid #333;
  padding-bottom: 1rem;
}

.profile-icon {
  font-size: 3rem;
  background: #222;
  border-radius: 50%;
  padding: 0.5rem;
}

.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  flex: 1;
}

.card {
  background-color: #1a1a1a;
  border: 1px solid #333;
  border-radius: 16px;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  color: var(--tenant-texto, #fff);
  transition: transform 0.2s, border-color 0.2s;
}

.card h3 {
  margin: 0;
  font-size: 1.2rem;
}

.clickable {
  cursor: pointer;
}

.clickable:hover {
  transform: translateY(-5px);
  border-color: var(--tenant-primario, #3f99ff);
}

.highlight {
  border-color: var(--tenant-texto-muted, #78716c);
}

.mock-image {
  margin-top: 1rem;
  padding: 2rem;
  background: #222;
  border-radius: 8px;
  width: 80%;
}

/* El gráfico ocupa 2 filas en la primera columna para igualar tu diseño */
.chart-container {
  grid-column: 1 / 2;
  grid-row: 2 / 4;
  justify-content: flex-start;
}

.mock-chart {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  margin-top: 1rem;
  background: #222;
  border-radius: 8px;
}

.watermark {
  position: absolute;
  bottom: 2rem;
  right: 2rem;
  text-align: right;
  color: var(--tenant-texto-muted, #78716c);
}

.watermark strong {
  font-size: 1.5rem;
  color: var(--tenant-texto, #fff);
}
</style>