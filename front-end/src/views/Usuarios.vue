<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── ESTADO DE DATOS ────────────────────────────────────
const usuarios = ref<any[]>([])
const rolesList = ref<any[]>([]) // Lista dinámica de roles desde la BD
const searchQuery = ref('')

const fetchRoles = async () => {
  try {
    const res = await fetch(`${API_URL}/api/usuarios/rol/mostrar`, {
      headers: authStore.authHeaders()
    })
    const data = await res.json()
    rolesList.value = data.status === 'ok' ? data.datos : []
  } catch (error) {
    console.error("Error al cargar roles:", error)
  }
}

const fetchUsuarios = async () => {
  try {
    const res = await fetch(`${API_URL}/api/usuarios/todos-usuarios`, {
      headers: authStore.authHeaders()
    })
    const data = await res.json()
    usuarios.value = data.status === 'ok' ? data.datos : []
  } catch (error) {
    console.error("Error al cargar usuarios:", error)
  }
}

onMounted(() => {
  fetchRoles()
  fetchUsuarios()
})

const filteredUsuarios = computed(() => {
  const q = searchQuery.value.toLowerCase()
  return usuarios.value.filter(u => {
    const nombre = (u.nombre_usuario || u.usuario || u.nombre || '').toLowerCase()
    return nombre.includes(q)
  })
})

// ── TOAST ──────────────────────────────────────────────
const toast = ref<{ tipo: 'ok' | 'error'; mensaje: string } | null>(null)
let toastTimer: ReturnType<typeof setTimeout>

const mostrarToast = (tipo: 'ok' | 'error', mensaje: string) => {
  clearTimeout(toastTimer)
  toast.value = { tipo, mensaje }
  toastTimer = setTimeout(() => { toast.value = null }, 3500)
}

// ── MODAL CREAR ────────────────────────────────────────
const modalCrear  = ref(false)
const creando     = ref(false)
const errorCrear  = ref('')
const formCrear   = ref({ usuario: '', contra: '', rol: '' as number | string })

const registrarUsuario = async () => {
  if (!formCrear.value.rol) {
    errorCrear.value = 'Debes seleccionar un rol'
    return
  }

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
      fetchUsuarios() 
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
  formCrear.value   = { usuario: '', contra: '', rol: '' }
}

// ── MODAL MODIFICAR ────────────────────────────────────
const modalModificar  = ref(false)
const modificando     = ref(false)
const errorModificar  = ref('')
const formModificar   = ref({
  usuario_actual: '',
  contra_actual:  '',
  nuevo_nombre:   '',
  nueva_contra:   ''
})

const abrirModalModificar = (user: any) => {
  const nombreActual = user.nombre_usuario || user.usuario || user.nombre;
  formModificar.value = {
    usuario_actual: nombreActual,
    contra_actual:  '',
    nuevo_nombre:   nombreActual, 
    nueva_contra:   ''
  }
  modalModificar.value = true
}

