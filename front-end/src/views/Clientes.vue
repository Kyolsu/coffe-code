<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── TIPOS ──────────────────────────────────────────────
interface Cliente {
  id_cliente: number
  nombre: string
  email: string
  telefono: string
  activo: boolean
}

// ── ESTADO ─────────────────────────────────────────────
const clientes  = ref<Cliente[]>([])
const busqueda  = ref('')
const cargando  = ref(false)
const error     = ref('')

// Modal
const modalAbierto = ref(false)
const editando     = ref(false)
const guardando    = ref(false)

const form = ref({
  id_cliente: 0,
  nombre:   '',
  email:    '',
  telefono: '',
  activo:   true,
})

// ── FILTRO ─────────────────────────────────────────────
const clientesFiltrados = computed(() => {
  const q = busqueda.value.toLowerCase()
  return clientes.value.filter(c =>
    c.nombre.toLowerCase().includes(q) ||
    c.email.toLowerCase().includes(q)  ||
    c.telefono.includes(q)
  )
})

// ── API ────────────────────────────────────────────────

// GET — la doc no muestra un endpoint de listado aún, se deja preparado
// TODO: GET /api/clientes cuando el backend lo implemente
const fetchClientes = async () => {
  cargando.value = true
  error.value    = ''
  try {
    // const res  = await fetch(`${API_URL}/api/clientes`, { headers: authStore.authHeaders() })
    // const data = await res.json()
    // if (data.status === 'ok') clientes.value = data.datos
    // Por ahora se mantiene el array vacío hasta que exista el endpoint
  } catch {
    error.value = 'Error al cargar clientes'
  } finally {
    cargando.value = false
  }
}

