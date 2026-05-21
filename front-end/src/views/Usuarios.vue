<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import API_URL from '../config/api'

const authStore = useAuthStore()

// Permiso 8 = Administrar usuarios (acceso a esta vista)
const puedeAdministrar = computed(() => authStore.tienePermiso(8))

// ── MAPEO DE NOMBRES DE PERMISOS (vistas) ─────────────────────────────────────
const NOMBRE_PERMISOS: Record<number, string> = {
  1: 'Dashboard',
  2: 'Ventas',
  3: 'Menú/Inventario',
  4: 'Órdenes',
  5: 'Cocina (KD)',
  6: 'Clientes',
  7: 'Estadísticas',
  8: 'Usuarios',
}

// ── ESTADOS GLOBALES ─────────────────────────────────────────────────────────
const usuarios = ref<any[]>([])
const roles = ref<any[]>([])
const permisos = ref<any[]>([])
const permisosRoles = ref<any[]>([])
const permisosCambiados = ref<Set<string>>(new Set())
const isLoading = ref(false)
const isSavingPermisos = ref(false)
const API_BASE = `${API_URL}/api`

// ── SECCIÓN ACTIVA ───────────────────────────────────────────────────────────
const seccionActiva = ref<'usuarios' | 'permisos'>('usuarios')

// ── ESTADOS DE FILTROS ───────────────────────────────────────────────────────
const searchQuery = ref('')
const roleFilter = ref('')

// ── UTILIDAD PARA LIMPIAR TEXTOS ─────────────────────────────────────────────
const cleanText = (str: string) => {
  if (!str) return ''
  return str.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "")
}

// ── FETCH BASE ───────────────────────────────────────────────────────────────
const fetchConToken = async (endpoint: string, method = 'GET', body: any = null) => {
  try {
    const options: RequestInit = {
      method,
      headers: {
        'Content-Type': 'application/json',
        'auth-token': authStore.token || '' 
      }
    }
    if (body) options.body = JSON.stringify(body)

    const response = await fetch(`${API_BASE}${endpoint}`, options)
    // Manejo de respuestas vacías (ej. un DELETE sin body)
    const text = await response.text()
    return text ? JSON.parse(text) : { status: 'ok' }
  } catch (error) {
    console.error(`Error en ${endpoint}:`, error)
    return { status: 'error', mensaje: 'Error de conexión' }
  }
}

// ── CARGAS DE DATOS ──────────────────────────────────────────────────────────
const loadUsuarios = async () => {
  isLoading.value = true
  // Endpoint: Mostrar usuarios
  const res = await fetchConToken('/usuarios/todos-usuarios')
  usuarios.value = res.datos || res || [] 
  isLoading.value = false
}

const loadRoles = async () => {
  const res = await fetchConToken('/usuarios/rol/mostrar')
  roles.value = res.datos || res || []
}

const loadPermisos = async () => {
  const res = await fetchConToken('/usuarios/permisos/mostrar')
  permisos.value = res.datos || res || []
}

const loadPermisosRoles = async () => {
  const res = await fetchConToken('/usuarios/permisos/roles/mostrar')
  permisosRoles.value = res.datos || res || []
}

const getPermisosDelRol = (rolId: number) => {
  return permisosRoles.value.filter((pr: any) => pr.id_rol === rolId).map((pr: any) => pr.id_permiso)
}

const getUsuariosDelRol = (rolId: number) => {
  return usuarios.value.filter((u: any) => (u.id_rol || u.rol) === rolId)
}

const eliminarRol = async (rol: any) => {
  const usuariosConEsteRol = getUsuariosDelRol(rol.id_rol)
  
  if (usuariosConEsteRol.length > 0) {
    for (const user of usuariosConEsteRol) {
      await fetchConToken('/usuarios/cambiar-rol', 'PUT', {
        id_usuario: user.id_usuario || user.id,
        nuevo_rol: rolSinAsignar
      })
    }
  }
  
  const res = await fetchConToken(`/usuarios/rol/baja/${rol.id_rol}`, 'DELETE', null)
  if (res.status === 'ok' || res.status === 200) {
    showToast('Rol eliminado correctamente', 'success')
    loadRoles()
    loadPermisosRoles()
    loadUsuarios()
  } else {
    showToast(res.mensaje || 'No se pudo eliminar el rol', 'error')
  }
}

