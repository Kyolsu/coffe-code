<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── TIPOS ──────────────────────────────────────────────
interface Perfil {
  id: number
  nombre: string
  rol: number
}

const ROL_LABEL: Record<number, string> = {
  1: 'Administrador',
  2: 'Gerente',
  3: 'Cajero',
  4: 'Cocinero',
}

// ── ESTADO ─────────────────────────────────────────────
const perfil       = ref<Perfil | null>(null)
const cargando     = ref(false)
const errorGlobal  = ref('')

// Modal crear usuario
const modalNuevo   = ref(false)
const guardando    = ref(false)
const errorModal   = ref('')
const formNuevo    = ref({ usuario: '', contra: '', rol: 3 })

// Modal eliminar usuario
const modalEliminar    = ref(false)
const eliminando       = ref(false)
const errorEliminar    = ref('')
const formEliminar     = ref({ usuario: '', contra: '' })

// Modal cambiar contraseña/usuario
const modalActualizar   = ref(false)
const actualizando      = ref(false)
const errorActualizar   = ref('')
const formActualizar    = ref({
  usuario_actual:  '',
  contra_actual:   '',
  nuevo_nombre:    '',
  nueva_contra:    '',
})

// ── PERFIL PROPIO ──────────────────────────────────────
// GET /api/usuarios/perfil — requiere auth-token
const fetchPerfil = async () => {
  cargando.value    = true
  errorGlobal.value = ''
  try {
    const datos = await authStore.fetchPerfil()
    if (datos) {
      perfil.value = datos
    } else {
      errorGlobal.value = 'No se pudo obtener el perfil'
    }
  } catch {
    errorGlobal.value = 'Error al cargar perfil'
  } finally {
    cargando.value = false
  }
}

