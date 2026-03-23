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

// ── ESTADO GENERAL ─────────────────────────────────────
const clientesActivos   = ref<Cliente[]>([])
const clientesInactivos = ref<Cliente[]>([])
const busqueda          = ref('')
const cargando          = ref(false)
const errorGlobal       = ref('')
const tabActiva         = ref<'activos' | 'inactivos'>('activos')

// ── TOAST ──────────────────────────────────────────────
const toast = ref<{ tipo: 'ok' | 'error'; mensaje: string } | null>(null)
let toastTimer: ReturnType<typeof setTimeout>

const mostrarToast = (tipo: 'ok' | 'error', mensaje: string) => {
  clearTimeout(toastTimer)
  toast.value = { tipo, mensaje }
  toastTimer = setTimeout(() => { toast.value = null }, 3500)
}

// ── MODAL EDITAR / CREAR ───────────────────────────────
const modalAbierto = ref(false)
const editando     = ref(false)
const guardando    = ref(false)
const errorModal   = ref('')

// Bug 2 fix: activo se inicializa explícitamente como boolean
const form = ref<Cliente & { activo: boolean }>({
  id_cliente: 0,
  nombre:     '',
  email:      '',
  telefono:   '',
  activo:     true,
})

// ── MODAL CONFIRMACIÓN DE GUARDADO ────────────────────
const modalConfirmar = ref(false)
const pendienteGuardar = ref(false)

// ── FILTROS ────────────────────────────────────────────
const activosFiltrados = computed(() => {
  const q = busqueda.value.toLowerCase()
  return clientesActivos.value.filter(c =>
    c.nombre.toLowerCase().includes(q) ||
    c.email.toLowerCase().includes(q)  ||
    c.telefono.includes(q)
  )
})

const inactivosFiltrados = computed(() => {
  const q = busqueda.value.toLowerCase()
  return clientesInactivos.value.filter(c =>
    c.nombre.toLowerCase().includes(q) ||
    c.email.toLowerCase().includes(q)  ||
    c.telefono.includes(q)
  )
})

// ── API ────────────────────────────────────────────────

const fetchClientes = async () => {
  cargando.value    = true
  errorGlobal.value = ''
  try {
    const [resActivos, resInactivos] = await Promise.all([
      fetch(`${API_URL}/api/clientes/mostrar-activos`),
      fetch(`${API_URL}/api/clientes/mostrar-inactivos`),
    ])
    const [dataActivos, dataInactivos] = await Promise.all([
      resActivos.json(),
      resInactivos.json(),
    ])
    clientesActivos.value   = dataActivos.status   === 'ok' ? (dataActivos.datos   ?? []) : []
    clientesInactivos.value = dataInactivos.status === 'ok' ? (dataInactivos.datos ?? []) : []
  } catch {
    errorGlobal.value = 'No se pudo conectar con el servidor'
  } finally {
    cargando.value = false
  }
}

// POST /api/clientes/registro
const registrarCliente = async () => {
  guardando.value  = true
  errorModal.value = ''
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
      await fetchClientes()
      cerrarModal()
      // Bug 4: toast de éxito al agregar
      mostrarToast('ok', `Cliente "${form.value.nombre}" registrado correctamente`)
    } else {
      errorModal.value = data.mensaje
      mostrarToast('error', data.mensaje)
    }
  } catch {
    errorModal.value = 'Error al registrar cliente'
    mostrarToast('error', 'Error al registrar cliente')
  } finally {
    guardando.value = false
  }
}

// PUT /api/clientes/modificar/:id
const modificarCliente = async () => {
  guardando.value      = true
  errorModal.value     = ''
  modalConfirmar.value = false
  try {
    // Garantizar boolean antes de enviar — nunca null
    const activoRaw     = form.value.activo as unknown
    const activoBoolean = activoRaw !== false && activoRaw !== 'false' && activoRaw !== null && activoRaw !== undefined
    const res  = await fetch(`${API_URL}/api/clientes/modificar/${form.value.id_cliente}`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        nombre:   form.value.nombre,
        email:    form.value.email,
        telefono: form.value.telefono,
        activo:   activoBoolean,
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      await fetchClientes()
      cerrarModal()
      // Bug 3: toast de confirmación de guardado
      mostrarToast('ok', 'Cambios guardados correctamente')
    } else {
      errorModal.value = data.mensaje
      mostrarToast('error', data.mensaje)
    }
  } catch {
    errorModal.value = 'Error al modificar cliente'
    mostrarToast('error', 'Error al modificar cliente')
  } finally {
    guardando.value = false
  }
}