// POST /api/clientes/registro
const registrarCliente = async () => {
  guardando.value = true
  error.value     = ''
  try {
    const res  = await fetch(`${API_URL}/api/clientes/registro`, {
      method: 'POST',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        nombre:   form.value.nombre,
        email:    form.value.email,
        telefono: form.value.telefono,
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      // Agregar localmente hasta que exista GET /clientes
      clientes.value.push({
        id_cliente: Date.now(),
        nombre:   form.value.nombre,
        email:    form.value.email,
        telefono: form.value.telefono,
        activo:   true,
      })
      cerrarModal()
    } else {
      error.value = data.mensaje
    }
  } catch {
    error.value = 'Error al registrar cliente'
  } finally {
    guardando.value = false
  }
}

// PUT /api/clientes/modificar/:id
const modificarCliente = async () => {
  guardando.value = true
  error.value     = ''
  try {
    const res  = await fetch(`${API_URL}/api/clientes/modificar/${form.value.id_cliente}`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        nombre:   form.value.nombre,
        email:    form.value.email,
        telefono: form.value.telefono,
        activo:   form.value.activo,
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      const idx = clientes.value.findIndex(c => c.id_cliente === form.value.id_cliente)
      if (idx !== -1) clientes.value[idx] = { ...form.value }
      cerrarModal()
    } else {
      error.value = data.mensaje
    }
  } catch {
    error.value = 'Error al modificar cliente'
  } finally {
    guardando.value = false
  }
}

const guardar = () => editando.value ? modificarCliente() : registrarCliente()

// ── MODAL ──────────────────────────────────────────────
const abrirModalNuevo = () => {
  form.value = { id_cliente: 0, nombre: '', email: '', telefono: '', activo: true }
  editando.value  = false
  modalAbierto.value = true
  error.value = ''
}

const abrirModalEditar = (c: Cliente) => {
  form.value = { ...c }
  editando.value  = true
  modalAbierto.value = true
  error.value = ''
}

const cerrarModal = () => {
  modalAbierto.value = false
  error.value = ''
}

// Eliminación local — no existe DELETE en la doc aún
// TODO: DELETE /api/clientes/:id cuando el backend lo implemente
const eliminarCliente = (id: number) => {
  clientes.value = clientes.value.filter(c => c.id_cliente !== id)
}

onMounted(fetchClientes)
</script>

<template>
  <div class="clientes-layout">
    <Sidebar />

    <main class="clientes-main">

      <!-- HEADER -->
      <header class="page-header">
        <div class="header-left">
          <p class="header-label">Directorio</p>
          <h1 class="page-title">Clientes</h1>
        </div>
        <button class="btn-primary" @click="abrirModalNuevo">
          <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          Nuevo cliente
        </button>
      </header>

      <!-- BÚSQUEDA -->
      <div class="search-bar">
        <svg viewBox="0 0 24 24" fill="none">
          <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/>
          <path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
        <input v-model="busqueda" placeholder="Buscar por nombre, email o teléfono..." />
      </div>

      <!-- CARGANDO -->
      <div v-if="cargando" class="state-msg">Cargando clientes...</div>

      <!-- ERROR GLOBAL -->
      <div v-if="error && !modalAbierto" class="error-banner">{{ error }}</div>

      <!-- GRID -->
      <div class="clientes-grid">
        <div
          v-for="c in clientesFiltrados"
          :key="c.id_cliente"
          class="cliente-card"
          :class="{ inactivo: !c.activo }"
        >
          <div class="cliente-avatar">{{ c.nombre.charAt(0).toUpperCase() }}</div>
          <div class="cliente-info">
            <strong class="cliente-nombre">{{ c.nombre }}</strong>
            <span class="cliente-dato">{{ c.email }}</span>
            <span class="cliente-dato">{{ c.telefono }}</span>
          </div>
          <div class="cliente-meta">
            <span class="status-pill" :class="c.activo ? 'activo' : 'inactivo'">
              {{ c.activo ? 'Activo' : 'Inactivo' }}
            </span>
            <div class="card-actions">
              <button class="card-btn card-btn--edit" @click="abrirModalEditar(c)" title="Editar">
                <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </button>
              <button class="card-btn card-btn--delete" @click="eliminarCliente(c.id_cliente)" title="Eliminar">
                <svg viewBox="0 0 24 24" fill="none"><polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/></svg>
              </button>
            </div>
          </div>
        </div>

        <div v-if="!cargando && clientesFiltrados.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" fill="none"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="1.5"/></svg>
          <p>Sin clientes registrados</p>
        </div>
      </div>

      <!-- WATERMARK -->
      <div class="watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </main>

    <!-- ── MODAL ── -->
    <Transition name="modal">
      <div v-if="modalAbierto" class="modal-overlay" @click.self="cerrarModal">
        <div class="modal">
          <div class="modal-header">
            <h2>{{ editando ? 'Editar cliente' : 'Nuevo cliente' }}</h2>
            <button class="modal-close" @click="cerrarModal">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>

          <div class="modal-body">
            <div class="field">
              <label>Nombre</label>
              <input v-model="form.nombre" placeholder="Nombre completo" />
            </div>
            <div class="field">
              <label>Email</label>
              <input v-model="form.email" type="email" placeholder="correo@ejemplo.com" />
            </div>
            <div class="field">
              <label>Teléfono</label>
              <input v-model="form.telefono" placeholder="442-000-0000" />
            </div>
            <div v-if="editando" class="field field--row">
              <label>Estado</label>
              <label class="toggle">
                <input type="checkbox" v-model="form.activo" />
                <span class="toggle-slider"></span>
                <span>{{ form.activo ? 'Activo' : 'Inactivo' }}</span>
              </label>
            </div>

            <div v-if="error" class="error-msg">{{ error }}</div>
          </div>

          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModal">Cancelar</button>
            <button class="btn-primary" :disabled="guardando" @click="guardar">
              <span v-if="!guardando">{{ editando ? 'Guardar cambios' : 'Registrar' }}</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.clientes-layout {
  display: flex;
  min-height: 100vh;
  background: var(--tenant-fondo, #f5f0eb);
}

.clientes-main {
  flex: 1;
  padding: var(--espacio-8, 32px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-5, 20px);
  position: relative;
  overflow-y: auto;
}

/* HEADER */
.page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
}

.header-label {
  margin: 0;
  font-size: var(--font-size-xs, 11px);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--tenant-texto-muted, #7c6a5a);
  font-weight: var(--font-weight-medium, 500);
}

.page-title {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
}

/* SEARCH */
.search-bar {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 50px;
  padding: var(--espacio-2, 8px) var(--espacio-5, 20px);
  max-width: 480px;
  transition: border-color 0.2s;
}

.search-bar:focus-within {
  border-color: var(--tenant-primario, #c2600a);
}

.search-bar svg {
  width: 16px;
  height: 16px;
  color: var(--tenant-texto-muted, #7c6a5a);
  flex-shrink: 0;
}

.search-bar input {
  background: none;
  border: none;
  outline: none;
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto, #1c1410);
  font-family: var(--tenant-fuente, sans-serif);
  width: 100%;
}

.search-bar input::placeholder { color: var(--tenant-texto-muted, #7c6a5a); }

/* ESTADOS */
.state-msg {
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto-muted, #7c6a5a);
}

.error-banner {
  background: rgba(220, 38, 38, 0.08);
  border: 1px solid rgba(220, 38, 38, 0.2);
  border-radius: 10px;
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
  font-size: var(--font-size-sm, 13px);
  color: var(--color-error, #dc2626);
}

/* GRID */
.clientes-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--espacio-4, 16px);
  align-content: start;
}

.cliente-card {
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 16px;
  padding: var(--espacio-4, 16px);
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  transition: border-color 0.15s, box-shadow 0.15s;
}

.cliente-card:hover {
  border-color: var(--tenant-primario, #c2600a);
  box-shadow: 0 4px 16px rgba(0,0,0,0.06);
}

.cliente-card.inactivo {
  opacity: 0.55;
}

.cliente-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: rgba(194, 96, 10, 0.1);
  color: var(--tenant-primario, #c2600a);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  flex-shrink: 0;
}

.cliente-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}

.cliente-nombre {
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cliente-dato {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #7c6a5a);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cliente-meta {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: var(--espacio-2, 8px);
  flex-shrink: 0;
}

.status-pill {
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
  border-radius: 20px;
  padding: 2px 10px;
}

.status-pill.activo {
  background: rgba(22, 163, 74, 0.1);
  color: var(--color-exitoso, #16a34a);
  border: 1px solid rgba(22, 163, 74, 0.2);
}

.status-pill.inactivo {
  background: rgba(107, 114, 128, 0.1);
  color: #6b7280;
  border: 1px solid rgba(107, 114, 128, 0.2);
}

.card-actions { display: flex; gap: var(--espacio-1, 4px); }

.card-btn {
  width: 28px;
  height: 28px;
  border-radius: 7px;
  border: 1px solid var(--color-borde, #e8ddd5);
  background: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
  color: var(--tenant-texto-muted, #7c6a5a);
}

.card-btn svg { width: 13px; height: 13px; }

.card-btn--edit:hover {
  background: rgba(194, 96, 10, 0.08);
  border-color: rgba(194, 96, 10, 0.25);
  color: var(--tenant-primario, #c2600a);
}

.card-btn--delete:hover {
  background: rgba(220, 38, 38, 0.08);
  border-color: rgba(220, 38, 38, 0.2);
  color: var(--color-error, #dc2626);
}

.empty-state {
  grid-column: 1/-1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--espacio-4, 16px);
  padding: var(--espacio-12, 48px) 0;
  color: var(--color-borde, #e8ddd5);
}

.empty-state svg { width: 48px; height: 48px; }
.empty-state p { margin: 0; font-size: var(--font-size-base, 15px); color: var(--tenant-texto-muted, #7c6a5a); }

/* BUTTONS */
.btn-primary {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  background: var(--tenant-primario, #c2600a);
  color: #fff;
  border: none;
  border-radius: 10px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif);
  transition: background 0.15s;
}

.btn-primary svg { width: 15px; height: 15px; }
.btn-primary:hover { background: #a8520a; }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }

.btn-ghost {
  background: transparent;
  border: 1px solid var(--color-borde, #e8ddd5);
  color: var(--tenant-texto-muted, #7c6a5a);
  border-radius: 10px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif);
  transition: background 0.15s;
}

.btn-ghost:hover { background: var(--color-hover, #f0ebe5); }

/* MODAL */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  padding: var(--espacio-6, 24px);
  backdrop-filter: blur(2px);
}

.modal {
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 20px;
  width: 100%;
  max-width: 420px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 24px 60px rgba(0,0,0,0.15);
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--espacio-5, 20px) var(--espacio-6, 24px);
  border-bottom: 1px solid var(--color-borde, #e8ddd5);
}

.modal-header h2 {
  margin: 0;
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
}

.modal-close {
  background: none;
  border: none;
  cursor: pointer;
  color: var(--tenant-texto-muted, #7c6a5a);
  display: flex;
  padding: 4px;
  border-radius: 6px;
  transition: background 0.15s;
}

.modal-close:hover { background: var(--color-hover, #f0ebe5); }
.modal-close svg { width: 18px; height: 18px; }

.modal-body {
  padding: var(--espacio-6, 24px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-4, 16px);
}

.field {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-2, 8px);
}

.field--row {
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.field label {
  font-size: var(--font-size-xs, 11px);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto-muted, #7c6a5a);
}

.field input {
  background: var(--tenant-fondo, #f5f0eb);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 10px;
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
  font-size: var(--font-size-base, 15px);
  color: var(--tenant-texto, #1c1410);
  font-family: var(--tenant-fuente, sans-serif);
  outline: none;
  transition: border-color 0.2s;
}

.field input:focus { border-color: var(--tenant-primario, #c2600a); }

/* Toggle */
.toggle {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  cursor: pointer;
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto, #1c1410);
  text-transform: none;
  letter-spacing: normal;
  font-weight: var(--font-weight-normal, 400);
}

.toggle input { display: none; }

.toggle-slider {
  width: 36px;
  height: 20px;
  background: var(--color-borde, #e8ddd5);
  border-radius: 20px;
  position: relative;
  transition: background 0.2s;
  flex-shrink: 0;
}

.toggle-slider::after {
  content: '';
  position: absolute;
  width: 14px;
  height: 14px;
  background: #fff;
  border-radius: 50%;
  top: 3px;
  left: 3px;
  transition: transform 0.2s;
  box-shadow: 0 1px 3px rgba(0,0,0,0.2);
}

.toggle input:checked + .toggle-slider { background: var(--color-exitoso, #16a34a); }
.toggle input:checked + .toggle-slider::after { transform: translateX(16px); }

.error-msg {
  background: rgba(220, 38, 38, 0.08);
  border: 1px solid rgba(220, 38, 38, 0.2);
  border-radius: 10px;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  font-size: var(--font-size-sm, 13px);
  color: var(--color-error, #dc2626);
}

.modal-footer {
  display: flex;
  gap: var(--espacio-3, 12px);
  justify-content: flex-end;
  padding: var(--espacio-4, 16px) var(--espacio-6, 24px);
  border-top: 1px solid var(--color-borde, #e8ddd5);
}

.spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255,255,255,0.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
  display: inline-block;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* WATERMARK */
.watermark {
  position: absolute;
  bottom: var(--espacio-6, 24px);
  right: var(--espacio-8, 32px);
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #7c6a5a);
  pointer-events: none;
}

.watermark strong {
  color: var(--tenant-primario, #c2600a);
  font-weight: var(--font-weight-bold, 600);
}

/* TRANSICIONES */
.modal-enter-active, .modal-leave-active { transition: opacity 0.2s, transform 0.2s; }
.modal-enter-from, .modal-leave-to { opacity: 0; transform: scale(0.97); }
</style>