const togglePermiso = (rolId: number, permisoId: number) => {
  const key = `${rolId}-${permisoId}`
  if (permisosCambiados.value.has(key)) {
    permisosCambiados.value.delete(key)
  } else {
    permisosCambiados.value.add(key)
  }
}

const guardarPermisosCambiados = async () => {
  isSavingPermisos.value = true
  
  for (const key of permisosCambiados.value) {
    const partes = key.split('-').map(Number)
    const rolId = partes[0] ?? 0
    const permisoId = partes[1] ?? 0
    if (rolId === 0 || permisoId === 0) continue
    
    const permisosActuales = getPermisosDelRol(rolId)
    const tienePermiso = permisosActuales.includes(permisoId)
    
    if (tienePermiso) {
      await fetchConToken(`/usuarios/permisos/quitar?id_rol=${rolId}&id_permiso=${permisoId}`, 'DELETE', null)
    } else {
      await fetchConToken('/usuarios/permisos/asignar', 'POST', { id_rol: rolId, id_permiso: permisoId })
    }
  }
  
  permisosCambiados.value.clear()
  await loadPermisosRoles()
  isSavingPermisos.value = false
}

// ── ESTADOS Y LÓGICA DEL MODAL ───────────────────────────────────────────────
const showModal = ref(false)
const modalType = ref<'crear' | 'editar' | 'eliminar' | 'cambiar-rol' | 'crear-rol'>('crear')
const formData = ref<Record<string, any>>({})
const isSubmitting = ref(false)
let toastTimeout: ReturnType<typeof setTimeout> | null = null
const toast = ref<{ visible: boolean; message: string; type: 'success' | 'error' }>({ visible: false, message: '', type: 'success' })
const rolSinAsignar = 7

const showToast = (message: string, type: 'success' | 'error' = 'success') => {
  if (toastTimeout) clearTimeout(toastTimeout)
  toast.value = { visible: true, message, type }
  toastTimeout = setTimeout(() => {
    toast.value.visible = false
  }, 3000)
}