// ── CREAR USUARIO ─────────────────────────────────────
// POST /api/usuarios/registro — requiere auth-token
const registrarUsuario = async () => {
  guardando.value  = true
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

// ── ELIMINAR USUARIO ──────────────────────────────────
// DELETE /api/usuarios/eliminar — usa usuario+contra para confirmar
const eliminarUsuario = async () => {
  eliminando.value    = true
  errorEliminar.value = ''
  try {
    const res  = await fetch(`${API_URL}/api/usuarios/eliminar`, {
      method: 'DELETE',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        usuario: formEliminar.value.usuario,
        contra:  formEliminar.value.contra,
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
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

// ── ACTUALIZAR PERFIL PROPIO ──────────────────────────
// PUT /api/usuarios/actualizar
const actualizarPerfil = async () => {
  actualizando.value    = true
  errorActualizar.value = ''
  try {
    const body: Record<string, string> = {
      usuario_actual: formActualizar.value.usuario_actual,
      contra_actual:  formActualizar.value.contra_actual,
    }
    if (formActualizar.value.nuevo_nombre)  body.nuevo_nombre = formActualizar.value.nuevo_nombre
    if (formActualizar.value.nueva_contra)  body.nueva_contra = formActualizar.value.nueva_contra

    const res  = await fetch(`${API_URL}/api/usuarios/actualizar`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify(body),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      // Refrescar perfil si cambió el nombre
      if (formActualizar.value.nuevo_nombre) {
        localStorage.setItem('coffe_nombre', formActualizar.value.nuevo_nombre)
      }
      await fetchPerfil()
      cerrarModalActualizar()
    } else {
      errorActualizar.value = data.mensaje
    }
  } catch {
    errorActualizar.value = 'Error al actualizar perfil'
  } finally {
    actualizando.value = false
  }
}

// ── MODALES ────────────────────────────────────────────
const cerrarModalNuevo      = () => { modalNuevo.value = false; errorModal.value = ''; formNuevo.value = { usuario: '', contra: '', rol: 3 } }
const cerrarModalEliminar   = () => { modalEliminar.value = false; errorEliminar.value = ''; formEliminar.value = { usuario: '', contra: '' } }
const cerrarModalActualizar = () => { modalActualizar.value = false; errorActualizar.value = ''; formActualizar.value = { usuario_actual: '', contra_actual: '', nuevo_nombre: '', nueva_contra: '' } }

const abrirActualizar = () => {
  formActualizar.value.usuario_actual = perfil.value?.nombre ?? ''
  modalActualizar.value = true
}

onMounted(fetchPerfil)
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
        <div class="header-actions">
          <button class="btn-ghost" @click="modalEliminar = true">
            <svg viewBox="0 0 24 24" fill="none"><polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            Eliminar usuario
          </button>
          <button class="btn-primary" @click="modalNuevo = true">
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            Nuevo usuario
          </button>
        </div>
      </header>

      <div v-if="errorGlobal" class="error-banner">{{ errorGlobal }}</div>
      <div v-if="cargando" class="state-msg">Cargando perfil...</div>

      <!-- TARJETA DE PERFIL PROPIO -->
      <div v-if="perfil" class="perfil-section">
        <p class="section-label">Tu perfil actual</p>
        <div class="perfil-card">
          <div class="perfil-avatar">{{ perfil.nombre.charAt(0).toUpperCase() }}</div>
          <div class="perfil-info">
            <strong class="perfil-nombre">{{ perfil.nombre }}</strong>
            <span class="rol-pill">{{ ROL_LABEL[perfil.rol] ?? `Rol ${perfil.rol}` }}</span>
            <span class="perfil-id">ID #{{ perfil.id }}</span>
          </div>
          <button class="btn-ghost" @click="abrirActualizar">
            <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Editar perfil
          </button>
        </div>
      </div>

      <!-- AVISO: listado no disponible -->
      <div class="info-card">
        <svg viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
          <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
        <div>
          <p class="info-title">Listado de usuarios</p>
          <p class="info-desc">El endpoint para listar todos los usuarios aún no está disponible en la API. Puedes crear o eliminar usuarios usando los botones de arriba.</p>
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
            <div class="field"><label>Nombre de usuario</label><input v-model="formNuevo.usuario" placeholder="usuario123" /></div>
            <div class="field"><label>Contraseña</label><input v-model="formNuevo.contra" type="password" placeholder="••••••••" /></div>
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
              <span v-if="!guardando">Registrar</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- Modal: Eliminar usuario -->
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
            <p class="confirm-msg">Ingresa el usuario a eliminar y confirma con su contraseña.</p>
            <div class="field"><label>Usuario a eliminar</label><input v-model="formEliminar.usuario" placeholder="nombre_usuario" /></div>
            <div class="field"><label>Contraseña del usuario</label><input v-model="formEliminar.contra" type="password" placeholder="••••••••" /></div>
            <div v-if="errorEliminar" class="error-msg">{{ errorEliminar }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalEliminar">Cancelar</button>
            <button class="btn-danger" :disabled="eliminando" @click="eliminarUsuario">
              <span v-if="!eliminando">Eliminar</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- Modal: Actualizar perfil -->
    <Transition name="modal">
      <div v-if="modalActualizar" class="modal-overlay" @click.self="cerrarModalActualizar">
        <div class="modal">
          <div class="modal-header">
            <h2>Editar perfil</h2>
            <button class="modal-close" @click="cerrarModalActualizar">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <p class="confirm-msg">Ingresa tu contraseña actual para confirmar los cambios.</p>
            <div class="field"><label>Usuario actual</label><input v-model="formActualizar.usuario_actual" /></div>
            <div class="field"><label>Contraseña actual</label><input v-model="formActualizar.contra_actual" type="password" placeholder="••••••••" /></div>
            <div class="field"><label>Nuevo nombre (opcional)</label><input v-model="formActualizar.nuevo_nombre" placeholder="Dejar vacío para no cambiar" /></div>
            <div class="field"><label>Nueva contraseña (opcional)</label><input v-model="formActualizar.nueva_contra" type="password" placeholder="Dejar vacío para no cambiar" /></div>
            <div v-if="errorActualizar" class="error-msg">{{ errorActualizar }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalActualizar">Cancelar</button>
            <button class="btn-primary" :disabled="actualizando" @click="actualizarPerfil">
              <span v-if="!actualizando">Guardar cambios</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.usuarios-layout { display: flex; min-height: 100vh; background: var(--tenant-fondo, #f5f0eb); }

.usuarios-main { flex: 1; padding: var(--espacio-8, 32px); display: flex; flex-direction: column; gap: var(--espacio-5, 20px); position: relative; overflow-y: auto; }

.page-header { display: flex; align-items: flex-end; justify-content: space-between; gap: var(--espacio-4, 16px); }
.header-label { margin: 0; font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.1em; color: var(--tenant-texto-muted, #7c6a5a); font-weight: var(--font-weight-medium, 500); }
.page-title { margin: 0; font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.header-actions { display: flex; gap: var(--espacio-3, 12px); }

.error-banner { background: rgba(220,38,38,0.08); border: 1px solid rgba(220,38,38,0.2); border-radius: 10px; padding: var(--espacio-3, 12px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); color: var(--color-error, #dc2626); }
.state-msg { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); }

/* Perfil */
.perfil-section { display: flex; flex-direction: column; gap: var(--espacio-3, 12px); }
.section-label { margin: 0; font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.1em; color: var(--tenant-texto-muted, #7c6a5a); font-weight: var(--font-weight-medium, 500); }

.perfil-card { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 16px; padding: var(--espacio-5, 20px); display: flex; align-items: center; gap: var(--espacio-4, 16px); max-width: 480px; }

.perfil-avatar { width: 52px; height: 52px; border-radius: 50%; background: rgba(194,96,10,0.1); color: var(--tenant-primario, #c2600a); display: flex; align-items: center; justify-content: center; font-size: var(--font-size-xl, 24px); font-weight: var(--font-weight-bold, 600); flex-shrink: 0; }

.perfil-info { flex: 1; display: flex; flex-direction: column; gap: 4px; }
.perfil-nombre { font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.perfil-id { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #7c6a5a); }

.rol-pill { display: inline-block; font-size: var(--font-size-xs, 11px); font-weight: var(--font-weight-medium, 500); background: rgba(194,96,10,0.08); color: var(--tenant-primario, #c2600a); border: 1px solid rgba(194,96,10,0.15); border-radius: 20px; padding: 1px 10px; width: fit-content; }

/* Info card */
.info-card { display: flex; gap: var(--espacio-4, 16px); background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 16px; padding: var(--espacio-5, 20px); max-width: 560px; }
.info-card svg { width: 20px; height: 20px; color: var(--color-info, #2563eb); flex-shrink: 0; margin-top: 1px; }
.info-title { margin: 0 0 4px; font-size: var(--font-size-base, 15px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.info-desc { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); line-height: 1.5; }

/* Buttons */
.btn-primary { display: flex; align-items: center; gap: var(--espacio-2, 8px); background: var(--tenant-primario, #c2600a); color: #fff; border: none; border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-bold, 600); cursor: pointer; font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s; white-space: nowrap; }
.btn-primary svg { width: 15px; height: 15px; }
.btn-primary:hover { background: #a8520a; }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }

.btn-ghost { display: flex; align-items: center; gap: var(--espacio-2, 8px); background: transparent; border: 1px solid var(--color-borde, #e8ddd5); color: var(--tenant-texto-muted, #7c6a5a); border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-medium, 500); cursor: pointer; font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s; white-space: nowrap; }
.btn-ghost svg { width: 15px; height: 15px; }
.btn-ghost:hover { background: var(--color-hover, #f0ebe5); }

.btn-danger { background: var(--color-error, #dc2626); color: #fff; border: none; border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-bold, 600); cursor: pointer; font-family: var(--tenant-fuente, sans-serif); transition: background 0.15s; }
.btn-danger:hover { background: #b91c1c; }
.btn-danger:disabled { opacity: 0.6; cursor: not-allowed; }

/* Modal */
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.35); display: flex; align-items: center; justify-content: center; z-index: 100; padding: var(--espacio-6, 24px); backdrop-filter: blur(2px); }
.modal { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 20px; width: 100%; max-width: 420px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 24px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; align-items: center; justify-content: space-between; padding: var(--espacio-5, 20px) var(--espacio-6, 24px); border-bottom: 1px solid var(--color-borde, #e8ddd5); }
.modal-header h2 { margin: 0; font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.modal-close { background: none; border: none; cursor: pointer; color: var(--tenant-texto-muted, #7c6a5a); display: flex; padding: 4px; border-radius: 6px; transition: background 0.15s; }
.modal-close:hover { background: var(--color-hover, #f0ebe5); }
.modal-close svg { width: 18px; height: 18px; }
.modal-body { padding: var(--espacio-6, 24px); display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }
.confirm-msg { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); line-height: 1.5; }
.field { display: flex; flex-direction: column; gap: var(--espacio-2, 8px); }
.field label { font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.08em; font-weight: var(--font-weight-medium, 500); color: var(--tenant-texto-muted, #7c6a5a); }
.field input, .field select { background: var(--tenant-fondo, #f5f0eb); border: 1px solid var(--color-borde, #e8ddd5); border-radius: 10px; padding: var(--espacio-3, 12px) var(--espacio-4, 16px); font-size: var(--font-size-base, 15px); color: var(--tenant-texto, #1c1410); font-family: var(--tenant-fuente, sans-serif); outline: none; transition: border-color 0.2s; }
.field input:focus, .field select:focus { border-color: var(--tenant-primario, #c2600a); }
.error-msg { background: rgba(220,38,38,0.08); border: 1px solid rgba(220,38,38,0.2); border-radius: 10px; padding: var(--espacio-2, 8px) var(--espacio-3, 12px); font-size: var(--font-size-sm, 13px); color: var(--color-error, #dc2626); }
.modal-footer { display: flex; gap: var(--espacio-3, 12px); justify-content: flex-end; padding: var(--espacio-4, 16px) var(--espacio-6, 24px); border-top: 1px solid var(--color-borde, #e8ddd5); }
.spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.35); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }
@keyframes spin { to { transform: rotate(360deg); } }

.watermark { position: absolute; bottom: var(--espacio-6, 24px); right: var(--espacio-8, 32px); display: flex; align-items: center; gap: var(--espacio-2, 8px); font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #7c6a5a); pointer-events: none; }
.watermark strong { color: var(--tenant-primario, #c2600a); font-weight: var(--font-weight-bold, 600); }

.modal-enter-active, .modal-leave-active { transition: opacity 0.2s, transform 0.2s; }
.modal-enter-from, .modal-leave-to { opacity: 0; transform: scale(0.97); }
</style>