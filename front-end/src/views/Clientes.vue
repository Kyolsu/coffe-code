<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()

// ── VERIFICACIÓN DE PERMISOS (Admin = 1, Caja = 2) ───────────────────────────
const canEdit = computed(() => {
  const rol = authStore.rol
  const rolStr = String(rol).toLowerCase()
  const rolNum = Number(rol)
  return rolNum === 1 || rolNum === 2 || rolStr === 'admin' || rolStr === 'caja'
})

// ── ESTADOS GLOBALES ─────────────────────────────────────────────────────────
const clientes = ref<any[]>([])
const isLoading = ref(false)
const API_BASE = 'http://localhost:3000/api'

// ── ESTADOS DE FILTROS ───────────────────────────────────────────────────────
const searchQuery = ref('')
const statusFilter = ref('activos')

// ── ESTADOS PARA PROMOCIONES ─────────────────────────────────────────────────
const promocionesCatalogo = ref<any[]>([]) // Todas las promos existentes
const promocionesActualesCliente = ref<any[]>([]) // Promos que ya tiene el cliente
const idPromocionParaVincular = ref('') // Selección del dropdown
const isLoadingPromos = ref(false)

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
    const data = await response.json()
    return data
  } catch (error) {
    console.error(`Error en ${endpoint}:`, error)
    return { status: 'error', mensaje: 'Error de conexión' }
  }
}

// ── CARGAS DE DATOS (CLIENTES) ───────────────────────────────────────────────
const loadClientes = async () => {
  isLoading.value = true
  const [activosRes, inactivosRes] = await Promise.all([
    fetchConToken('/clientes/mostrar-activos'),
    fetchConToken('/clientes/mostrar-inactivos')
  ])
  
  const clientesActivos = (activosRes.datos || []).map((c: any) => ({ ...c, _activo: true }))
  const clientesInactivos = (inactivosRes.datos || []).map((c: any) => ({ ...c, _activo: false }))
  
  clientes.value = [...clientesActivos, ...clientesInactivos]
  isLoading.value = false
}

// ── MÉTODOS DE PROMOCIONES ───────────────────────────────────────────────────
const loadPromocionesCatalogo = async () => {
  const res = await fetchConToken('/promociones/mostrar')
  if (res.status === 'ok') {
    promocionesCatalogo.value = res.datos || []
  }
}

const loadPromocionesDelCliente = async (id_cliente: number) => {
  isLoadingPromos.value = true
  const res = await fetchConToken('/promociones/clientes/mostrar')
  if (res.status === 'ok') {
    // Filtramos para obtener solo las promos del cliente actual que estén activas
    promocionesActualesCliente.value = (res.datos || []).filter(
      (p: any) => p.id_cliente === id_cliente && p.promocion_activa === true
    )
  }
  isLoadingPromos.value = false
}

const handleVincularPromocion = async () => {
  if (!idPromocionParaVincular.value || !formData.value.id_cliente) return

  const payload = {
    id_cliente: formData.value.id_cliente,
    id_promocion: Number(idPromocionParaVincular.value)
  }

  const res = await fetchConToken('/promociones/clientes/vincular', 'POST', payload)
  
  if (res.status === 'ok' || res.status === 201) {
    idPromocionParaVincular.value = ''
    await loadPromocionesDelCliente(formData.value.id_cliente)
  } else {
    alert(res.mensaje || 'La promoción ya está vinculada o no se pudo asignar.')
  }
}

const handleDesvincularPromocion = async (id_promocion: number) => {
  if (!confirm('¿Quitar esta promoción al cliente?')) return

  const payload = {
    id_cliente: formData.value.id_cliente,
    id_promocion: id_promocion
  }

  const res = await fetchConToken('/promociones/clientes/desvincular', 'DELETE', payload)
  
  if (res.status === 'ok') {
    await loadPromocionesDelCliente(formData.value.id_cliente)
  } else {
    alert('No se pudo desvincular la promoción.')
  }
}

