<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── TIPOS ──────────────────────────────────────────────
interface Usuario {
  id: number
  nombre: string
  rol: number   // número que devuelve el backend
}

const ROL_LABEL: Record<number, string> = {
  1: 'Administrador',
  2: 'Gerente',
  3: 'Cajero',
  4: 'Cocinero',
}

// ── ESTADO ─────────────────────────────────────────────
const usuarios  = ref<Usuario[]>([])
const busqueda  = ref('')
const cargando  = ref(false)
const errorGlobal = ref('')

// Modal creación
const modalNuevo   = ref(false)
const guardando    = ref(false)
const errorModal   = ref('')

const formNuevo = ref({ usuario: '', contra: '', rol: 3 })

// Modal confirmar eliminación
const modalEliminar   = ref(false)
const usuarioEliminar = ref<Usuario | null>(null)
const contraEliminar  = ref('')
const eliminando      = ref(false)
const errorEliminar   = ref('')

// ── FILTRO ─────────────────────────────────────────────
const usuariosFiltrados = computed(() => {
  const q = busqueda.value.toLowerCase()
  return usuarios.value.filter(u =>
    u.nombre.toLowerCase().includes(q) ||
    (ROL_LABEL[u.rol] ?? '').toLowerCase().includes(q)
  )
})

// ── API ────────────────────────────────────────────────

// GET perfil propio — se usa para verificar que el token sigue activo al montar
// No existe endpoint de listado en la doc aún
// TODO: GET /api/usuarios cuando el backend lo implemente
const fetchUsuarios = async () => {
  cargando.value    = true
  errorGlobal.value = ''
  try {
    // const res  = await fetch(`${API_URL}/api/usuarios`, { headers: authStore.authHeaders() })
    // const data = await res.json()
    // if (data.status === 'ok') usuarios.value = data.datos
  } catch {
    errorGlobal.value = 'Error al cargar usuarios'
  } finally {
    cargando.value = false
  }
}

// POST /api/usuarios/registro
const registrarUsuario = async () => {
  guardando.value = true
  errorModal.value = ''
  try {
    const res  = await fetch(`${API_URL}/api/usuarios/registro`, {
      method: 'POST',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        usuario: formNuevo.value.usuario,
        contra:  formNuevo.value.contra,
        rol:     formNuevo.value.rol,
      }),
    })
    const data = await res.json()

    if (data.status === 'ok') {
      // Agregar localmente hasta que exista GET /usuarios
      usuarios.value.push({
        id:     Date.now(),
        nombre: formNuevo.value.usuario,
        rol:    formNuevo.value.rol,
      })
      cerrarModalNuevo()
    } else {
      errorModal.value = data.mensaje
    }
  } catch {
    errorModal.value = 'Error al registrar usuario'
  } finally {
    guardando.value = false
  }
}

// DELETE /api/usuarios/eliminar  (requiere usuario + contra para confirmar)
const confirmarEliminar = async () => {
  if (!usuarioEliminar.value) return
  eliminando.value   = true
  errorEliminar.value = ''
  try {
    const res  = await fetch(`${API_URL}/api/usuarios/eliminar`, {
      method: 'DELETE',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        usuario: usuarioEliminar.value.nombre,
        contra:  contraEliminar.value,
      }),
    })
    const data = await res.json()

    if (data.status === 'ok') {
      usuarios.value = usuarios.value.filter(u => u.id !== usuarioEliminar.value!.id)
      cerrarModalEliminar()
    } else {
      errorEliminar.value = data.mensaje
    }
  } catch {
    errorEliminar.value = 'Error al eliminar usuario'
  } finally {
    eliminando.value = false
  }
}

// ── MODALES ────────────────────────────────────────────
const abrirModalNuevo = () => {
  formNuevo.value  = { usuario: '', contra: '', rol: 3 }
  errorModal.value = ''
  modalNuevo.value = true
}

const cerrarModalNuevo = () => { modalNuevo.value = false; errorModal.value = '' }

const abrirModalEliminar = (u: Usuario) => {
  usuarioEliminar.value  = u
  contraEliminar.value   = ''
  errorEliminar.value    = ''
  modalEliminar.value    = true
}

const cerrarModalEliminar = () => { modalEliminar.value = false; errorEliminar.value = '' }