const actualizarUsuario = async () => {
  modificando.value    = true
  errorModificar.value = ''
  try {
    const body: any = {
      usuario_actual: formModificar.value.usuario_actual,
      contra_actual:  formModificar.value.contra_actual
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
      fetchUsuarios() 
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
}

// ── MODAL ELIMINAR ─────────────────────────────────────
const modalEliminar  = ref(false)
const eliminando     = ref(false)
const errorEliminar  = ref('')
const formEliminar   = ref({ usuario: '', contra: '' })

const abrirModalEliminar = (user: any) => {
  formEliminar.value = {
    usuario: user.nombre_usuario || user.usuario || user.nombre,
    contra: ''
  }
  modalEliminar.value = true
}

const eliminarUsuario = async () => {
  eliminando.value    = true
  errorEliminar.value = ''
  try {
    const res  = await fetch(`${API_URL}/api/usuarios/eliminar`, {
      method: 'DELETE',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        usuario: formEliminar.value.usuario,
        contra: formEliminar.value.contra
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      mostrarToast('ok', `Usuario "${formEliminar.value.usuario}" eliminado`)
      cerrarModalEliminar()
      fetchUsuarios() 
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
}
</script>

<template>
  <div class="usuarios-layout">
    <Sidebar />

    <main class="usuarios-main">

      <header class="page-header">
        <div class="header-titles">
          <p class="header-label">Administración</p>
          <h1 class="page-title">Usuarios</h1>
        </div>
        
        <div class="header-actions">
          <div class="search-bar">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/><path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Buscar usuario..."
              class="search-input"
            />
          </div>
          <button class="btn-primary" @click="modalCrear = true">
            <svg viewBox="0 0 24 24" fill="none" style="width:16px; height:16px;"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
            Nuevo Usuario
          </button>
        </div>
      </header>

      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre de Usuario</th>
              <th>Rol</th>
              <th class="th-actions">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="u in filteredUsuarios" :key="u.id_usuario || u.id">
              <td>#{{ u.id_usuario || u.id }}</td>
              <td class="td-bold">{{ u.nombre_usuario || u.usuario || u.nombre }}</td>
              <td>
                <span class="role-badge">{{ u.nombre_rol || 'Desconocido' }}</span>
              </td>
              <td class="td-actions">
                <button class="action-btn btn-edit" @click="abrirModalModificar(u)" title="Editar usuario">
                  <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
                <button class="action-btn btn-delete" @click="abrirModalEliminar(u)" title="Eliminar usuario">
                  <svg viewBox="0 0 24 24" fill="none"><polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/></svg>
                </button>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-if="filteredUsuarios.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" fill="none"><path d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          <p>No se encontraron usuarios.</p>
        </div>
      </div>

      <div class="watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </main>

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
                <option value="" disabled>Seleccione un rol...</option>
                <option v-for="r in rolesList" :key="r.id_rol" :value="r.id_rol">
                  {{ r.nombre_rol }}
                </option>
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
            <p class="hint-msg">Por seguridad, ingresa la contraseña actual de <strong>{{ formModificar.usuario_actual }}</strong> para confirmar los cambios.</p>
            
            <div class="field">
              <label>Contraseña actual (Requerida)</label>
              <input v-model="formModificar.contra_actual" type="password" placeholder="••••••••" />
            </div>
            <div class="field">
              <label>Nuevo nombre de usuario</label>
              <input v-model="formModificar.nuevo_nombre" placeholder="Nuevo nombre" autocomplete="off" />
            </div>
            <div class="field">
              <label>Nueva contraseña</label>
              <input v-model="formModificar.nueva_contra" type="password" placeholder="Dejar en blanco para no cambiar" />
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
            <p class="hint-msg">
              Por seguridad, ingresa la contraseña actual de <strong>{{ formEliminar.usuario }}</strong> para dar de baja su cuenta. Esta acción no se puede deshacer.
            </p>
            <div class="field">
              <label>Contraseña del usuario</label>
              <input v-model="formEliminar.contra" type="password" placeholder="••••••••" />
            </div>
            <div v-if="errorEliminar" class="error-msg">{{ errorEliminar }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalEliminar">Cancelar</button>
            <button class="btn-danger" :disabled="eliminando" @click="eliminarUsuario">
              <span v-if="!eliminando">Sí, eliminar</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
.usuarios-layout { 
  display: flex; 
  min-height: 100vh; 
  background: var(--tenant-fondo); 
  font-family: var(--tenant-fuente, sans-serif);
}

.usuarios-main {
  flex: 1;
  padding: var(--espacio-6, 24px) var(--espacio-8, 32px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-6, 24px);
  position: relative;
  overflow-y: auto;
}

/* ── HEADER ── */
.page-header { 
  display: flex; 
  align-items: flex-end; 
  justify-content: space-between; 
}
.header-label { margin: 0; font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.1em; color: color-mix(in srgb, var(--tenant-texto) 60%, transparent); font-weight: var(--font-weight-medium, 500); }
.page-title { margin: 0; font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto); }

.header-actions {
  display: flex;
  gap: var(--espacio-3, 12px);
  align-items: center;
}

.search-bar {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 50px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  transition: border-color 0.2s;
  width: 250px;
}
.search-bar:focus-within { border-color: var(--tenant-primario); }
.search-icon { width: 16px; height: 16px; color: color-mix(in srgb, var(--tenant-texto) 60%, transparent); flex-shrink: 0; }
.search-input { background: none; border: none; outline: none; color: var(--tenant-texto); font-size: var(--font-size-sm, 13px); width: 100%; font-family: var(--tenant-fuente, sans-serif); }
.search-input::placeholder { color: color-mix(in srgb, var(--tenant-texto) 40%, transparent); }

/* ── TABLA DE USUARIOS ── */
.table-container {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th, .data-table td {
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
  text-align: left;
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
}

.data-table th {
  background: color-mix(in srgb, var(--tenant-texto) 2%, transparent);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  font-size: var(--font-size-xs, 11px);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: var(--font-weight-medium, 500);
}

.data-table td {
  font-size: var(--font-size-sm, 14px);
  color: var(--tenant-texto);
}

.td-bold {
  font-weight: var(--font-weight-bold, 600);
}

.role-badge {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  color: var(--tenant-texto);
  padding: 2px 8px;
  border-radius: 12px;
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-bold, 600);
}

.data-table tbody tr {
  transition: background 0.15s;
}

.data-table tbody tr:hover {
  background: color-mix(in srgb, var(--tenant-texto) 3%, transparent);
}

/* Acciones de tabla */
.th-actions { text-align: right; }
.td-actions { display: flex; gap: var(--espacio-2, 8px); justify-content: flex-end; }

.action-btn {
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 8px;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.15s;
}
.action-btn svg { width: 14px; height: 14px; }

.btn-edit { color: color-mix(in srgb, var(--tenant-texto) 60%, transparent); }
.btn-edit:hover {
  background: color-mix(in srgb, var(--tenant-primario) 10%, transparent);
  border-color: color-mix(in srgb, var(--tenant-primario) 25%, transparent);
  color: var(--tenant-primario);
}

.btn-delete { color: color-mix(in srgb, var(--tenant-texto) 60%, transparent); }
.btn-delete:hover {
  background: color-mix(in srgb, var(--color-error, #dc2626) 10%, transparent);
  border-color: color-mix(in srgb, var(--color-error, #dc2626) 25%, transparent);
  color: var(--color-error, #dc2626);
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--espacio-3, 12px);
  padding: var(--espacio-8, 32px) 0;
  color: color-mix(in srgb, var(--tenant-texto) 40%, transparent);
}
.empty-state svg { width: 40px; height: 40px; }
.empty-state p { margin: 0; font-size: var(--font-size-sm, 14px); }

/* ── BUTTONS ── */
.btn-primary  { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--color-exitoso,#16a34a); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-primary:hover { background: color-mix(in srgb, var(--color-exitoso, #16a34a) 85%, black 15%); }
.btn-primary:disabled { opacity:.6; cursor:not-allowed; }

.btn-secondary { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--tenant-primario); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-secondary:hover { background: color-mix(in srgb, var(--tenant-primario) 85%, black 15%); }
.btn-secondary:disabled { opacity:.6; cursor:not-allowed; }

.btn-danger { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--color-error,#dc2626); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-danger:hover { background: color-mix(in srgb, var(--color-error, #dc2626) 85%, black 15%); }
.btn-danger:disabled { opacity:.6; cursor:not-allowed; }

.btn-ghost { background:transparent; border:1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent); color:color-mix(in srgb, var(--tenant-texto) 60%, transparent); border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-medium,500); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:all .15s; }
.btn-ghost:hover { background: color-mix(in srgb, var(--tenant-texto) 5%, transparent); color: var(--tenant-texto); }

/* ── MODAL ── */
.modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.5); display:flex; align-items:center; justify-content:center; z-index:100; padding:var(--espacio-6,24px); backdrop-filter:blur(3px); }
.modal { background:var(--tenant-fondo); border:1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent); border-radius:20px; width:100%; max-width:440px; display:flex; flex-direction:column; overflow:hidden; box-shadow:0 24px 60px rgba(0,0,0,0.3); }
.modal-header { display:flex; align-items:center; justify-content:space-between; padding:var(--espacio-5,20px) var(--espacio-6,24px); border-bottom:1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent); }
.modal-header h2 { margin:0; font-size:var(--font-size-md,17px); font-weight:var(--font-weight-bold,600); color:var(--tenant-texto); }
.modal-close { background:none; border:none; cursor:pointer; color:color-mix(in srgb, var(--tenant-texto) 50%, transparent); display:flex; padding:4px; border-radius:6px; transition:background .15s; }
.modal-close:hover { background:color-mix(in srgb, var(--tenant-texto) 10%, transparent); color:var(--tenant-texto); }
.modal-close svg { width:18px; height:18px; }
.modal-body { padding:var(--espacio-6,24px); display:flex; flex-direction:column; gap:var(--espacio-4,16px); }
.modal-footer { display:flex; gap:var(--espacio-3,12px); justify-content:flex-end; padding:var(--espacio-4,16px) var(--espacio-6,24px); border-top:1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent); }

.hint-msg { margin:0; font-size:var(--font-size-sm,13px); color:color-mix(in srgb, var(--tenant-texto) 70%, transparent); line-height:1.5; background:color-mix(in srgb, var(--tenant-texto) 4%, transparent); border-radius:8px; padding:var(--espacio-3,12px); }

.field { display:flex; flex-direction:column; gap:var(--espacio-2,8px); }
.field label { font-size:var(--font-size-xs,11px); text-transform:uppercase; letter-spacing:.08em; font-weight:var(--font-weight-medium,500); color:color-mix(in srgb, var(--tenant-texto) 60%, transparent); }
.field input, .field select { background:color-mix(in srgb, var(--tenant-texto) 2%, transparent); border:1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent); border-radius:10px; padding:var(--espacio-3,12px) var(--espacio-4,16px); font-size:var(--font-size-base,15px); color:var(--tenant-texto); font-family:var(--tenant-fuente,sans-serif); outline:none; transition:border-color .2s; }
.field input:focus, .field select:focus { border-color:var(--tenant-primario); }

.error-msg { background:color-mix(in srgb, var(--color-error, #dc2626) 10%, transparent); border:1px solid color-mix(in srgb, var(--color-error, #dc2626) 20%, transparent); border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-3,12px); font-size:var(--font-size-sm,13px); color:var(--color-error, #dc2626); }

/* ── TOAST ── */
.toast { position:fixed; bottom:var(--espacio-6,24px); left:50%; transform:translateX(-50%); display:flex; align-items:center; gap:var(--espacio-3,12px); padding:var(--espacio-3,12px) var(--espacio-5,20px); border-radius:50px; font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-medium,500); z-index:200; box-shadow:0 8px 30px rgba(0,0,0,.3); white-space:nowrap; }
.toast svg { width:16px; height:16px; flex-shrink:0; }
.toast--ok    { background:var(--color-exitoso,#16a34a); color:#fff; }
.toast--error { background:var(--color-error,#dc2626);  color:#fff; }

.spinner { width:16px; height:16px; border:2px solid rgba(255,255,255,.35); border-top-color:#fff; border-radius:50%; animation:spin .7s linear infinite; display:inline-block; }
@keyframes spin { to { transform:rotate(360deg); } }

.watermark { position:absolute; bottom:var(--espacio-6,24px); right:var(--espacio-8,32px); display:flex; align-items:center; gap:var(--espacio-2,8px); font-size:var(--font-size-xs,11px); color:color-mix(in srgb, var(--tenant-texto) 40%, transparent); pointer-events:none; }
.watermark strong { color:var(--tenant-primario); font-weight:var(--font-weight-bold,600); }

/* TRANSICIONES */
.modal-enter-active, .modal-leave-active { transition:opacity .2s, transform .2s; }
.modal-enter-from, .modal-leave-to { opacity:0; transform:scale(.97); }
.toast-enter-active, .toast-leave-active { transition:opacity .25s, transform .25s; }
.toast-enter-from { opacity:0; transform:translateX(-50%) translateY(12px); }
.toast-leave-to   { opacity:0; transform:translateX(-50%) translateY(12px); }
</style>