const openModal = (type: 'crear' | 'editar' | 'eliminar' | 'cambiar-rol' | 'crear-rol', user: any = null, rol: any = null) => {
  if (!puedeAdministrar.value && type !== 'cambiar-rol') return

  modalType.value = type
  if (type === 'crear') {
    formData.value = { usuario: '', contra: '', rol: '' }
  } else if (type === 'editar') {
    formData.value = { 
      usuario_actual: user.nombre_usuario || user.nombre || user.usuario, 
      contra_actual: '', 
      nuevo_nombre: user.nombre_usuario || user.nombre || user.usuario,
      nueva_contra: ''
    }
  } else if (type === 'eliminar') {
    formData.value = { 
      usuario: user.nombre_usuario || user.nombre || user.usuario, 
      contra: '' 
    }
  } else if (type === 'cambiar-rol') {
    formData.value = { 
      usuario_actual: user.nombre_usuario || user.nombre || user.usuario,
      id_usuario: user.id_usuario || user.id,
      nuevo_rol: user.id_rol || user.rol
    }
  } else if (type === 'crear-rol') {
    formData.value = { nombre_rol: '', descripcion: '' }
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  formData.value = {}
}

const handleSubmit = async () => {
  isSubmitting.value = true
  let endpoint = ''
  let method = 'POST'
  const payload = { ...formData.value }

  switch (modalType.value) {
    case 'crear':
      endpoint = '/usuarios/registro'
      break
    case 'editar':
      endpoint = '/usuarios/actualizar'
      method = 'PUT'
      if (!payload.nueva_contra) delete payload.nueva_contra
      if (payload.nuevo_nombre === payload.usuario_actual) delete payload.nuevo_nombre
      break
    case 'eliminar':
      endpoint = '/usuarios/eliminar'
      method = 'DELETE'
      break
    case 'cambiar-rol':
      endpoint = '/usuarios/cambiar-rol'
      method = 'PUT'
      break
    case 'crear-rol':
      endpoint = '/usuarios/rol/alta'
      break
  }

  const res = await fetchConToken(endpoint, method, payload)
  isSubmitting.value = false

  if (res.status === 'ok' || res.status === 200 || res.mensaje?.includes('correctamente')) {
    const msg = modalType.value === 'crear' ? 'Usuario creado correctamente'
      : modalType.value === 'editar' ? 'Usuario actualizado correctamente'
      : modalType.value === 'eliminar' ? 'Usuario eliminado correctamente'
      : modalType.value === 'cambiar-rol' ? 'Rol cambiado correctamente'
      : modalType.value === 'crear-rol' ? 'Rol creado correctamente'
      : 'Operación exitosa'
    showToast(msg, 'success')
    closeModal()
    if (modalType.value === 'crear-rol') {
      loadRoles()
    } else {
      loadUsuarios()
    }
  } else {
    showToast(res.mensaje || 'No se pudo procesar la solicitud', 'error')
  }
}

// ── FILTROS COMPUTADOS ───────────────────────────────────────────────────────
const term = computed(() => cleanText(searchQuery.value))

const filteredUsuarios = computed(() => {
  return usuarios.value.filter(u => {
    const nombre = u.nombre_usuario || u.nombre || u.usuario || ''
    const nombreRol = u.nombre_rol || ''
    const matchSearch = cleanText(nombre).includes(term.value)
    
    // Asumiendo que el id del rol viene en u.id_rol o u.rol
    const currentRolId = u.id_rol || u.rol
    const matchRole = roleFilter.value === '' ? true : currentRolId === Number(roleFilter.value)
    
    return matchSearch && matchRole
  })
})

onMounted(() => {
  loadUsuarios()
  loadRoles()
  loadPermisos()
  loadPermisosRoles()
})
</script>

<template>
  <div class="menu-container">
    <Transition name="toast">
      <div v-if="toast.visible" :class="['toast', toast.type]">
        {{ toast.message }}
      </div>
    </Transition>
    <header class="menu-header">
      <h1 class="page-title">Gestión de Usuarios y Roles</h1>
      <p class="page-subtitle">Administra usuarios, roles y permisos del sistema.</p>
    </header>

    <!-- Tabs -->
    <div class="tabs-container">
      <button 
        :class="['tab-btn', { active: seccionActiva === 'usuarios' }]" 
        @click="seccionActiva = 'usuarios'"
      >
        Usuarios
      </button>
      <button 
        :class="['tab-btn', { active: seccionActiva === 'permisos' }]" 
        @click="seccionActiva = 'permisos'"
        :disabled="!puedeAdministrar"
      >
        Permisos por Rol
      </button>
    </div>

    <div v-if="seccionActiva === 'usuarios'">
      <div v-if="!puedeAdministrar" class="alert-banner">
        <strong>Aviso:</strong> Tienes permisos de solo lectura. Únicamente quienes tengan permiso de administrar usuarios pueden crear, modificar o dar de baja usuarios.
      </div>

    <div class="toolbar">
      <div class="search-box">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input v-model="searchQuery" type="text" placeholder="Buscar usuario..." class="search-input" />
      </div>

      <div class="filters-group">
        <select v-model="roleFilter" class="filter-select">
          <option value="">Todos los Roles</option>
          <option v-for="rol in roles" :key="rol.id_rol" :value="rol.id_rol">
            {{ rol.nombre_rol }}
          </option>
        </select>
      </div>

      <div class="actions-group">
        <button v-if="puedeAdministrar" @click="openModal('crear')" class="btn-primary">
          + Nuevo Usuario
        </button>
      </div>
    </div>

    <main class="tab-content">
      <div v-if="isLoading" class="loading-state">Cargando usuarios...</div>

      <div v-else class="grid-container">
        <div v-if="filteredUsuarios.length === 0" class="empty-state">No se encontraron usuarios.</div>
        
        <div v-for="user in filteredUsuarios" :key="user.id_usuario || user.id" class="card">
          <div class="card-header">
            <div class="user-info">
              <div class="avatar-placeholder">
                {{ (user.nombre_usuario || user.nombre || user.usuario || '?').charAt(0).toUpperCase() }}
              </div>
              <h3 class="card-title">{{ user.nombre_usuario || user.nombre || user.usuario }}</h3>
            </div>
          </div>
          
          <div class="card-footer mt-auto">
            <div class="badges-container">
              <span class="badge role-badge">{{ user.nombre_rol || 'Rol: ' + (user.id_rol || user.rol) }}</span>
            </div>
            
            <div v-if="puedeAdministrar" class="actions-container">
              <button @click="openModal('cambiar-rol', user)" class="action-btn role-btn" title="Cambiar Rol">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><path d="M20 8v6M23 11h-6"></path></svg>
              </button>
              <button @click="openModal('editar', user)" class="action-btn edit-btn" title="Editar">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
              </button>
              <button @click="openModal('eliminar', user)" class="action-btn delete-btn" title="Dar de Baja">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>

    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h2 class="modal-title">
          {{ modalType === 'crear' ? 'Registrar Usuario' : modalType === 'editar' ? 'Modificar Usuario' : modalType === 'cambiar-rol' ? 'Cambiar Rol' : 'Confirmar Baja' }}
        </h2>
        
        <form @submit.prevent="handleSubmit" class="modal-form">
          
          <template v-if="modalType === 'crear'">
            <div class="form-group">
              <label>Nombre de Usuario:</label>
              <input v-model="formData.usuario" type="text" required class="form-input" />
            </div>
            <div class="form-group">
              <label>Contraseña:</label>
              <input v-model="formData.contra" type="password" required class="form-input" />
            </div>
            <div class="form-group">
              <label>Asignar Rol:</label>
              <select v-model="formData.rol" required class="form-select">
                <option disabled value="">Selecciona un rol...</option>
                <option v-for="rol in roles" :key="rol.id_rol" :value="rol.id_rol">{{ rol.nombre_rol }}</option>
              </select>
            </div>
          </template>

          <template v-if="modalType === 'editar'">
            <div class="alert-info">
              Para guardar los cambios, la API requiere la contraseña actual.
            </div>
            <div class="form-group">
              <label>Nuevo Nombre de Usuario (Opcional):</label>
              <input v-model="formData.nuevo_nombre" type="text" class="form-input" />
            </div>
            <div class="form-group">
              <label>Nueva Contraseña (Opcional):</label>
              <input v-model="formData.nueva_contra" type="password" placeholder="Dejar en blanco si no cambia" class="form-input" />
            </div>
            <hr style="border-top: 1px dashed var(--color-borde); width: 100%; margin: 8px 0;" />
            <div class="form-group">
              <label>Usuario Actual (Requerido):</label>
              <input v-model="formData.usuario_actual" type="text" readonly class="form-input disabled-input" />
            </div>
            <div class="form-group">
              <label>Contraseña Actual (Requerida):</label>
              <input v-model="formData.contra_actual" type="password" required class="form-input" />
            </div>
          </template>

          <template v-if="modalType === 'eliminar'">
            <div class="alert-danger">
              ¿Estás seguro que deseas dar de baja a este usuario? Esta acción requiere la contraseña de la cuenta.
            </div>
            <div class="form-group">
              <label>Usuario a eliminar:</label>
              <input v-model="formData.usuario" type="text" readonly class="form-input disabled-input" />
            </div>
            <div class="form-group">
              <label>Contraseña (Requerida por API):</label>
              <input v-model="formData.contra" type="password" required class="form-input" />
            </div>
          </template>

          <template v-if="modalType === 'cambiar-rol'">
            <div class="form-group">
              <label>Usuario:</label>
              <input v-model="formData.usuario_actual" type="text" readonly class="form-input disabled-input" />
            </div>
            <div class="form-group">
              <label>Nuevo Rol:</label>
              <select v-model="formData.nuevo_rol" required class="form-select">
                <option disabled value="">Selecciona un rol...</option>
                <option v-for="rol in roles" :key="rol.id_rol" :value="rol.id_rol">{{ rol.nombre_rol }}</option>
              </select>
            </div>
          </template>

          <template v-if="modalType === 'crear-rol'">
            <div class="form-group">
              <label>Nombre del Rol:</label>
              <input v-model="formData.nombre_rol" type="text" required class="form-input" placeholder="Ej: Gerente" />
            </div>
            <div class="form-group">
              <label>Descripción (opcional):</label>
              <textarea v-model="formData.descripcion" class="form-input" rows="2" placeholder="Descripción del rol..."></textarea>
            </div>
          </template>

          <div class="modal-actions">
            <button type="button" @click="closeModal" class="btn-cancel" :disabled="isSubmitting">Cancelar</button>
            <button type="submit" :class="modalType === 'eliminar' ? 'btn-danger' : 'btn-primary'" :disabled="isSubmitting">
              {{ isSubmitting ? 'Procesando...' : (modalType === 'eliminar' ? 'Dar de Baja' : 'Guardar') }}
            </button>
          </div>
        </form>
      </div>
    </div>
    </div>

    <!-- Sección Permisos por Rol -->
    <div v-if="seccionActiva === 'permisos' && puedeAdministrar" class="permisos-section">
      <div class="permisos-header">
        <div>
          <h2 class="section-title">Administración de Permisos por Rol</h2>
          <p class="section-subtitle">Configura qué permisos tiene cada rol del sistema.</p>
        </div>
        <div class="permisos-header-actions">
          <button @click="openModal('crear-rol')" class="btn-primary">
            + Crear Rol
          </button>
          <button 
            v-if="permisosCambiados.size > 0" 
            @click="guardarPermisosCambiados" 
            class="btn-primary"
            :disabled="isSavingPermisos"
          >
            {{ isSavingPermisos ? 'Guardando...' : 'Guardar Cambios' }}
          </button>
        </div>
      </div>

      <div class="permisos-table-container">
        <table class="permisos-table">
          <thead>
            <tr>
              <th>Rol</th>
              <th v-for="permiso in permisos" :key="permiso.id_permiso">{{ NOMBRE_PERMISOS[permiso.id_permiso] || permiso.nombre_permiso }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="rol in roles" :key="rol.id_rol">
              <td class="rol-cell">
                <div class="rol-cell-content">
                  {{ rol.nombre_rol }}
                  <button 
                    @click="eliminarRol(rol)" 
                    class="delete-rol-btn" 
                    title="Eliminar rol"
                  >
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M3 6h18M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/>
                    </svg>
                  </button>
                </div>
              </td>
              <td v-for="permiso in permisos" :key="permiso.id_permiso" class="permiso-cell">
                <input 
                  type="checkbox" 
                  :checked="getPermisosDelRol(rol.id_rol).includes(permiso.id_permiso)"
                  @change="togglePermiso(rol.id_rol, permiso.id_permiso)"
                  class="permiso-checkbox"
                  :class="{ 'pending-change': permisosCambiados.has(`${rol.id_rol}-${permiso.id_permiso}`) }"
                />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</template>

<style scoped>
/* ── ESTILOS REUTILIZADOS DE MENU.VUE Y TENANT-COLORS ── */
.menu-container { padding: var(--espacio-6, 24px); color: var(--tenant-texto, #111827); display: flex; flex-direction: column; gap: var(--espacio-6, 24px); min-height: 100%; }
.menu-header { display: flex; flex-direction: column; gap: var(--espacio-2, 8px); }
.page-title { font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); margin: 0; }
.page-subtitle { font-size: var(--font-size-base, 15px); color: var(--tenant-texto-muted, #6b7280); margin: 0; }

.alert-banner { background-color: rgba(37, 99, 235, 0.1); border-left: 4px solid var(--color-info, #2563eb); padding: var(--espacio-3, 12px) var(--espacio-4, 16px); color: var(--tenant-texto); border-radius: 4px; font-size: var(--font-size-sm, 13px); }
.alert-info { background-color: rgba(37, 99, 235, 0.1); color: var(--color-info, #2563eb); padding: 8px 12px; border-radius: 6px; font-size: var(--font-size-xs, 11px); }
.alert-danger { background-color: rgba(220, 38, 38, 0.1); color: var(--color-error, #dc2626); padding: 8px 12px; border-radius: 6px; font-size: var(--font-size-sm, 13px); }

.toolbar { display: flex; flex-wrap: wrap; gap: var(--espacio-4, 16px); align-items: center; justify-content: space-between; background: var(--color-superficie, #ffffff); padding: var(--espacio-3, 12px) var(--espacio-4, 16px); border-radius: 8px; border: 1px solid var(--color-borde, #e5e7eb); }
.search-box { display: flex; align-items: center; gap: var(--espacio-2, 8px); background: var(--color-superficie-alt, #f3f4f6); padding: var(--espacio-2, 8px) var(--espacio-3, 12px); border-radius: 6px; flex: 1; min-width: 250px; max-width: 400px; border: 1px solid transparent; transition: border-color 0.2s; }
.search-box:focus-within { border-color: var(--tenant-primario, #002D72); background: var(--color-superficie, #ffffff); }
.search-icon { width: 18px; height: 18px; color: var(--tenant-texto-muted, #6b7280); }
.search-input { border: none; background: transparent; outline: none; width: 100%; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto, #111827); font-family: inherit; }

.filters-group { display: flex; gap: var(--espacio-3, 12px); flex-wrap: wrap; }
.filter-select { padding: var(--espacio-2, 8px) var(--espacio-3, 12px); font-size: var(--font-size-sm, 13px); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; background-color: var(--color-superficie, #ffffff); color: var(--tenant-texto, #111827); outline: none; cursor: pointer; }

.btn-primary { background-color: var(--tenant-primario, #002D72); color: white; padding: 8px 16px; border-radius: 6px; border: none; font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: opacity 0.2s; white-space: nowrap; }
.btn-primary:hover { opacity: 0.9; }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-danger { background-color: var(--color-cancelar, #ef4444); color: white; padding: 8px 16px; border-radius: 6px; border: none; font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: opacity 0.2s; white-space: nowrap; }
.btn-danger:hover { opacity: 0.9; }

.btn-cancel { background-color: transparent; color: var(--tenant-texto-muted, #6b7280); padding: 8px 16px; border-radius: 6px; border: 1px solid var(--color-borde, #e5e7eb); font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: background 0.2s; }
.btn-cancel:hover { background-color: var(--color-superficie-alt, #f3f4f6); }

.tab-content { flex: 1; }
.grid-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: var(--espacio-4, 16px); }
.card { background-color: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; padding: var(--espacio-4, 16px); display: flex; flex-direction: column; gap: var(--espacio-3, 12px); transition: box-shadow 0.2s, border-color 0.2s; }
.card:hover { border-color: var(--tenant-primario, #002D72); box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }

.card-header { display: flex; justify-content: space-between; align-items: center; gap: var(--espacio-2, 8px); }
.user-info { display: flex; align-items: center; gap: var(--espacio-3, 12px); }
.avatar-placeholder { width: 40px; height: 40px; border-radius: 50%; background-color: var(--tenant-secundario, #5C2D6D); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: var(--font-size-lg, 20px); }
.card-title { font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); margin: 0; }

.mt-auto { margin-top: auto; }
.card-footer { display: flex; justify-content: space-between; align-items: center; padding-top: var(--espacio-3, 12px); border-top: 1px dashed var(--color-borde, #e5e7eb); }
.badges-container { display: flex; flex-wrap: wrap; gap: var(--espacio-2, 8px); flex: 1; align-items: center; }
.badge { font-size: var(--font-size-xs, 11px); padding: 4px 8px; border-radius: 4px; font-weight: var(--font-weight-medium, 500); }
.role-badge { background-color: rgba(92, 45, 109, 0.1); color: var(--tenant-secundario, #5C2D6D); border: 1px solid rgba(92, 45, 109, 0.2); }

.actions-container { display: flex; gap: var(--espacio-2, 8px); }
.action-btn { background: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: var(--tenant-texto-muted, #6b7280); }
.action-btn svg { width: 16px; height: 16px; }
.edit-btn:hover { background-color: rgba(37, 99, 235, 0.1); border-color: var(--color-info, #2563eb); color: var(--color-info, #2563eb); }
.delete-btn:hover { background-color: rgba(220, 38, 38, 0.1); border-color: var(--color-cancelar, #ef4444); color: var(--color-cancelar, #ef4444); }

.loading-state, .empty-state { text-align: center; padding: var(--espacio-8, 32px); color: var(--tenant-texto-muted, #6b7280); background-color: var(--color-superficie, #ffffff); border: 1px dashed var(--color-borde, #e5e7eb); border-radius: 8px; }

/* ── MODAL ── */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; padding: var(--espacio-4, 16px); }
.modal-content { background: var(--color-superficie, #ffffff); padding: var(--espacio-6, 24px); border-radius: 12px; width: 100%; max-width: 400px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); max-height: 90vh; overflow-y: auto; }
.modal-title { margin: 0 0 var(--espacio-4, 16px) 0; font-size: var(--font-size-lg, 20px); font-weight: 600; color: var(--tenant-texto, #111827); border-bottom: 1px solid var(--color-borde, #e5e7eb); padding-bottom: var(--espacio-3, 12px); }
.modal-form { display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }
.form-group { display: flex; flex-direction: column; gap: 4px; flex: 1; }
.form-group label { font-size: var(--font-size-sm, 13px); font-weight: 500; color: var(--tenant-texto, #111827); }
.form-input, .form-select { width: 100%; padding: 8px 12px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; font-size: var(--font-size-sm, 13px); outline: none; transition: border-color 0.2s; font-family: inherit; }
.form-input:focus, .form-select:focus { border-color: var(--tenant-primario, #002D72); }
.disabled-input { background-color: var(--color-superficie-alt, #f3f4f6); color: var(--tenant-texto-muted, #6b7280); cursor: not-allowed; }
.modal-actions { display: flex; justify-content: flex-end; gap: var(--espacio-3, 12px); margin-top: var(--espacio-2, 8px); padding-top: var(--espacio-4, 16px); border-top: 1px solid var(--color-borde, #e5e7eb); }

/* ── TABS ── */
.tabs-container { display: flex; gap: var(--espacio-2, 8px); border-bottom: 1px solid var(--color-borde, #e5e7eb); padding-bottom: var(--espacio-2, 8px); }
.tab-btn { background: transparent; border: none; padding: var(--espacio-2, 8px) var(--espacio-4, 16px); font-size: var(--font-size-sm, 13px); font-weight: 500; color: var(--tenant-texto-muted, #6b7280); cursor: pointer; border-radius: 6px; transition: all 0.2s; }
.tab-btn:hover { background: var(--color-superficie-alt, #f3f4f6); color: var(--tenant-texto, #111827); }
.tab-btn.active { background: var(--tenant-primario, #002D72); color: white; }
.tab-btn:disabled { opacity: 0.5; cursor: not-allowed; }

/* ── BOTÓN CAMBIAR ROL ── */
.role-btn:hover { background-color: rgba(92, 45, 109, 0.1); border-color: var(--tenant-secundario, #5C2D6D); color: var(--tenant-secundario, #5C2D6D); }

/* ── PERMISOS ── */
.permisos-section { margin-top: var(--espacio-4, 16px); }
.permisos-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: var(--espacio-4, 16px); flex-wrap: wrap; gap: var(--espacio-3, 12px); }
.permisos-header-actions { display: flex; gap: var(--espacio-2, 8px); flex-wrap: wrap; }
.section-title { font-size: var(--font-size-lg, 20px); font-weight: 600; margin: 0 0 var(--espacio-2, 8px) 0; color: var(--tenant-texto, #111827); }
.section-subtitle { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); margin: 0; }
.permisos-table-container { overflow-x: auto; background: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; }
.permisos-table { width: 100%; border-collapse: collapse; font-size: var(--font-size-sm, 13px); }
.permisos-table th, .permisos-table td { padding: var(--espacio-3, 12px); text-align: left; border-bottom: 1px solid var(--color-borde, #e5e7eb); }
.permisos-table th { background: var(--color-superficie-alt, #f3f4f6); font-weight: 600; color: var(--tenant-texto, #111827); }
.permisos-table tr:last-child td { border-bottom: none; }
.rol-cell { font-weight: 500; color: var(--tenant-texto, #111827); }
.rol-cell-content { display: flex; align-items: center; gap: var(--espacio-2, 8px); }
.delete-rol-btn { background: none; border: none; cursor: pointer; color: var(--color-cancelar, #ef4444); padding: 4px; display: flex; align-items: center; justify-content: center; border-radius: 4px; transition: background 0.15s; }
.delete-rol-btn:hover { background: rgba(220, 38, 38, 0.1); }
.delete-rol-btn svg { width: 16px; height: 16px; }
.permiso-cell { text-align: center; }
.permiso-checkbox { width: 18px; height: 18px; cursor: pointer; accent-color: var(--tenant-primario, #002D72); }
.permiso-checkbox.pending-change { box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3); }

/* ── TOAST ── */
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 12px 20px;
  border-radius: 8px;
  font-size: var(--font-size-sm, 13px);
  font-weight: 500;
  z-index: 9999;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  color: #fff;
  pointer-events: none;
}
.toast.success { background: #22c55e; }
.toast.error { background: #ef4444; }
.toast-enter-active { transition: all 0.3s ease; }
.toast-leave-active { transition: all 0.3s ease; }
.toast-enter-from { opacity: 0; transform: translateX(40px); }
.toast-leave-to { opacity: 0; transform: translateX(40px); }
</style>