onMounted(fetchUsuarios)
</script>

<template>
  <div class="usuarios-layout">
    <Sidebar />

    <main class="usuarios-main">

      <header class="page-header">
        <div>
          <p class="header-label">Gestión</p>
          <h1 class="page-title">Usuarios</h1>
        </div>
        <button class="btn-primary" @click="abrirModalNuevo">
          <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          Nuevo usuario
        </button>
      </header>

      <div class="search-bar">
        <svg viewBox="0 0 24 24" fill="none">
          <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/>
          <path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
        <input v-model="busqueda" placeholder="Buscar por nombre o rol..." />
      </div>

      <div v-if="errorGlobal" class="error-banner">{{ errorGlobal }}</div>

      <div class="usuarios-grid">
        <div v-for="u in usuariosFiltrados" :key="u.id" class="usuario-card">
          <div class="usuario-avatar">{{ u.nombre.charAt(0).toUpperCase() }}</div>
          <div class="usuario-info">
            <strong>{{ u.nombre }}</strong>
            <span class="rol-pill">{{ ROL_LABEL[u.rol] ?? `Rol ${u.rol}` }}</span>
          </div>
          <button class="card-btn card-btn--delete" @click="abrirModalEliminar(u)" title="Eliminar">
            <svg viewBox="0 0 24 24" fill="none"><polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/></svg>
          </button>
        </div>

        <div v-if="!cargando && usuariosFiltrados.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          <p>Sin usuarios registrados</p>
        </div>
      </div>

      <div class="watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </main>

    <!-- Modal: Nuevo usuario -->
    <Transition name="modal">
      <div v-if="modalNuevo" class="modal-overlay" @click.self="cerrarModalNuevo">
        <div class="modal">
          <div class="modal-header">
            <h2>Nuevo usuario</h2>
            <button class="modal-close" @click="cerrarModalNuevo">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <div class="field">
              <label>Nombre de usuario</label>
              <input v-model="formNuevo.usuario" placeholder="usuario123" />
            </div>
            <div class="field">
              <label>Contraseña</label>
              <input v-model="formNuevo.contra" type="password" placeholder="••••••••" />
            </div>
            <div class="field">
              <label>Rol</label>
              <select v-model="formNuevo.rol">
                <option v-for="(label, id) in ROL_LABEL" :key="id" :value="Number(id)">{{ label }}</option>
              </select>
            </div>
            <div v-if="errorModal" class="error-msg">{{ errorModal }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalNuevo">Cancelar</button>
            <button class="btn-primary" :disabled="guardando" @click="registrarUsuario">
              <span v-if="!guardando">Registrar</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- Modal: Confirmar eliminación -->
    <Transition name="modal">
      <div v-if="modalEliminar" class="modal-overlay" @click.self="cerrarModalEliminar">
        <div class="modal">
          <div class="modal-header">
            <h2>Eliminar usuario</h2>
            <button class="modal-close" @click="cerrarModalEliminar">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <p class="confirm-msg">
              Para confirmar la baja de <strong>{{ usuarioEliminar?.nombre }}</strong>,
              ingresa tu contraseña actual.
            </p>
            <div class="field">
              <label>Tu contraseña</label>
              <input v-model="contraEliminar" type="password" placeholder="••••••••" />
            </div>
            <div v-if="errorEliminar" class="error-msg">{{ errorEliminar }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalEliminar">Cancelar</button>
            <button class="btn-danger" :disabled="eliminando" @click="confirmarEliminar">
              <span v-if="!eliminando">Eliminar</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.usuarios-layout {
  display: flex;
  min-height: 100vh;
  background: var(--tenant-fondo, #f5f0eb);
}

.usuarios-main {
  flex: 1;
  padding: var(--espacio-8, 32px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-5, 20px);
  position: relative;
  overflow-y: auto;
}

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

.search-bar:focus-within { border-color: var(--tenant-primario, #c2600a); }
.search-bar svg { width: 16px; height: 16px; color: var(--tenant-texto-muted, #7c6a5a); flex-shrink: 0; }
.search-bar input { background: none; border: none; outline: none; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto, #1c1410); font-family: var(--tenant-fuente, sans-serif); width: 100%; }
.search-bar input::placeholder { color: var(--tenant-texto-muted, #7c6a5a); }

.error-banner {
  background: rgba(220, 38, 38, 0.08);
  border: 1px solid rgba(220, 38, 38, 0.2);
  border-radius: 10px;
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
  font-size: var(--font-size-sm, 13px);
  color: var(--color-error, #dc2626);
}

.usuarios-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--espacio-4, 16px);
  align-content: start;
}

.usuario-card {
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 16px;
  padding: var(--espacio-4, 16px);
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  transition: border-color 0.15s, box-shadow 0.15s;
}

.usuario-card:hover {
  border-color: var(--tenant-primario, #c2600a);
  box-shadow: 0 4px 16px rgba(0,0,0,0.06);
}

.usuario-avatar {
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

.usuario-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.usuario-info strong {
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
}

.rol-pill {
  display: inline-block;
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
  background: rgba(194, 96, 10, 0.08);
  color: var(--tenant-primario, #c2600a);
  border: 1px solid rgba(194, 96, 10, 0.15);
  border-radius: 20px;
  padding: 1px 10px;
}

.card-btn {
  width: 30px;
  height: 30px;
  border-radius: 8px;
  border: 1px solid var(--color-borde, #e8ddd5);
  background: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
  color: var(--tenant-texto-muted, #7c6a5a);
  flex-shrink: 0;
}

.card-btn svg { width: 14px; height: 14px; }

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
}

.empty-state svg { width: 48px; height: 48px; color: var(--color-borde, #e8ddd5); }
.empty-state p { margin: 0; font-size: var(--font-size-base, 15px); color: var(--tenant-texto-muted, #7c6a5a); }

/* Buttons */
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

.btn-danger {
  background: var(--color-error, #dc2626);
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
.btn-danger:hover { background: #b91c1c; }
.btn-danger:disabled { opacity: 0.6; cursor: not-allowed; }

/* Modal */
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
  max-width: 400px;
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

.modal-header h2 { margin: 0; font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }

.modal-close { background: none; border: none; cursor: pointer; color: var(--tenant-texto-muted, #7c6a5a); display: flex; padding: 4px; border-radius: 6px; transition: background 0.15s; }
.modal-close:hover { background: var(--color-hover, #f0ebe5); }
.modal-close svg { width: 18px; height: 18px; }

.modal-body { padding: var(--espacio-6, 24px); display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }

.confirm-msg { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); line-height: 1.5; }
.confirm-msg strong { color: var(--tenant-texto, #1c1410); }

.field { display: flex; flex-direction: column; gap: var(--espacio-2, 8px); }
.field label { font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.08em; font-weight: var(--font-weight-medium, 500); color: var(--tenant-texto-muted, #7c6a5a); }
.field input, .field select { background: var(--tenant-fondo, #f5f0eb); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 10px; padding: var(--espacio-3, 12px) var(--espacio-4, 16px); font-size: var(--font-size-base, 15px); color: var(--tenant-texto, #1c1410); font-family: var(--tenant-fuente, sans-serif); outline: none; transition: border-color 0.2s; }
.field input:focus, .field select:focus { border-color: var(--tenant-primario, #c2600a); }

.error-msg { background: rgba(220, 38, 38, 0.08); border: 1px solid rgba(220, 38, 38, 0.2); border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-3, 12px); font-size: var(--font-size-sm, 13px); color: var(--color-error, #dc2626); }

.modal-footer { display: flex; gap: var(--espacio-3, 12px); justify-content: flex-end; padding: var(--espacio-4, 16px) var(--espacio-6, 24px); border-top: 1px solid var(--color-borde, #e8ddd5); }

.spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.35); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }
@keyframes spin { to { transform: rotate(360deg); } }

.watermark { position: absolute; bottom: var(--espacio-6, 24px); right: var(--espacio-8, 32px); display: flex; align-items: center; gap: var(--espacio-2, 8px); font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #7c6a5a); pointer-events: none; }
.watermark strong { color: var(--tenant-primario, #c2600a); font-weight: var(--font-weight-bold, 600); }

.modal-enter-active, .modal-leave-active { transition: opacity 0.2s, transform 0.2s; }
.modal-enter-from, .modal-leave-to { opacity: 0; transform: scale(0.97); }
</style>