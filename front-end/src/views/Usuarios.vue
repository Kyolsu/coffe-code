<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── ROL ────────────────────────────────────────────────
const ROL_LABEL: Record<number, string> = {
  1: 'Administrador',
  2: 'Gerente',
  3: 'Cajero',
  4: 'Cocinero',
}

// ── TOAST ──────────────────────────────────────────────
const toast = ref<{ tipo: 'ok' | 'error'; mensaje: string } | null>(null)
let toastTimer: ReturnType<typeof setTimeout>

const mostrarToast = (tipo: 'ok' | 'error', mensaje: string) => {
  clearTimeout(toastTimer)
  toast.value = { tipo, mensaje }
  toastTimer = setTimeout(() => { toast.value = null }, 3500)
}

// ── MODAL CREAR ────────────────────────────────────────
// POST /api/usuarios/registro — no requiere token según el código del backend
const modalCrear  = ref(false)
const creando     = ref(false)
const errorCrear  = ref('')
const formCrear   = ref({ usuario: '', contra: '', rol: 3 })

const registrarUsuario = async () => {
  creando.value    = true
  errorCrear.value = ''
  try {
    const res  = await fetch(`${API_URL}/api/usuarios/registro`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        usuario: formCrear.value.usuario,
        contra:  formCrear.value.contra,
        rol:     formCrear.value.rol,
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      mostrarToast('ok', `Usuario "${formCrear.value.usuario}" registrado`)
      cerrarModalCrear()
    } else {
      errorCrear.value = data.mensaje
    }
  } catch {
    errorCrear.value = 'No se pudo conectar con el servidor'
  } finally {
    creando.value = false
  }
}

const cerrarModalCrear = () => {
  modalCrear.value  = false
  errorCrear.value  = ''
  formCrear.value   = { usuario: '', contra: '', rol: 3 }
}

// ── MODAL MODIFICAR ────────────────────────────────────
// PUT /api/usuarios/actualizar
// Requiere: usuario_actual + contra_actual para confirmar
// Se puede cambiar: nuevo_nombre y/o nueva_contra
const modalModificar  = ref(false)
const modificando     = ref(false)
const errorModificar  = ref('')
const formModificar   = ref({
  usuario_actual: '',
  contra_actual:  '',
  nuevo_nombre:   '',
  nueva_contra:   '',
})

const actualizarUsuario = async () => {
  modificando.value    = true
  errorModificar.value = ''
  try {
    const body: Record<string, string> = {
      usuario_actual: formModificar.value.usuario_actual,
      contra_actual:  formModificar.value.contra_actual,
    }
    if (formModificar.value.nuevo_nombre.trim()) body.nuevo_nombre = formModificar.value.nuevo_nombre.trim()
    if (formModificar.value.nueva_contra.trim()) body.nueva_contra = formModificar.value.nueva_contra.trim()

    const res  = await fetch(`${API_URL}/api/usuarios/actualizar`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify(body),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      mostrarToast('ok', 'Usuario actualizado correctamente')
      cerrarModalModificar()
    } else {
      errorModificar.value = data.mensaje
    }
  } catch {
    errorModificar.value = 'No se pudo conectar con el servidor'
  } finally {
    modificando.value = false
  }
}

const cerrarModalModificar = () => {
  modalModificar.value  = false
  errorModificar.value  = ''
  formModificar.value   = { usuario_actual: '', contra_actual: '', nuevo_nombre: '', nueva_contra: '' }
}

// ── MODAL ELIMINAR ─────────────────────────────────────
// DELETE /api/usuarios/eliminar
// Requiere: nombre del usuario + su contraseña para confirmar
const modalEliminar  = ref(false)
const eliminando     = ref(false)
const errorEliminar  = ref('')
const formEliminar   = ref({ usuario: '', contra: '' })

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
      mostrarToast('ok', `Usuario "${formEliminar.value.usuario}" eliminado`)
      cerrarModalEliminar()
    } else {
      errorEliminar.value = data.mensaje
    }
  } catch {
    errorEliminar.value = 'No se pudo conectar con el servidor'
  } finally {
    eliminando.value = false
  }
}

const cerrarModalEliminar = () => {
  modalEliminar.value  = false
  errorEliminar.value  = ''
  formEliminar.value   = { usuario: '', contra: '' }
}
</script>