// ── ESTADOS Y LÓGICA DEL MODAL ───────────────────────────────────────────────
const showModal = ref(false)
const modalType = ref<'crear' | 'editar'>('crear')
const formData = ref<Record<string, any>>({})
const isSubmitting = ref(false)

const openModal = async (type: 'crear' | 'editar', cliente: any = null) => {
  if (!canEdit.value) return 

  modalType.value = type
  if (type === 'crear') {
    formData.value = { nombre: '', email: '', telefono: '' }
    promocionesActualesCliente.value = []
  } else if (type === 'editar') {
    formData.value = { 
      id_cliente: cliente.id_cliente,
      nombre: cliente.nombre, 
      email: cliente.email || '', 
      telefono: cliente.telefono || '',
      activo: cliente.activo ?? cliente._activo 
    }
    // Cargamos catálogos y las promos que ya tiene este cliente
    await loadPromocionesCatalogo()
    await loadPromocionesDelCliente(cliente.id_cliente)
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  formData.value = {}
  promocionesActualesCliente.value = []
  idPromocionParaVincular.value = ''
}

const handleSubmit = async () => {
  isSubmitting.value = true
  let endpoint = ''
  let method = ''
  let payload = { ...formData.value }

  if (modalType.value === 'crear') {
    endpoint = '/clientes/registro'
    method = 'POST'
  } else if (modalType.value === 'editar') {
    endpoint = `/clientes/modificar/${payload.id_cliente}`
    method = 'PUT'
    delete payload.id_cliente 
  }

  const res = await fetchConToken(endpoint, method, payload)
  isSubmitting.value = false

  if (res.status === 'ok' || res.status === 201 || res.status === 200) {
    closeModal()
    loadClientes()
  } else {
    alert(`Error: ${res.mensaje || 'No se pudo procesar la solicitud'}`)
  }
}

// ── FILTROS COMPUTADOS ───────────────────────────────────────────────────────
const term = computed(() => cleanText(searchQuery.value))

const filteredClientes = computed(() => {
  return clientes.value.filter(c => {
    const matchSearch = cleanText(c.nombre).includes(term.value) || 
                        cleanText(c.email).includes(term.value) || 
                        cleanText(c.telefono).includes(term.value)
    
    const matchStatus = statusFilter.value === 'todos' ? true : 
                       (statusFilter.value === 'activos' ? c._activo : !c._activo)
    
    return matchSearch && matchStatus
  })
})

onMounted(() => {
  loadClientes()
})
</script>

<template>
  <div class="menu-container">
    <header class="menu-header">
      <h1 class="page-title">Clientes</h1>
      <p class="page-subtitle">Gestiona la información y estatus de tus clientes registrados.</p>
    </header>

    <div v-if="!canEdit" class="alert-banner">
      <strong>Aviso:</strong> Tienes permisos de solo lectura. Únicamente Admin y Caja pueden agregar o modificar clientes.
    </div>

    <div class="toolbar">
      <div class="search-box">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input v-model="searchQuery" type="text" placeholder="Buscar por nombre, email o tel..." class="search-input" />
      </div>

      <div class="filters-group">
        <select v-model="statusFilter" class="filter-select">
          <option value="activos">Clientes Activos</option>
          <option value="inactivos">Clientes de Baja</option>
          <option value="todos">Mostrar Todos</option>
        </select>
      </div>

      <div class="actions-group">
        <button v-if="canEdit" @click="openModal('crear')" class="btn-primary">
          + Nuevo Cliente
        </button>
      </div>
    </div>

    <main class="tab-content">
      <div v-if="isLoading" class="loading-state">Cargando directorio de clientes...</div>

      <div v-else class="grid-container">
        <div v-if="filteredClientes.length === 0" class="empty-state">No se encontraron clientes con esos filtros.</div>
        
        <div v-for="cliente in filteredClientes" :key="cliente.id_cliente" :class="['card', { 'inactive-card': !cliente._activo }]">
          <div class="card-header">
            <div class="client-info">
              <div class="avatar-placeholder">
                {{ (cliente.nombre || '?').charAt(0).toUpperCase() }}
              </div>
              <div class="client-name-container">
                <h3 class="card-title">{{ cliente.nombre }}</h3>
              </div>
            </div>
          </div>
          
          <div class="card-body">
            <div class="contact-row">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
              <span>{{ cliente.telefono || 'Sin teléfono' }}</span>
            </div>
            <div class="contact-row">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
              <span class="truncate-text" :title="cliente.email">{{ cliente.email || 'Sin correo' }}</span>
            </div>
          </div>
          
          <div class="card-footer mt-auto">
            <div class="badges-container">
              <span v-if="cliente._activo" class="badge success">Activo</span>
              <span v-else class="badge danger">Dado de baja</span>
            </div>
            
            <div v-if="canEdit" class="actions-container">
              <button @click="openModal('editar', cliente)" class="action-btn edit-btn" title="Modificar Cliente">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>

    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h2 class="modal-title">
          {{ modalType === 'crear' ? 'Registrar Nuevo Cliente' : 'Modificar Cliente' }}
        </h2>
        
        <form @submit.prevent="handleSubmit" class="modal-form">
          
          <div class="form-group">
            <label>Nombre del Cliente (Requerido):</label>
            <input v-model="formData.nombre" type="text" required class="form-input" placeholder="Ej. Roberto Calderón" />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Teléfono (Opcional):</label>
              <input v-model="formData.telefono" type="text" class="form-input" placeholder="Ej. 442-123-4567" />
            </div>
            <div class="form-group">
              <label>Correo (Opcional):</label>
              <input v-model="formData.email" type="email" class="form-input" placeholder="correo@ejemplo.com" />
            </div>
          </div>

          <template v-if="modalType === 'editar'">
            
            <div class="promociones-section">
              <label class="section-subtitle">Promociones Vinculadas</label>
              
              <div class="promos-list" v-if="promocionesActualesCliente.length > 0">
                <div v-for="promo in promocionesActualesCliente" :key="promo.id_promocion" class="promo-tag">
                  <span>{{ promo.nombre_promocion }}</span>
                  <button type="button" @click="handleDesvincularPromocion(promo.id_promocion)" class="remove-promo-btn" title="Quitar promoción">
                    &times;
                  </button>
                </div>
              </div>
              <p v-else-if="!isLoadingPromos" class="empty-promos-text">El cliente no tiene promociones asignadas actualmente.</p>
              <p v-else class="empty-promos-text">Cargando promociones...</p>

              <div class="add-promo-row">
                <select v-model="idPromocionParaVincular" class="form-select-small">
                  <option value="" disabled>Selecciona una promoción para agregar...</option>
                  <option v-for="p in promocionesCatalogo" :key="p.id_promocion" :value="p.id_promocion">
                    {{ p.nombre_promocion }}
                  </option>
                </select>
                <button type="button" @click="handleVincularPromocion" class="btn-add-inline" :disabled="!idPromocionParaVincular">
                  Asignar
                </button>
              </div>
            </div>

            <hr style="border-top: 1px dashed var(--color-borde); width: 100%; margin: 16px 0;" />
            
            <div class="switch-container">
              <label class="switch-label">
                <div>
                  <span style="display: block; font-weight: 500;">Estatus del Cliente</span>
                  <span style="font-size: var(--font-size-xs); color: var(--tenant-texto-muted);">Los clientes dados de baja no acumulan beneficios ni promociones.</span>
                </div>
              </label>
              <label class="toggle-switch">
                <input type="checkbox" v-model="formData.activo">
                <span class="slider round"></span>
              </label>
            </div>
          </template>

          <div class="modal-actions">
            <button type="button" @click="closeModal" class="btn-cancel" :disabled="isSubmitting">Cerrar</button>
            <button type="submit" class="btn-primary" :disabled="isSubmitting">
              {{ isSubmitting ? 'Guardando...' : 'Guardar Información' }}
            </button>
          </div>
        </form>
      </div>
    </div>

  </div>
</template>

<style scoped>
/* ── ESTILOS REUTILIZADOS Y ESPECÍFICOS DE CLIENTES ── */
.menu-container { padding: var(--espacio-6, 24px); color: var(--tenant-texto, #111827); display: flex; flex-direction: column; gap: var(--espacio-6, 24px); min-height: 100%; }
.menu-header { display: flex; flex-direction: column; gap: var(--espacio-2, 8px); }
.page-title { font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); margin: 0; }
.page-subtitle { font-size: var(--font-size-base, 15px); color: var(--tenant-texto-muted, #6b7280); margin: 0; }

.alert-banner { background-color: rgba(37, 99, 235, 0.1); border-left: 4px solid var(--color-info, #2563eb); padding: var(--espacio-3, 12px) var(--espacio-4, 16px); color: var(--tenant-texto); border-radius: 4px; font-size: var(--font-size-sm, 13px); }

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

.btn-cancel { background-color: transparent; color: var(--tenant-texto-muted, #6b7280); padding: 8px 16px; border-radius: 6px; border: 1px solid var(--color-borde, #e5e7eb); font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: background 0.2s; }
.btn-cancel:hover { background-color: var(--color-superficie-alt, #f3f4f6); }

/* ── GRID Y TARJETAS ── */
.tab-content { flex: 1; }
.grid-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: var(--espacio-4, 16px); }
.card { background-color: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; padding: var(--espacio-4, 16px); display: flex; flex-direction: column; gap: var(--espacio-3, 12px); transition: box-shadow 0.2s, border-color 0.2s; }
.inactive-card { opacity: 0.65; background-color: var(--color-superficie-alt, #f3f4f6); }
.card:hover { border-color: var(--tenant-primario, #002D72); box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }

.card-header { display: flex; justify-content: space-between; align-items: flex-start; gap: var(--espacio-2, 8px); }
.client-info { display: flex; align-items: center; gap: var(--espacio-3, 12px); width: 100%; }
.avatar-placeholder { flex-shrink: 0; width: 42px; height: 42px; border-radius: 8px; background-color: var(--tenant-secundario, #5C2D6D); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: var(--font-size-lg, 20px); }

.client-name-container { overflow: hidden; width: 100%; }
.card-title { font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); margin: 0; line-height: 1.2; word-break: break-word; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

.card-body { display: flex; flex-direction: column; gap: 8px; margin-top: 4px; }
.contact-row { display: flex; align-items: center; gap: 8px; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); }
.contact-row svg { width: 14px; height: 14px; flex-shrink: 0; }
.truncate-text { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

.mt-auto { margin-top: auto; }
.card-footer { display: flex; justify-content: space-between; align-items: center; padding-top: var(--espacio-3, 12px); border-top: 1px dashed var(--color-borde, #e5e7eb); }
.badges-container { display: flex; flex-wrap: wrap; gap: var(--espacio-2, 8px); flex: 1; align-items: center; }
.badge { font-size: var(--font-size-xs, 11px); padding: 4px 8px; border-radius: 4px; font-weight: var(--font-weight-medium, 500); }
.badge.success { background-color: rgba(22, 163, 74, 0.1); color: var(--color-exitoso, #16a34a); border: 1px solid rgba(22, 163, 74, 0.2); }
.badge.danger { background-color: rgba(220, 38, 38, 0.1); color: var(--color-cancelar, #ef4444); border: 1px solid rgba(220, 38, 38, 0.2); }

.actions-container { display: flex; gap: var(--espacio-2, 8px); }
.action-btn { background: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: var(--tenant-texto-muted, #6b7280); }
.action-btn svg { width: 16px; height: 16px; }
.edit-btn:hover { background-color: rgba(37, 99, 235, 0.1); border-color: var(--color-info, #2563eb); color: var(--color-info, #2563eb); }

.loading-state, .empty-state { text-align: center; padding: var(--espacio-8, 32px); color: var(--tenant-texto-muted, #6b7280); background-color: var(--color-superficie, #ffffff); border: 1px dashed var(--color-borde, #e5e7eb); border-radius: 8px; }

/* ── MODAL ── */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; padding: var(--espacio-4, 16px); }
.modal-content { background: var(--color-superficie, #ffffff); padding: var(--espacio-6, 24px); border-radius: 12px; width: 100%; max-width: 480px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); max-height: 90vh; overflow-y: auto; }
.modal-title { margin: 0 0 var(--espacio-4, 16px) 0; font-size: var(--font-size-lg, 20px); font-weight: 600; color: var(--tenant-texto, #111827); border-bottom: 1px solid var(--color-borde, #e5e7eb); padding-bottom: var(--espacio-3, 12px); }
.modal-form { display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }
.form-group { display: flex; flex-direction: column; gap: 4px; flex: 1; }
.form-row { display: flex; gap: var(--espacio-4, 16px); }
.form-group label { font-size: var(--font-size-sm, 13px); font-weight: 500; color: var(--tenant-texto, #111827); }
.form-input { width: 100%; padding: 8px 12px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; font-size: var(--font-size-sm, 13px); outline: none; transition: border-color 0.2s; font-family: inherit; }
.form-input:focus { border-color: var(--tenant-primario, #002D72); }

/* ── TOGGLE SWITCH CSS ── */
.switch-container { display: flex; justify-content: space-between; align-items: center; padding: 4px 0; }
.switch-label { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto, #111827); }
.toggle-switch { position: relative; display: inline-block; width: 44px; height: 24px; flex-shrink: 0; }
.toggle-switch input { opacity: 0; width: 0; height: 0; }
.slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: var(--color-borde, #e5e7eb); transition: .3s; }
.slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .3s; }
input:checked + .slider { background-color: var(--color-exitoso, #16a34a); }
input:focus + .slider { box-shadow: 0 0 1px var(--color-exitoso, #16a34a); }
input:checked + .slider:before { transform: translateX(20px); }
.slider.round { border-radius: 24px; }
.slider.round:before { border-radius: 50%; }

/* ── ESTILOS DE PROMOCIONES EN MODAL ── */
.promociones-section { margin-top: 4px; padding-top: 16px; border-top: 1px solid var(--color-borde); }
.section-subtitle { display: block; font-size: var(--font-size-sm, 13px); font-weight: 600; color: var(--tenant-texto, #111827); margin-bottom: 12px; }
.promos-list { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px; }
.promo-tag { display: flex; align-items: center; gap: 6px; background-color: rgba(37, 99, 235, 0.1); color: var(--color-info, #2563eb); border: 1px solid rgba(37, 99, 235, 0.2); padding: 4px 10px; border-radius: 16px; font-size: var(--font-size-xs, 11px); font-weight: 500; }
.remove-promo-btn { background: none; border: none; color: var(--color-info, #2563eb); font-size: 16px; cursor: pointer; line-height: 1; padding: 0; transition: color 0.2s; }
.remove-promo-btn:hover { color: var(--color-cancelar, #ef4444); }
.empty-promos-text { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted); margin-bottom: 16px; font-style: italic; }
.add-promo-row { display: flex; gap: 8px; }
.form-select-small { flex: 1; padding: 8px 10px; border: 1px solid var(--color-borde); border-radius: 6px; font-size: var(--font-size-sm, 13px); outline: none; font-family: inherit; color: var(--tenant-texto); }
.btn-add-inline { background-color: var(--tenant-secundario, #5C2D6D); color: white; border: none; padding: 8px 16px; border-radius: 6px; font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: opacity 0.2s; }
.btn-add-inline:disabled { opacity: 0.5; cursor: not-allowed; }

.modal-actions { display: flex; justify-content: flex-end; gap: var(--espacio-3, 12px); margin-top: var(--espacio-2, 8px); padding-top: var(--espacio-4, 16px); border-top: 1px solid var(--color-borde, #e5e7eb); }
</style>