// Desactivar cliente (activo → false)
const desactivarCliente = async (c: Cliente) => {
  try {
    const res  = await fetch(`${API_URL}/api/clientes/modificar/${c.id_cliente}`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify({ nombre: c.nombre, email: c.email, telefono: c.telefono, activo: false }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      await fetchClientes()
      mostrarToast('ok', `"${c.nombre}" dado de baja`)
    } else {
      mostrarToast('error', data.mensaje)
    }
  } catch {
    mostrarToast('error', 'Error al dar de baja al cliente')
  }
}

// Activar cliente (inactivo → true)
const activarCliente = async (c: Cliente) => {
  try {
    const res  = await fetch(`${API_URL}/api/clientes/modificar/${c.id_cliente}`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify({ nombre: c.nombre, email: c.email, telefono: c.telefono, activo: true }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      await fetchClientes()
      mostrarToast('ok', `"${c.nombre}" reactivado`)
    } else {
      mostrarToast('error', data.mensaje)
    }
  } catch {
    mostrarToast('error', 'Error al reactivar cliente')
  }
}

// ── MODAL: ABRIR / CERRAR ──────────────────────────────
const abrirModalNuevo = () => {
  form.value = { id_cliente: 0, nombre: '', email: '', telefono: '', activo: true }
  editando.value     = false
  errorModal.value   = ''
  modalAbierto.value = true
}

const abrirModalEditar = (c: Cliente) => {
  // La API puede devolver activo como string "true"/"false" o como boolean real
  const activoRaw = c.activo as unknown
  form.value = {
    id_cliente: c.id_cliente,
    nombre:     c.nombre,
    email:      c.email,
    telefono:   c.telefono,
    activo:     activoRaw !== false && activoRaw !== 'false' && activoRaw !== null && activoRaw !== undefined,
  }
  editando.value     = true
  errorModal.value   = ''
  modalAbierto.value = true
}

const cerrarModal = () => {
  modalAbierto.value   = false
  modalConfirmar.value = false
  errorModal.value     = ''
}

// Bug 3: al guardar cambios de edición, pedir confirmación primero
const guardar = () => {
  if (editando.value) {
    modalConfirmar.value = true   // abre confirmación
  } else {
    registrarCliente()
  }
}

const confirmarGuardar = () => {
  modificarCliente()
}

onMounted(fetchClientes)
</script>

<template>
  <div class="clientes-layout">
    <Sidebar />

    <main class="clientes-main">

      <!-- HEADER -->
      <header class="page-header">
        <div>
          <p class="header-label">Directorio</p>
          <h1 class="page-title">Clientes</h1>
        </div>
        <button class="btn-primary" @click="abrirModalNuevo">
          <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          Nuevo cliente
        </button>
      </header>

      <!-- BÚSQUEDA + TABS -->
      <div class="toolbar">
        <div class="search-bar">
          <svg viewBox="0 0 24 24" fill="none">
            <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/>
            <path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <input v-model="busqueda" placeholder="Buscar por nombre, email o teléfono..." />
        </div>

        <div class="tabs">
          <button
            class="tab-btn"
            :class="{ active: tabActiva === 'activos' }"
            @click="tabActiva = 'activos'"
          >
            Activos
            <span class="tab-count">{{ clientesActivos.length }}</span>
          </button>
          <button
            class="tab-btn"
            :class="{ active: tabActiva === 'inactivos' }"
            @click="tabActiva = 'inactivos'"
          >
            Dados de baja
            <span class="tab-count">{{ clientesInactivos.length }}</span>
          </button>
        </div>
      </div>

      <!-- ERROR GLOBAL -->
      <div v-if="errorGlobal" class="error-banner">{{ errorGlobal }}</div>
      <div v-if="cargando" class="state-msg">Cargando clientes...</div>

      <!-- GRID ACTIVOS -->
      <div v-if="tabActiva === 'activos'" class="clientes-grid">
        <div
          v-for="c in activosFiltrados"
          :key="c.id_cliente"
          class="cliente-card"
        >
          <div class="cliente-avatar">{{ c.nombre.charAt(0).toUpperCase() }}</div>
          <div class="cliente-info">
            <strong class="cliente-nombre">{{ c.nombre }}</strong>
            <span class="cliente-dato">{{ c.email }}</span>
            <span class="cliente-dato">{{ c.telefono }}</span>
          </div>
          <div class="cliente-meta">
            <span class="status-pill activo">Activo</span>
            <div class="card-actions">
              <button class="card-btn card-btn--edit" @click="abrirModalEditar(c)" title="Editar">
                <svg viewBox="0 0 24 24" fill="none">
                  <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
              <button class="card-btn card-btn--delete" @click="desactivarCliente(c)" title="Dar de baja">
                <svg viewBox="0 0 24 24" fill="none">
                  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
                  <path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                </svg>
              </button>
            </div>
          </div>
        </div>

        <div v-if="!cargando && activosFiltrados.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="1.5"/>
          </svg>
          <p>Sin clientes activos</p>
        </div>
      </div>

      <!-- GRID INACTIVOS -->
      <div v-if="tabActiva === 'inactivos'" class="clientes-grid">
        <div
          v-for="c in inactivosFiltrados"
          :key="c.id_cliente"
          class="cliente-card cliente-card--inactivo"
        >
          <div class="cliente-avatar cliente-avatar--inactivo">{{ c.nombre.charAt(0).toUpperCase() }}</div>
          <div class="cliente-info">
            <strong class="cliente-nombre">{{ c.nombre }}</strong>
            <span class="cliente-dato">{{ c.email }}</span>
            <span class="cliente-dato">{{ c.telefono }}</span>
          </div>
          <div class="cliente-meta">
            <span class="status-pill inactivo">Inactivo</span>
            <button class="btn-reactivar" @click="activarCliente(c)" title="Reactivar cliente">
              <svg viewBox="0 0 24 24" fill="none">
                <path d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Reactivar
            </button>
          </div>
        </div>

        <div v-if="!cargando && inactivosFiltrados.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M9 11l3 3L22 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <p>No hay clientes dados de baja</p>
        </div>
      </div>

      <div class="watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </main>

    <!-- ── TOAST ── -->
    <Transition name="toast">
      <div v-if="toast" class="toast" :class="`toast--${toast.tipo}`">
        <svg v-if="toast.tipo === 'ok'" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
          <path d="M8 12l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <svg v-else viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
          <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
        {{ toast.mensaje }}
      </div>
    </Transition>

    <!-- ── MODAL CREAR / EDITAR ── -->
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

            <!-- Bug 2: toggle solo en edición, con valor correcto -->
            <div v-if="editando" class="field field--row">
              <label>Estado</label>
              <label class="toggle">
                <input type="checkbox" :checked="form.activo === true" @change="form.activo = ($event.target as HTMLInputElement).checked" />
                <span class="toggle-slider"></span>
                <span :class="form.activo ? 'toggle-text--activo' : 'toggle-text--inactivo'">
                  {{ form.activo ? 'Activo' : 'Inactivo' }}
                </span>
              </label>
            </div>

            <div v-if="errorModal" class="error-msg">{{ errorModal }}</div>
          </div>

          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModal">Cancelar</button>
            <!-- Bug 3: guardar llama confirmación si es edición -->
            <button class="btn-primary" :disabled="guardando" @click="guardar">
              <span v-if="!guardando">{{ editando ? 'Guardar cambios' : 'Registrar' }}</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- ── MODAL CONFIRMACIÓN DE GUARDADO ── -->
    <Transition name="modal">
      <div v-if="modalConfirmar" class="modal-overlay" @click.self="modalConfirmar = false">
        <div class="modal modal--sm">
          <div class="modal-header">
            <h2>¿Confirmar cambios?</h2>
            <button class="modal-close" @click="modalConfirmar = false">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <p class="confirm-msg">
              Se guardarán los cambios del cliente <strong>{{ form.nombre }}</strong>. ¿Continuar?
            </p>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="modalConfirmar = false">Cancelar</button>
            <button class="btn-primary" :disabled="guardando" @click="confirmarGuardar">
              <span v-if="!guardando">Sí, guardar</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<style scoped>
.clientes-layout { display: flex; min-height: 100vh; background: var(--tenant-fondo, #f5f0eb); }

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
.page-header { display: flex; align-items: flex-end; justify-content: space-between; }
.header-label { margin: 0; font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.1em; color: var(--tenant-texto-muted, #7c6a5a); font-weight: var(--font-weight-medium, 500); }
.page-title { margin: 0; font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }

/* TOOLBAR */
.toolbar { display: flex; align-items: center; gap: var(--espacio-4, 16px); flex-wrap: wrap; }

.search-bar {
  display: flex; align-items: center; gap: var(--espacio-3, 12px);
  background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 50px; padding: var(--espacio-2, 8px) var(--espacio-5, 20px);
  flex: 1; min-width: 200px; transition: border-color 0.2s;
}
.search-bar:focus-within { border-color: var(--tenant-primario, #c2600a); }
.search-bar svg { width: 16px; height: 16px; color: var(--tenant-texto-muted, #7c6a5a); flex-shrink: 0; }
.search-bar input { background: none; border: none; outline: none; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto, #1c1410); font-family: var(--tenant-fuente, sans-serif); width: 100%; }
.search-bar input::placeholder { color: var(--tenant-texto-muted, #7c6a5a); }

/* TABS */
.tabs { display: flex; gap: 4px; background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 50px; padding: 4px; flex-shrink: 0; }

.tab-btn {
  display: flex; align-items: center; gap: var(--espacio-2, 8px);
  padding: var(--espacio-1, 4px) var(--espacio-4, 16px);
  border-radius: 50px; border: none; background: transparent;
  font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto-muted, #7c6a5a); cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s, color 0.15s;
  white-space: nowrap;
}

.tab-btn.active { background: var(--tenant-primario, #c2600a); color: #fff; }
.tab-btn:not(.active):hover { background: var(--color-hover, #f0ebe5); color: var(--tenant-texto, #1c1410); }

.tab-count {
  font-size: var(--font-size-xs, 11px); font-weight: var(--font-weight-bold, 600);
  background: rgba(255,255,255,0.25); border-radius: 20px; padding: 0 6px;
  line-height: 1.6;
}
.tab-btn:not(.active) .tab-count { background: var(--color-borde, #e8ddd5); color: var(--tenant-texto-muted, #7c6a5a); }

/* BANNERS */
.error-banner { background: rgba(220,38,38,0.08); border: 1px solid rgba(220,38,38,0.2); border-radius: 10px; padding: var(--espacio-3, 12px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); color: var(--color-error, #dc2626); }
.state-msg { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); }

/* GRID */
.clientes-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--espacio-4, 16px); align-content: start; }

/* CARDS ACTIVOS */
.cliente-card {
  background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 16px; padding: var(--espacio-4, 16px);
  display: flex; align-items: center; gap: var(--espacio-3, 12px);
  transition: border-color 0.15s, box-shadow 0.15s;
}
.cliente-card:hover { border-color: var(--tenant-primario, #c2600a); box-shadow: 0 4px 16px rgba(0,0,0,0.06); }

/* CARDS INACTIVOS */
.cliente-card--inactivo { opacity: 0.75; border-style: dashed; }
.cliente-card--inactivo:hover { border-color: var(--color-exitoso, #16a34a); opacity: 1; }

.cliente-avatar { width: 40px; height: 40px; border-radius: 50%; background: rgba(194,96,10,0.1); color: var(--tenant-primario, #c2600a); display: flex; align-items: center; justify-content: center; font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); flex-shrink: 0; }
.cliente-avatar--inactivo { background: rgba(107,114,128,0.1); color: #6b7280; }

.cliente-info { flex: 1; display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.cliente-nombre { font-size: var(--font-size-base, 15px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.cliente-dato { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #7c6a5a); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

.cliente-meta { display: flex; flex-direction: column; align-items: flex-end; gap: var(--espacio-2, 8px); flex-shrink: 0; }

.status-pill { font-size: var(--font-size-xs, 11px); font-weight: var(--font-weight-medium, 500); border-radius: 20px; padding: 2px 10px; }
.status-pill.activo { background: rgba(22,163,74,0.1); color: var(--color-exitoso, #16a34a); border: 1px solid rgba(22,163,74,0.2); }
.status-pill.inactivo { background: rgba(107,114,128,0.1); color: #6b7280; border: 1px solid rgba(107,114,128,0.2); }

.card-actions { display: flex; gap: var(--espacio-1, 4px); }
.card-btn { width: 28px; height: 28px; border-radius: 7px; border: 1px solid var(--color-borde, #e8ddd5); background: transparent; cursor: pointer; display: flex; align-items: center; justify-content: center; padding: 0; transition: background 0.15s, border-color 0.15s, color 0.15s; color: var(--tenant-texto-muted, #7c6a5a); }
.card-btn svg { width: 13px; height: 13px; }
.card-btn--edit:hover { background: rgba(194,96,10,0.08); border-color: rgba(194,96,10,0.25); color: var(--tenant-primario, #c2600a); }
.card-btn--delete:hover { background: rgba(220,38,38,0.08); border-color: rgba(220,38,38,0.2); color: var(--color-error, #dc2626); }

/* Botón reactivar */
.btn-reactivar {
  display: flex; align-items: center; gap: 5px;
  background: rgba(22,163,74,0.08); border: 1px solid rgba(22,163,74,0.25);
  color: var(--color-exitoso, #16a34a); border-radius: 8px;
  padding: 4px 10px; font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500); cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s;
  white-space: nowrap;
}
.btn-reactivar:hover { background: rgba(22,163,74,0.15); }
.btn-reactivar svg { width: 13px; height: 13px; }

/* EMPTY STATE */
.empty-state { grid-column: 1/-1; display: flex; flex-direction: column; align-items: center; gap: var(--espacio-4, 16px); padding: var(--espacio-12, 48px) 0; }
.empty-state svg { width: 48px; height: 48px; color: var(--color-borde, #e8ddd5); }
.empty-state p { margin: 0; font-size: var(--font-size-base, 15px); color: var(--tenant-texto-muted, #7c6a5a); }

/* ── TOAST ── */
.toast {
  position: fixed;
  bottom: var(--espacio-6, 24px);
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  padding: var(--espacio-3, 12px) var(--espacio-5, 20px);
  border-radius: 50px;
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  z-index: 200;
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
  white-space: nowrap;
}
.toast svg { width: 16px; height: 16px; flex-shrink: 0; }
.toast--ok { background: var(--color-exitoso, #16a34a); color: #fff; }
.toast--error { background: var(--color-error, #dc2626); color: #fff; }

/* BUTTONS */
.btn-primary { display: flex; align-items: center; gap: var(--espacio-2, 8px); background: var(--tenant-primario, #c2600a); color: #fff; border: none; border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-bold, 600); cursor: pointer; font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s; }
.btn-primary svg { width: 15px; height: 15px; }
.btn-primary:hover { background: #a8520a; }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }

.btn-ghost { display: flex; align-items: center; gap: var(--espacio-2, 8px); background: transparent; border: 1px solid var(--color-borde, #e8ddd5); color: var(--tenant-texto-muted, #7c6a5a); border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-medium, 500); cursor: pointer; font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s; white-space: nowrap; }
.btn-ghost:hover { background: var(--color-hover, #f0ebe5); }

/* MODAL */
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.35); display: flex; align-items: center; justify-content: center; z-index: 100; padding: var(--espacio-6, 24px); backdrop-filter: blur(2px); }
.modal { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 20px; width: 100%; max-width: 420px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 24px 60px rgba(0,0,0,0.15); }
.modal--sm { max-width: 360px; }
.modal-header { display: flex; align-items: center; justify-content: space-between; padding: var(--espacio-5, 20px) var(--espacio-6, 24px); border-bottom: 1px solid var(--color-borde, #e8ddd5); }
.modal-header h2 { margin: 0; font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.modal-close { background: none; border: none; cursor: pointer; color: var(--tenant-texto-muted, #7c6a5a); display: flex; padding: 4px; border-radius: 6px; transition: background 0.15s; }
.modal-close:hover { background: var(--color-hover, #f0ebe5); }
.modal-close svg { width: 18px; height: 18px; }
.modal-body { padding: var(--espacio-6, 24px); display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }
.confirm-msg { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); line-height: 1.5; }
.confirm-msg strong { color: var(--tenant-texto, #1c1410); }
.modal-footer { display: flex; gap: var(--espacio-3, 12px); justify-content: flex-end; padding: var(--espacio-4, 16px) var(--espacio-6, 24px); border-top: 1px solid var(--color-borde, #e8ddd5); }

/* FIELDS */
.field { display: flex; flex-direction: column; gap: var(--espacio-2, 8px); }
.field--row { flex-direction: row; align-items: center; justify-content: space-between; }
.field label { font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.08em; font-weight: var(--font-weight-medium, 500); color: var(--tenant-texto-muted, #7c6a5a); }
.field input { background: var(--tenant-fondo, #f5f0eb); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 10px; padding: var(--espacio-3, 12px) var(--espacio-4, 16px); font-size: var(--font-size-base, 15px); color: var(--tenant-texto, #1c1410); font-family: var(--tenant-fuente, sans-serif); outline: none; transition: border-color 0.2s; }
.field input:focus { border-color: var(--tenant-primario, #c2600a); }

/* TOGGLE — Bug 2 fix: usa @change explícito, no v-model directo */
.toggle { display: flex; align-items: center; gap: var(--espacio-2, 8px); cursor: pointer; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto, #1c1410); text-transform: none; letter-spacing: normal; font-weight: var(--font-weight-normal, 400); }
.toggle input { display: none; }
.toggle-slider { width: 36px; height: 20px; background: var(--color-borde, #e8ddd5); border-radius: 20px; position: relative; transition: background 0.2s; flex-shrink: 0; }
.toggle-slider::after { content: ''; position: absolute; width: 14px; height: 14px; background: #fff; border-radius: 50%; top: 3px; left: 3px; transition: transform 0.2s; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
.toggle input:checked + .toggle-slider { background: var(--color-exitoso, #16a34a); }
.toggle input:checked + .toggle-slider::after { transform: translateX(16px); }
.toggle-text--activo { color: var(--color-exitoso, #16a34a); font-weight: var(--font-weight-medium, 500); }
.toggle-text--inactivo { color: var(--tenant-texto-muted, #7c6a5a); }

.error-msg { background: rgba(220,38,38,0.08); border: 1px solid rgba(220,38,38,0.2); border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-3, 12px); font-size: var(--font-size-sm, 13px); color: var(--color-error, #dc2626); }

.spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.35); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }
@keyframes spin { to { transform: rotate(360deg); } }

.watermark { position: absolute; bottom: var(--espacio-6, 24px); right: var(--espacio-8, 32px); display: flex; align-items: center; gap: var(--espacio-2, 8px); font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #7c6a5a); pointer-events: none; }
.watermark strong { color: var(--tenant-primario, #c2600a); font-weight: var(--font-weight-bold, 600); }

/* TRANSITIONS */
.modal-enter-active, .modal-leave-active { transition: opacity 0.2s, transform 0.2s; }
.modal-enter-from, .modal-leave-to { opacity: 0; transform: scale(0.97); }

.toast-enter-active, .toast-leave-active { transition: opacity 0.25s, transform 0.25s; }
.toast-enter-from { opacity: 0; transform: translateX(-50%) translateY(12px); }
.toast-leave-to { opacity: 0; transform: translateX(-50%) translateY(12px); }
</style>