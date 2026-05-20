<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import API_URL from '../config/api'

const API_BASE = `${API_URL}/api`

interface OrdenCocina {
  id_orden: number
  numero_orden: string
  estado_orden: string
  fecha_creacion: string
}

const ordenes = ref<OrdenCocina[]>([])
const isLoading = ref(true)
const error = ref('')

const pendingOrders = computed(() =>
  ordenes.value.filter(o => o.estado_orden === 'pendiente' || o.estado_orden === 'en_preparacion')
)

const readyOrders = computed(() =>
  ordenes.value.filter(o => o.estado_orden === 'lista')
)

const fetchOrdenes = async () => {
  try {
    const res = await fetch(`${API_BASE}/ordenes/cocina`)
    const data = await res.json()
    if (data.status === 'ok') {
      ordenes.value = data.datos || []
      error.value = ''
    } else {
      error.value = 'Error al cargar órdenes'
    }
  } catch (e) {
    error.value = 'Sin conexión'
  } finally {
    isLoading.value = false
  }
}

let interval: ReturnType<typeof setInterval>

onMounted(() => {
  fetchOrdenes()
  interval = setInterval(fetchOrdenes, 20000)
})

onUnmounted(() => {
  clearInterval(interval)
})

const getOrderNumber = (numero: string) => numero.replace('ORD-', '')

const formatTime = (fecha: string) => {
  const d = new Date(fecha)
  return d.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })
}
</script>

<template>
  <div class="layout">
    <header class="header">
      <h1>Pedidos</h1>
      <div class="refresh-info">
        <span class="dot" :class="{ error: !!error }"></span>
        {{ error || 'Actualizando cada 20s' }}
      </div>
    </header>

    <div v-if="isLoading" class="loading">
      <div class="spinner"></div>
      <p>Cargando...</p>
    </div>

    <div v-else-if="error" class="error-banner">
      <p>{{ error }}</p>
      <button @click="fetchOrdenes">Reintentar</button>
    </div>

    <div v-else class="board">
      <!-- PENDIENTES -->
      <div class="column pending">
        <div class="column-header">
          <span class="badge">{{ pendingOrders.length }}</span>
          <h2>Pendientes</h2>
        </div>
        <div class="order-list">
          <div
            v-for="o in pendingOrders"
            :key="o.id_orden"
            class="order-card pending"
          >
            <span class="order-number">{{ getOrderNumber(o.numero_orden) }}</span>
            <span class="order-time">{{ formatTime(o.fecha_creacion) }}</span>
          </div>
          <div v-if="pendingOrders.length === 0" class="empty-state">
            Sin órdenes pendientes
          </div>
        </div>
      </div>

      <!-- LISTAS -->
      <div class="column ready">
        <div class="column-header">
          <span class="badge">{{ readyOrders.length }}</span>
          <h2>Listas</h2>
        </div>
        <div class="order-list">
          <div
            v-for="o in readyOrders"
            :key="o.id_orden"
            class="order-card ready"
          >
            <span class="order-number">{{ getOrderNumber(o.numero_orden) }}</span>
            <span class="order-time">{{ formatTime(o.fecha_creacion) }}</span>
          </div>
          <div v-if="readyOrders.length === 0" class="empty-state">
            Sin órdenes listas
          </div>
        </div>
      </div>
    </div>

    <footer class="watermark">
      Software por CoffeeCode
    </footer>
  </div>
</template>

<style scoped>
.layout {
  min-height: 100vh;
  background: #0e0e0e;
  display: flex;
  flex-direction: column;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: #1a1a1a;
  border-bottom: 1px solid #2a2a2a;
}

.header h1 {
  color: #fff;
  font-size: 24px;
  margin: 0;
}

.refresh-info {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #78716c;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #22c55e;
}

.dot.error {
  background: #ef4444;
}

.loading {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #78716c;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #2a2a2a;
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 12px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-banner {
  margin: 20px;
  padding: 16px;
  background: #7f1d1d;
  border: 1px solid #ef4444;
  border-radius: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #fca5a5;
}

.error-banner button {
  padding: 8px 16px;
  background: #ef4444;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 13px;
}

.board {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  padding: 20px 24px;
}

.column {
  background: #1a1a1a;
  border: 1px solid #2a2a2a;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.column-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  border-bottom: 1px solid #2a2a2a;
}

.column-header h2 {
  margin: 0;
  font-size: 18px;
  color: #fff;
}

.badge {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 28px;
  height: 28px;
  padding: 0 8px;
  border-radius: 14px;
  font-size: 14px;
  font-weight: 700;
}

.pending .badge {
  background: #c92a00;
  color: #fff;
}

.pending .column-header h2 {
  color: #c92a00;
}

.ready .badge {
  background: #6ccf4f;
  color: #000;
}

.ready .column-header h2 {
  color: #6ccf4f;
}

.order-list {
  flex: 1;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  overflow-y: auto;
}

.order-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-radius: 16px;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.order-card.pending {
  background: #c92a00;
}

.order-card.ready {
  background: #6ccf4f;
}

.order-number {
  font-size: 32px;
  font-weight: 800;
  color: #fff;
  letter-spacing: 2px;
}

.ready .order-number {
  color: #000;
}

.order-time {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
}

.ready .order-time {
  color: rgba(0, 0, 0, 0.6);
}

.empty-state {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #57534e;
  font-size: 14px;
}

.watermark {
  text-align: center;
  padding: 16px;
  font-size: 11px;
  color: #44403c;
  border-top: 1px solid #1c1c1c;
}
</style>