<template>
  <div class="usuarios-layout">
    <Sidebar />

    <main class="usuarios-main">

      <!-- HEADER -->
      <header class="page-header">
        <div>
          <p class="header-label">Administración</p>
          <h1 class="page-title">Usuarios</h1>
        </div>
      </header>

      <!-- ACCIONES PRINCIPALES -->
      <div class="actions-grid">

        <!-- Crear usuario -->
        <div class="action-card action-card--create">
          <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M19 8v6M16 11h6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="action-body">
            <h3>Registrar usuario</h3>
            <p>Crea un nuevo usuario y asígnale un rol</p>
          </div>
          <button class="btn-primary" @click="modalCrear = true">Registrar</button>
        </div>

        <!-- Modificar usuario -->
        <div class="action-card action-card--edit">
          <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M16.5 19.5l1.5-1.5 1.5 1.5M18 18v3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="action-body">
            <h3>Modificar usuario</h3>
            <p>Cambia el nombre o contraseña de un usuario</p>
          </div>
          <button class="btn-secondary" @click="modalModificar = true">Modificar</button>
        </div>

        <!-- Eliminar usuario -->
        <div class="action-card action-card--delete">
          <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M17 13l4 4M21 13l-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="action-body">
            <h3>Eliminar usuario</h3>
            <p>Da de baja a un usuario del sistema</p>
          </div>
          <button class="btn-danger" @click="modalEliminar = true">Eliminar</button>
        </div>

      </div>

      <!-- AVISO listado no disponible -->
      <div class="info-card">
        <svg viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
          <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
        <div>
          <p class="info-title">Listado de usuarios no disponible</p>
          <p class="info-desc">
            La API no cuenta con un endpoint para listar todos los usuarios. Usa los formularios de arriba para gestionar usuarios por nombre. Para ver tu propio perfil ve a <strong>Mi Perfil</strong> desde el menú.
          </p>
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

    <!-- ── MODAL CREAR ── -->
    <Transition name="modal">
      <div v-if="modalCrear" class="modal-overlay" @click.self="cerrarModalCrear">
        <div class="modal">
          <div class="modal-header">
            <h2>Registrar usuario</h2>
            <button class="modal-close" @click="cerrarModalCrear">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <div class="field">
              <label>Nombre de usuario</label>
              <input v-model="formCrear.usuario" placeholder="usuario123" autocomplete="off" />
            </div>
            <div class="field">
              <label>Contraseña</label>
              <input v-model="formCrear.contra" type="password" placeholder="••••••••" />
            </div>
            <div class="field">
              <label>Rol</label>
              <select v-model="formCrear.rol">
                <option v-for="(label, id) in ROL_LABEL" :key="id" :value="Number(id)">{{ label }}</option>
              </select>
            </div>
            <div v-if="errorCrear" class="error-msg">{{ errorCrear }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalCrear">Cancelar</button>
            <button class="btn-primary" :disabled="creando" @click="registrarUsuario">
              <span v-if="!creando">Registrar</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- ── MODAL MODIFICAR ── -->
    <Transition name="modal">
      <div v-if="modalModificar" class="modal-overlay" @click.self="cerrarModalModificar">
        <div class="modal">
          <div class="modal-header">
            <h2>Modificar usuario</h2>
            <button class="modal-close" @click="cerrarModalModificar">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <p class="hint-msg">Ingresa los datos actuales del usuario para confirmar la identidad, luego los campos que quieras cambiar.</p>
            <div class="field-group-label">Identificación</div>
            <div class="field">
              <label>Usuario actual</label>
              <input v-model="formModificar.usuario_actual" placeholder="nombre_actual" autocomplete="off" />
            </div>
            <div class="field">
              <label>Contraseña actual</label>
              <input v-model="formModificar.contra_actual" type="password" placeholder="••••••••" />
            </div>
            <div class="field-group-label">Cambios (dejar vacío para no modificar)</div>
            <div class="field">
              <label>Nuevo nombre de usuario</label>
              <input v-model="formModificar.nuevo_nombre" placeholder="nuevo_nombre (opcional)" autocomplete="off" />
            </div>
            <div class="field">
              <label>Nueva contraseña</label>
              <input v-model="formModificar.nueva_contra" type="password" placeholder="••••••••  (opcional)" />
            </div>
            <div v-if="errorModificar" class="error-msg">{{ errorModificar }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalModificar">Cancelar</button>
            <button class="btn-secondary" :disabled="modificando" @click="actualizarUsuario">
              <span v-if="!modificando">Guardar cambios</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- ── MODAL ELIMINAR ── -->
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
            <p class="hint-msg">Para confirmar la eliminación, ingresa el nombre del usuario y su contraseña. Esta acción no se puede deshacer.</p>
            <div class="field">
              <label>Nombre de usuario</label>
              <input v-model="formEliminar.usuario" placeholder="usuario_a_eliminar" autocomplete="off" />
            </div>
            <div class="field">
              <label>Contraseña del usuario</label>
              <input v-model="formEliminar.contra" type="password" placeholder="••••••••" />
            </div>
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

  </div>
</template>

<style scoped>
.usuarios-layout { display: flex; min-height: 100vh; background: var(--tenant-fondo, #f5f0eb); }

.usuarios-main {
  flex: 1;
  padding: var(--espacio-8, 32px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-6, 24px);
  position: relative;
  overflow-y: auto;
}

/* HEADER */
.page-header { display: flex; align-items: flex-end; justify-content: space-between; }
.header-label { margin: 0; font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.1em; color: var(--tenant-texto-muted, #7c6a5a); font-weight: var(--font-weight-medium, 500); }
.page-title { margin: 0; font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }

/* ACTIONS GRID */
.actions-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--espacio-4, 16px);
}

.action-card {
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 16px;
  padding: var(--espacio-5, 20px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-4, 16px);
  transition: box-shadow 0.15s, border-color 0.15s;
}

.action-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.06); }

.action-card--create { border-top: 3px solid var(--color-exitoso, #16a34a); }
.action-card--edit   { border-top: 3px solid var(--tenant-primario, #c2600a); }
.action-card--delete { border-top: 3px solid var(--color-error, #dc2626); }

.action-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-icon svg { width: 22px; height: 22px; }

.action-card--create .action-icon { background: rgba(22,163,74,0.1);    color: var(--color-exitoso, #16a34a); }
.action-card--edit   .action-icon { background: rgba(194,96,10,0.1);    color: var(--tenant-primario, #c2600a); }
.action-card--delete .action-icon { background: rgba(220,38,38,0.1);    color: var(--color-error, #dc2626); }

.action-body { flex: 1; }
.action-body h3 { margin: 0 0 4px; font-size: var(--font-size-base, 15px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.action-body p  { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); line-height: 1.4; }

/* INFO CARD */
.info-card {
  display: flex;
  gap: var(--espacio-4, 16px);
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-left: 3px solid var(--color-info, #2563eb);
  border-radius: 12px;
  padding: var(--espacio-4, 16px) var(--espacio-5, 20px);
}

.info-card svg { width: 18px; height: 18px; color: var(--color-info, #2563eb); flex-shrink: 0; margin-top: 1px; }
.info-title { margin: 0 0 4px; font-size: var(--font-size-sm, 13px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }
.info-desc  { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); line-height: 1.5; }
.info-desc strong { color: var(--tenant-texto, #1c1410); }

/* BUTTONS */
.btn-primary  { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--color-exitoso,#16a34a); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-primary:hover { background: #15803d; }
.btn-primary:disabled { opacity:.6; cursor:not-allowed; }

.btn-secondary { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--tenant-primario,#c2600a); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-secondary:hover { background: #a8520a; }
.btn-secondary:disabled { opacity:.6; cursor:not-allowed; }

.btn-danger { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--color-error,#dc2626); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-danger:hover { background: #b91c1c; }
.btn-danger:disabled { opacity:.6; cursor:not-allowed; }

.btn-ghost { background:transparent; border:1px solid var(--color-borde,#e8ddd5); color:var(--tenant-texto-muted,#7c6a5a); border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-medium,500); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-ghost:hover { background: var(--color-hover, #f0ebe5); }

/* MODAL */
.modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.35); display:flex; align-items:center; justify-content:center; z-index:100; padding:var(--espacio-6,24px); backdrop-filter:blur(2px); }
.modal { background:var(--color-superficie,#fff); border:1px solid var(--color-borde,#e8ddd5); border-radius:20px; width:100%; max-width:440px; display:flex; flex-direction:column; overflow:hidden; box-shadow:0 24px 60px rgba(0,0,0,0.15); }
.modal-header { display:flex; align-items:center; justify-content:space-between; padding:var(--espacio-5,20px) var(--espacio-6,24px); border-bottom:1px solid var(--color-borde,#e8ddd5); }
.modal-header h2 { margin:0; font-size:var(--font-size-md,17px); font-weight:var(--font-weight-bold,600); color:var(--tenant-texto,#1c1410); }
.modal-close { background:none; border:none; cursor:pointer; color:var(--tenant-texto-muted,#7c6a5a); display:flex; padding:4px; border-radius:6px; transition:background .15s; }
.modal-close:hover { background:var(--color-hover,#f0ebe5); }
.modal-close svg { width:18px; height:18px; }
.modal-body { padding:var(--espacio-6,24px); display:flex; flex-direction:column; gap:var(--espacio-4,16px); }
.modal-footer { display:flex; gap:var(--espacio-3,12px); justify-content:flex-end; padding:var(--espacio-4,16px) var(--espacio-6,24px); border-top:1px solid var(--color-borde,#e8ddd5); }

.hint-msg { margin:0; font-size:var(--font-size-sm,13px); color:var(--tenant-texto-muted,#7c6a5a); line-height:1.5; background:var(--tenant-fondo,#f5f0eb); border-radius:8px; padding:var(--espacio-3,12px); }

.field-group-label { font-size:var(--font-size-xs,11px); text-transform:uppercase; letter-spacing:0.1em; color:var(--tenant-texto-muted,#7c6a5a); font-weight:var(--font-weight-medium,500); border-bottom:1px solid var(--color-borde,#e8ddd5); padding-bottom:var(--espacio-2,8px); }

.field { display:flex; flex-direction:column; gap:var(--espacio-2,8px); }
.field label { font-size:var(--font-size-xs,11px); text-transform:uppercase; letter-spacing:.08em; font-weight:var(--font-weight-medium,500); color:var(--tenant-texto-muted,#7c6a5a); }
.field input, .field select { background:var(--tenant-fondo,#f5f0eb); border:1px solid var(--color-borde,#e8ddd5); border-radius:10px; padding:var(--espacio-3,12px) var(--espacio-4,16px); font-size:var(--font-size-base,15px); color:var(--tenant-texto,#1c1410); font-family:var(--tenant-fuente,sans-serif); outline:none; transition:border-color .2s; }
.field input:focus, .field select:focus { border-color:var(--tenant-primario,#c2600a); }

.error-msg { background:rgba(220,38,38,.08); border:1px solid rgba(220,38,38,.2); border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-3,12px); font-size:var(--font-size-sm,13px); color:var(--color-error,#dc2626); }

/* TOAST */
.toast { position:fixed; bottom:var(--espacio-6,24px); left:50%; transform:translateX(-50%); display:flex; align-items:center; gap:var(--espacio-3,12px); padding:var(--espacio-3,12px) var(--espacio-5,20px); border-radius:50px; font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-medium,500); z-index:200; box-shadow:0 8px 30px rgba(0,0,0,.15); white-space:nowrap; }
.toast svg { width:16px; height:16px; flex-shrink:0; }
.toast--ok    { background:var(--color-exitoso,#16a34a); color:#fff; }
.toast--error { background:var(--color-error,#dc2626);  color:#fff; }

.spinner { width:16px; height:16px; border:2px solid rgba(255,255,255,.35); border-top-color:#fff; border-radius:50%; animation:spin .7s linear infinite; display:inline-block; }
@keyframes spin { to { transform:rotate(360deg); } }

.watermark { position:absolute; bottom:var(--espacio-6,24px); right:var(--espacio-8,32px); display:flex; align-items:center; gap:var(--espacio-2,8px); font-size:var(--font-size-xs,11px); color:var(--tenant-texto-muted,#7c6a5a); pointer-events:none; }
.watermark strong { color:var(--tenant-primario,#c2600a); font-weight:var(--font-weight-bold,600); }

.modal-enter-active, .modal-leave-active { transition:opacity .2s, transform .2s; }
.modal-enter-from, .modal-leave-to { opacity:0; transform:scale(.97); }
.toast-enter-active, .toast-leave-active { transition:opacity .25s, transform .25s; }
.toast-enter-from { opacity:0; transform:translateX(-50%) translateY(12px); }
.toast-leave-to   { opacity:0; transform:translateX(-50%) translateY(12px); }
</style>