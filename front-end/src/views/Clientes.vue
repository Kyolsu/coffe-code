<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ─────────────────────────────
interface Cliente {
  id: number
  nombre: string
  expediente: string
}

// ── ESTADO ────────────────────────────
const clientes = ref<Cliente[]>([])
const busqueda = ref('')

const nuevoCliente = ref<Cliente>({
  id: 0,
  nombre: '',
  expediente: ''
})

const editando = ref(false)

// ── FILTRO ────────────────────────────
const clientesFiltrados = computed(() =>
  clientes.value.filter(c =>
    c.nombre.toLowerCase().includes(busqueda.value.toLowerCase()) ||
    c.expediente.toLowerCase().includes(busqueda.value.toLowerCase())
  )
)

// ── ACCIONES ──────────────────────────
const guardarCliente = () => {
  if (editando.value) {
    const index = clientes.value.findIndex(c => c.id === nuevoCliente.value.id)
    if (index !== -1) {
      clientes.value[index] = { ...nuevoCliente.value }
    }
    editando.value = false
  } else {
    clientes.value.push({
      ...nuevoCliente.value,
      id: Date.now()
    })
  }

  limpiarFormulario()
}

const editarCliente = (cliente: Cliente) => {
  nuevoCliente.value = { ...cliente }
  editando.value = true
}

const eliminarCliente = (id: number) => {
  if (confirm('¿Eliminar cliente?')) {
    clientes.value = clientes.value.filter(c => c.id !== id)
  }
}

const limpiarFormulario = () => {
  nuevoCliente.value = { id: 0, nombre: '', expediente: '' }
  editando.value = false
}

// ── PERSISTENCIA ──────────────────────
const STORAGE_KEY = 'clientes_becados'

const cargar = () => {
  const data = localStorage.getItem(STORAGE_KEY)
  if (data) clientes.value = JSON.parse(data)
}

const guardar = () => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(clientes.value))
}

cargar()

// guardar automáticamente
watch(clientes, guardar, { deep: true })
</script>

<template>
  <div class="clientes-layout">
    <Sidebar />

    <main class="clientes-main">

      <!-- HEADER -->
      <header class="clientes-header">
        <h1 class="page-title">Clientes Becados</h1>
      </header>

      <!-- BUSCADOR -->
      <input
        v-model="busqueda"
        class="search-input"
        placeholder="Buscar por nombre o expediente..."
      />

      <!-- FORMULARIO -->
      <div class="form-card">
        <input v-model="nuevoCliente.nombre" placeholder="Nombre" />
        <input v-model="nuevoCliente.expediente" placeholder="Expediente" />
        <button @click="guardarCliente">
          {{ editando ? 'Actualizar' : 'Agregar' }}
        </button>
      </div>

      <!-- LISTA -->
      <div class="clientes-grid">
        <div
          v-for="cliente in clientesFiltrados"
          :key="cliente.id"
          class="cliente-card"
        >
          <div class="cliente-info">
            <strong>{{ cliente.nombre }}</strong>
            <span>{{ cliente.expediente }}</span>
          </div>

          <div class="cliente-actions">
            <button @click="editarCliente(cliente)">✏️</button>
            <button @click="eliminarCliente(cliente.id)">🗑️</button>
          </div>
        </div>

        <!-- VACÍO -->
        <div v-if="clientesFiltrados.length === 0" class="empty">
          Sin clientes registrados
        </div>
      </div>

    </main>
  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
.clientes-layout {
  display: flex;
  min-height: 100vh;
  background: var(--tenant-fondo, #000);
}

.clientes-main {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* HEADER */
.page-title {
  color: #fff;
  font-size: 28px;
}

/* BUSCADOR */
.search-input {
  padding: 10px;
  border-radius: 8px;
  border: 1px solid #222;
  background: #111;
  color: #fff;
}

/* FORM */
.form-card {
  display: flex;
  gap: 10px;
}

.form-card input {
  padding: 10px;
  background: #111;
  border: 1px solid #222;
  color: #fff;
  border-radius: 8px;
}

.form-card button {
  background: var(--tenant-primario, #3f99ff);
  color: white;
  border: none;
  padding: 10px 16px;
  border-radius: 8px;
  cursor: pointer;
}

/* GRID */
.clientes-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

/* CARD */
.cliente-card {
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  padding: 16px;
  border-radius: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.cliente-info strong {
  color: #fff;
  display: block;
}

.cliente-info span {
  color: #888;
  font-size: 13px;
}

.cliente-actions button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 16px;
}

/* EMPTY */
.empty {
  color: #666;
  grid-column: 1 / -1;
  text-align: center;
}
</style>
