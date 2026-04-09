<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()

// ── PERMISOS ─────────────────────────────────────────────────────────────────
const canManage = computed(() => {
  const rol = String(authStore.rol)
  return rol === 'admin' || rol === 'gerente' || rol === '1' || rol === '2'
})

// ── ESTADOS GLOBALES Y PESTAÑAS ──────────────────────────────────────────────
const tabs = [
  { id: 'productos', label: 'Productos' },
  { id: 'ingredientes', label: 'Ingredientes' },
  { id: 'menus_zonas', label: 'Menús y Zonas' },
  { id: 'paquetes', label: 'Paquetes y Promos' }
]
const activeTab = ref('productos')

const productos = ref<any[]>([])
const ingredientes = ref<any[]>([])
const menus = ref<any[]>([])
const zonas = ref<any[]>([])
const paquetes = ref<any[]>([])
const categorias = ref<any[]>([]) 

const isLoading = ref(false)
const API_BASE = 'http://localhost:3000/api'

const cleanText = (str: string) => {
  if (!str) return ''
  return str.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "")
}

const searchQuery = ref('')
const statusFilter = ref('activos')
const catFilter = ref('')
const zonaFilter = ref('')
const tipoPaqueteFilter = ref('todos')

const categoriasUnicas = computed(() => [...new Set(productos.value.map(p => p.categoria).filter(Boolean))])
const zonasUnicas = computed(() => [...new Set(productos.value.map(p => p.zona).filter(Boolean))])

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

// ── CARGAS DE DATOS ──────────────────────────────────────────────────────────
const loadProductos = async () => {
  isLoading.value = true
  const [activos, inactivos] = await Promise.all([
    fetchConToken('/productos/mostrar'),
    fetchConToken('/productos/mostrar-inactivo')
  ])
  productos.value = [
    ...(activos.datos || []).map((p: any) => ({ ...p, _activo: true })),
    ...(inactivos.datos || []).map((p: any) => ({ ...p, _activo: false }))
  ]
  isLoading.value = false
}

const loadIngredientes = async () => {
  isLoading.value = true
  const res = await fetchConToken('/productos/ingredientes/mostrar')
  // Normalizamos el estado de los ingredientes a nuestra bandera _activo para facilitar los filtros
  ingredientes.value = (res.datos || []).map((i: any) => {
    const estadoLimpio = cleanText(i.estado)
    const isActivo = estadoLimpio === 'disponible' || estadoLimpio === 'activo' || i.activo === true
    return { ...i, _activo: isActivo }
  })
  isLoading.value = false
}

const loadMenusYZonas = async () => {
  isLoading.value = true
  const [menusActivos, menusInactivos, zonasActivas, zonasInactivas] = await Promise.all([
    fetchConToken('/menu/mostrar-activo'),
    fetchConToken('/menu/mostrar-inactivo'),
    fetchConToken('/tienda/zonas/mostrar'),
    fetchConToken('/tienda/zonas/mostrar-inactivas')
  ])
  menus.value = [
    ...(menusActivos.datos || []).map((m: any) => ({ ...m, _activo: true })),
    ...(menusInactivos.datos || []).map((m: any) => ({ ...m, _activo: false }))
  ]
  zonas.value = [
    ...(zonasActivas.datos || []).map((z: any) => ({ ...z, _activo: true })),
    ...(zonasInactivas.datos || []).map((z: any) => ({ ...z, _activo: false }))
  ]
  isLoading.value = false
}

const loadPaquetes = async () => {
  isLoading.value = true
  // Nota: Si el backend agrega el endpoint /mostrar-inactivos para paquetes, se carga aquí en paralelo.
  const res = await fetchConToken('/paquetes/vista-comprimida')
  paquetes.value = (res.datos || []).map((p: any) => ({ ...p, _activo: p.activo !== false })) 
  isLoading.value = false
}

const loadCategorias = async () => {
  const res = await fetchConToken('/tienda/categorias/mostrar')
  categorias.value = res.datos || []
}

const setTab = (tabId: string) => {
  activeTab.value = tabId
  searchQuery.value = ''
  if (tabId === 'productos' && productos.value.length === 0) loadProductos()
  if (tabId === 'ingredientes' && ingredientes.value.length === 0) loadIngredientes()
  if (tabId === 'menus_zonas' && menus.value.length === 0) loadMenusYZonas()
  if (tabId === 'paquetes' && paquetes.value.length === 0) loadPaquetes()
}

// ── LÓGICA DEL MODAL Y CRUD (CREAR/EDITAR) ───────────────────────────────────
const showModal = ref(false)
const modalType = ref('')
const formData = ref<Record<string, any>>({})
const isSubmitting = ref(false)
const isEditing = ref(false)
const editingId = ref<string | number | null>(null)

const openAddModal = async (type: string) => {
  modalType.value = type
  isEditing.value = false
  editingId.value = null
  formData.value = {} 
  
  if (type === 'producto') {
    if (zonas.value.length === 0) await loadMenusYZonas()
    if (categorias.value.length === 0) await loadCategorias()
  }
  showModal.value = true
}

const handleEdit = async (type: string, item: any) => {
  modalType.value = type
  isEditing.value = true
  formData.value = {} 

  // Función interna para limpiar textos y asegurar el match
  const cleanStr = (s: string) => (s || '').toString().toLowerCase().trim()

  if (type === 'producto') {
    if (zonas.value.length === 0) await loadMenusYZonas()
    if (categorias.value.length === 0) await loadCategorias()
    
    editingId.value = item.id_producto
    formData.value.nombre = item.nombre_producto
    formData.value.precio = item.precio_base
    formData.value.descripcion = item.descripcion || ''
    formData.value.url_imagen = item.url_imagen || ''
    
    // Búsqueda segura
    const catEncontrada = categorias.value.find(c => cleanStr(c.nombre_cat || c.nombre) === cleanStr(item.categoria))
    if (catEncontrada) formData.value.id_categoria = catEncontrada.id_categoria || catEncontrada.id
    
    const zonaEncontrada = zonas.value.find(z => cleanStr(z.nombre_zona || z.nombre) === cleanStr(item.zona))
    if (zonaEncontrada) formData.value.id_zona = zonaEncontrada.id_zona || zonaEncontrada.id
  }
  else if (type === 'ingrediente') {
    editingId.value = item.id
    formData.value.nombre = item.ingrediente
    formData.value.precio = item.precio
  }
  else if (type === 'zona') {
    editingId.value = item.id_zona
    formData.value.nombre = item.nombre_zona
    formData.value.descripcion = item.descripcion_zona
  }
  else if (type === 'menu') {
    editingId.value = item.id_menu
    formData.value.nombre = item.nombre_menu
    formData.value.descripcion = item.descripcion
    formData.value.hora_inicio = item.hora_inicio
    formData.value.hora_fin = item.hora_fin
    formData.value.dias_semana = item.dias_semana
    formData.value.fecha_inicio = item.fecha_inicio ? item.fecha_inicio.split('T')[0] : ''
    formData.value.fecha_fin = item.fecha_fin ? item.fecha_fin.split('T')[0] : ''
  }
  else if (type === 'paquete') {
    editingId.value = item.id
    formData.value.nombre = item.paquete
    formData.value.precio = item.precio
    formData.value.descripcion = item.descripción
  }

  showModal.value = true
}

// ── LÓGICA DE DESACTIVAR Y REACTIVAR ─────────────────────────────────────────
const handleDelete = async (type: string, id: number | string) => {
  if (!confirm(`¿Estás seguro de desactivar este ${type}?`)) return

  let endpoint = ''
  let reloadFn: Function = () => {}

  if (type === 'producto') { endpoint = `/productos/desactivar/${id}`; reloadFn = loadProductos }
  else if (type === 'ingrediente') { endpoint = `/productos/ingrediente/desactivar/${id}`; reloadFn = loadIngredientes }
  else if (type === 'zona') { endpoint = `/tienda/zonas/desactivar/${id}`; reloadFn = loadMenusYZonas }
  else if (type === 'menu') { endpoint = `/menu/desactivar/${id}`; reloadFn = loadMenusYZonas }
  else if (type === 'paquete') { endpoint = `/paquetes/desactivar/${id}`; reloadFn = loadPaquetes }

  const res = await fetchConToken(endpoint, 'DELETE')
  if (res.status === 'ok') reloadFn()
  else alert(`Error: ${res.mensaje || 'No se pudo desactivar'}`)
}

const handleReactivate = async (type: string, item: any) => {
  if (!confirm(`¿Estás seguro de volver a activar este ${type}?`)) return

  let endpoint = ''
  let payload: any = { activo: true }
  let reloadFn: Function = () => {}

  if (type === 'producto') {
    if (zonas.value.length === 0) await loadMenusYZonas()
    if (categorias.value.length === 0) await loadCategorias()

    const cleanStr = (s: string) => (s || '').toString().toLowerCase().trim()
    
    const catEncontrada = categorias.value.find(c => cleanStr(c.nombre_cat || c.nombre) === cleanStr(item.categoria))
    const zonaEncontrada = zonas.value.find(z => cleanStr(z.nombre_zona || z.nombre) === cleanStr(item.zona))

    // Si la zona o categoría se borró de la BD, le abrimos el modal para que elija unas nuevas
    if (!catEncontrada || !zonaEncontrada) {
      alert('Las zonas o categorías originales cambiaron. Por favor, reasígnalas en el formulario para reactivarlo.')
      handleEdit('producto', item)
      return
    }

    endpoint = `/productos/modificar/${item.id_producto}`
    payload = {
      nombre: item.nombre_producto,
      precio: item.precio_base,
      id_categoria: catEncontrada.id_categoria || catEncontrada.id,
      id_zona: zonaEncontrada.id_zona || zonaEncontrada.id,
      disponibilidad: true // Opcional, si tu BD requiere este campo también
    }
    reloadFn = loadProductos
  } 
  else if (type === 'ingrediente') {
    endpoint = `/productos/ingrediente/actualizar/${item.id}`
    payload = { activo: true, estado: 'Disponible' } 
    reloadFn = loadIngredientes
  } 
  else if (type === 'zona') {
    endpoint = `/tienda/zonas/modificar/${item.id_zona}`
    payload = { activo: true }
    reloadFn = loadMenusYZonas
  } 
  else if (type === 'menu') {
    endpoint = `/menu/modificar/${item.id_menu}`
    payload = { activo: true }
    reloadFn = loadMenusYZonas
  } 
  else if (type === 'paquete') {
    endpoint = `/paquetes/actualizar/${item.id}`
    payload = { activo: true }
    reloadFn = loadPaquetes
  }

  const res = await fetchConToken(endpoint, 'PUT', payload)
  if (res.status === 'ok' || res.status === 200) {
    reloadFn()
  } else {
    alert(`Error al reactivar: ${res.mensaje || 'Revisa los datos'}`)
  }
}
// ── ENVÍO DE FORMULARIOS ─────────────────────────────────────────────────────
const closeModal = () => {
  showModal.value = false
  formData.value = {}
}

const handleSubmit = async () => {
  isSubmitting.value = true
  let endpoint = ''
  let method = isEditing.value ? 'PUT' : 'POST'
  let reloadFn: Function = () => {}

  if (modalType.value === 'ingrediente' && !isEditing.value) {
    formData.value.tipo = 'General' 
  }

  switch (modalType.value) {
    case 'producto':
      endpoint = isEditing.value ? `/productos/modificar/${editingId.value}` : '/productos/agregar'
      reloadFn = loadProductos
      break
    case 'ingrediente':
      endpoint = isEditing.value ? `/productos/ingrediente/actualizar/${editingId.value}` : '/productos/ingrediente/agregar'
      reloadFn = loadIngredientes
      break
    case 'zona':
      endpoint = isEditing.value ? `/tienda/zonas/modificar/${editingId.value}` : '/tienda/zonas/agregar'
      reloadFn = loadMenusYZonas
      break
    case 'menu':
      endpoint = isEditing.value ? `/menu/modificar/${editingId.value}` : '/menu/agregar'
      reloadFn = loadMenusYZonas
      break
    case 'paquete':
      endpoint = isEditing.value ? `/paquetes/actualizar/${editingId.value}` : '/paquetes/agregar'
      reloadFn = loadPaquetes
      break
  }

  const res = await fetchConToken(endpoint, method, formData.value)
  isSubmitting.value = false

  if (res.status === 'ok' || res.status === 201) {
    closeModal()
    reloadFn()
  } else {
    alert(`Error: ${res.mensaje || 'Revisa los datos ingresados'}`)
  }
}

// ── FILTROS COMPUTADOS ───────────────────────────────────────────────────────
const term = computed(() => cleanText(searchQuery.value))

const filteredProductos = computed(() => {
  return productos.value.filter(p => {
    const matchSearch = cleanText(p.nombre_producto).includes(term.value) || cleanText(p.descripcion).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? p._activo : !p._activo)
    const matchCat = catFilter.value === '' ? true : p.categoria === catFilter.value
    const matchZona = zonaFilter.value === '' ? true : p.zona === zonaFilter.value
    return matchSearch && matchStatus && matchCat && matchZona
  })
})

const filteredIngredientes = computed(() => {
  return ingredientes.value.filter(i => {
    const matchSearch = cleanText(i.ingrediente).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? i._activo : !i._activo)
    return matchSearch && matchStatus
  })
})

const filteredZonas = computed(() => {
  return zonas.value.filter(z => {
    const matchSearch = cleanText(z.nombre_zona).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? z._activo : !z._activo)
    return matchSearch && matchStatus
  })
})

const filteredMenus = computed(() => {
  return menus.value.filter(m => {
    const matchSearch = cleanText(m.nombre_menu).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? m._activo : !m._activo)
    return matchSearch && matchStatus
  })
})

const filteredPaquetes = computed(() => {
  return paquetes.value.filter(p => {
    const matchSearch = cleanText(p.paquete).includes(term.value) || cleanText(p.descripción).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? p._activo : !p._activo)
    const matchType = tipoPaqueteFilter.value === 'todos' ? true : cleanText(p.tipo).includes(tipoPaqueteFilter.value)
    return matchSearch && matchStatus && matchType
  })
})

onMounted(() => {
  loadProductos()
})
</script>

<template>
  <div class="menu-container">
    <header class="menu-header">
      <h1 class="page-title">Gestión de Inventario</h1>
      <p class="page-subtitle">Visualiza, filtra y administra el catálogo del sistema.</p>
    </header>

    <nav class="tabs-nav">
      <button v-for="tab in tabs" :key="tab.id" :class="['tab-btn', { active: activeTab === tab.id }]" @click="setTab(tab.id)">
        {{ tab.label }}
      </button>
    </nav>

    <div class="toolbar">
      <div class="search-box">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input v-model="searchQuery" type="text" placeholder="Buscar..." class="search-input" />
      </div>

      <div class="filters-group">
        <select v-model="statusFilter" class="filter-select">
          <option value="activos">Solo Activos</option>
          <option value="inactivos">Solo Inactivos</option>
          <option value="todos">Mostrar Todos</option>
        </select>

        <template v-if="activeTab === 'productos'">
          <select v-model="catFilter" class="filter-select">
            <option value="">Todas las Categorías</option>
            <option v-for="cat in categoriasUnicas" :key="cat" :value="cat">{{ cat }}</option>
          </select>
          <select v-model="zonaFilter" class="filter-select">
            <option value="">Todas las Zonas</option>
            <option v-for="zona in zonasUnicas" :key="zona" :value="zona">{{ zona }}</option>
          </select>
        </template>

        <template v-if="activeTab === 'paquetes'">
          <select v-model="tipoPaqueteFilter" class="filter-select">
            <option value="todos">Paquetes y Promos</option>
            <option value="paquete">Solo Paquetes</option>
            <option value="promocion">Solo Promociones</option>
          </select>
        </template>
      </div>

      <div v-if="canManage" class="actions-group">
        <button v-if="activeTab === 'productos'" @click="openAddModal('producto')" class="btn-primary">+ Nuevo Producto</button>
        <button v-if="activeTab === 'ingredientes'" @click="openAddModal('ingrediente')" class="btn-primary">+ Nuevo Ingrediente</button>
        <div v-if="activeTab === 'menus_zonas'" style="display:flex; gap:8px;">
          <button @click="openAddModal('zona')" class="btn-primary">+ Nueva Zona</button>
          <button @click="openAddModal('menu')" class="btn-primary">+ Nuevo Menú</button>
        </div>
        <button v-if="activeTab === 'paquetes'" @click="openAddModal('paquete')" class="btn-primary">+ Nuevo Paquete</button>
      </div>
    </div>

    <main class="tab-content">
      <div v-if="isLoading" class="loading-state">Cargando datos del sistema...</div>

      <div v-show="activeTab === 'productos' && !isLoading" class="grid-container">
        <div v-if="filteredProductos.length === 0" class="empty-state">No se encontraron productos.</div>
        <div v-for="item in filteredProductos" :key="item.id_producto" :class="['card', { 'inactive-card': !item._activo }]">
          <div class="card-header">
            <h3 class="card-title">{{ item.nombre_producto }}</h3>
            <span class="card-price">${{ item.precio_base }}</span>
          </div>
          <div class="card-footer mt-auto">
            <div class="badges-container">
              <span class="badge">{{ item.categoria }}</span>
              <span class="badge">{{ item.zona }}</span>
              <span v-if="!item._activo" class="badge danger">Inactivo</span>
            </div>
            
            <div v-if="canManage" class="actions-container">
              <template v-if="item._activo">
                <button @click="handleEdit('producto', item)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                <button @click="handleDelete('producto', item.id_producto)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
              </template>
              <template v-else>
                <button @click="handleReactivate('producto', item)" class="action-btn reactivate-btn" title="Reactivar">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                </button>
              </template>
            </div>

          </div>
        </div>
      </div>

      <div v-show="activeTab === 'ingredientes' && !isLoading" class="grid-container">
        <div v-if="filteredIngredientes.length === 0" class="empty-state">No se encontraron ingredientes.</div>
        <div v-for="item in filteredIngredientes" :key="item.id" :class="['card', { 'inactive-card': !item._activo }]">
          <div class="card-header">
            <h3 class="card-title">{{ item.ingrediente }}</h3>
            <span class="card-price">+${{ item.precio }}</span>
          </div>
          <div class="card-footer mt-auto">
            <div class="badges-container">
              <span class="badge">{{ item.tipo }}</span>
              <span :class="['badge', item._activo ? 'success' : 'danger']">{{ item._activo ? 'Activo' : 'Inactivo' }}</span>
            </div>
            
            <div v-if="canManage" class="actions-container">
              <template v-if="item._activo">
                <button @click="handleEdit('ingrediente', item)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                <button @click="handleDelete('ingrediente', item.id)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
              </template>
              <template v-else>
                <button @click="handleReactivate('ingrediente', item)" class="action-btn reactivate-btn" title="Reactivar">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                </button>
              </template>
            </div>

          </div>
        </div>
      </div>

      <div v-show="activeTab === 'menus_zonas' && !isLoading" class="split-section">
        <section class="sub-section">
          <h2 class="section-title">Zonas</h2>
          <div class="grid-container">
            <div v-if="filteredZonas.length === 0" class="empty-state">No se encontraron zonas.</div>
            <div v-for="zona in filteredZonas" :key="zona.id_zona" :class="['card', { 'inactive-card': !zona._activo }]">
              <h3 class="card-title">{{ zona.nombre_zona }}</h3>
              <p class="card-desc">{{ zona.descripcion_zona }}</p>
              <div class="card-footer mt-auto justify-end">
                <div class="badges-container"><span v-if="!zona._activo" class="badge danger">Inactiva</span></div>
                
                <div v-if="canManage" class="actions-container">
                  <template v-if="zona._activo">
                    <button @click="handleEdit('zona', zona)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                    <button @click="handleDelete('zona', zona.id_zona)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                  </template>
                  <template v-else>
                    <button @click="handleReactivate('zona', zona)" class="action-btn reactivate-btn" title="Reactivar">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                    </button>
                  </template>
                </div>

              </div>
            </div>
          </div>
        </section>

        <section class="sub-section mt-4">
          <h2 class="section-title">Menús</h2>
          <div class="grid-container">
            <div v-if="filteredMenus.length === 0" class="empty-state">No se encontraron menús.</div>
            <div v-for="menu in filteredMenus" :key="menu.id_menu" :class="['card', { 'inactive-card': !menu._activo }]">
              <h3 class="card-title">{{ menu.nombre_menu }}</h3>
              <p class="card-desc">{{ menu.descripcion || 'Sin descripción' }}</p>
              <div class="card-footer mt-auto">
                <div class="badges-container">
                  <span class="badge">{{ menu.hora_inicio }} - {{ menu.hora_fin }}</span>
                  <span class="badge">{{ menu.dias_semana }}</span>
                  <span v-if="!menu._activo" class="badge danger">Inactivo</span>
                </div>
                
                <div v-if="canManage" class="actions-container">
                  <template v-if="menu._activo">
                    <button @click="handleEdit('menu', menu)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                    <button @click="handleDelete('menu', menu.id_menu)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                  </template>
                  <template v-else>
                    <button @click="handleReactivate('menu', menu)" class="action-btn reactivate-btn" title="Reactivar">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                    </button>
                  </template>
                </div>

              </div>
            </div>
          </div>
        </section>
      </div>

      <div v-show="activeTab === 'paquetes' && !isLoading" class="grid-container">
        <div v-if="filteredPaquetes.length === 0" class="empty-state">No se encontraron paquetes o promociones.</div>
        <div v-for="paquete in filteredPaquetes" :key="paquete.id" :class="['card', { 'inactive-card': !paquete._activo }]">
          <div class="card-header">
            <h3 class="card-title">{{ paquete.paquete }}</h3>
            <span class="card-price">${{ paquete.precio }}</span>
          </div>
          <p class="card-desc">{{ paquete.descripción }}</p>
          <div class="card-footer mt-auto">
            <div class="badges-container">
              <span class="badge">{{ paquete.tipo }}</span>
              <span v-if="paquete.dias_disponibles" class="badge warning">{{ paquete.dias_disponibles }}</span>
              <span v-if="!paquete._activo" class="badge danger">Inactivo</span>
            </div>
            
            <div v-if="canManage" class="actions-container">
              <template v-if="paquete._activo">
                <button @click="handleEdit('paquete', paquete)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                <button @click="handleDelete('paquete', paquete.id)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
              </template>
              <template v-else>
                <button @click="handleReactivate('paquete', paquete)" class="action-btn reactivate-btn" title="Reactivar">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                </button>
              </template>
            </div>

          </div>
        </div>
      </div>
    </main>

    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h2 class="modal-title">{{ isEditing ? 'Editar' : 'Agregar Nuevo(a)' }} <span style="text-transform: capitalize">{{ modalType }}</span></h2>
        
        <form @submit.prevent="handleSubmit" class="modal-form">
          <div class="form-group">
            <label>Nombre:</label>
            <input v-model="formData.nombre" type="text" required class="form-input" />
          </div>

          <template v-if="modalType === 'zona'">
            <div class="form-group">
              <label>Descripción:</label>
              <textarea v-model="formData.descripcion" class="form-input"></textarea>
            </div>
          </template>

          <template v-if="modalType === 'ingrediente'">
            <div class="form-group">
              <label>Precio Adicional:</label>
              <input v-model.number="formData.precio" type="number" step="0.1" required class="form-input" />
            </div>
          </template>

          <template v-if="modalType === 'producto'">
            <div class="form-group">
              <label>Descripción:</label>
              <textarea v-model="formData.descripcion" class="form-input"></textarea>
            </div>
            <div class="form-group">
              <label>Precio Base:</label>
              <input v-model.number="formData.precio" type="number" step="0.1" required class="form-input" />
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Categoría:</label>
                <select v-model="formData.id_categoria" required class="form-select">
                  <option disabled value="">Selecciona...</option>
                  <option v-for="cat in categorias" :key="cat.id_categoria" :value="cat.id_categoria">{{ cat.nombre_cat }}</option>
                </select>
              </div>
              <div class="form-group">
                <label>Zona de Preparación:</label>
                <select v-model="formData.id_zona" required class="form-select">
                  <option disabled value="">Selecciona...</option>
                  <option v-for="z in zonas.filter((z: any) => z._activo)" :key="z.id_zona" :value="z.id_zona">{{ z.nombre_zona || z.nombre }}</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label>URL Imagen (Opcional):</label>
              <input v-model="formData.url_imagen" type="text" class="form-input" />
            </div>
          </template>

          <template v-if="modalType === 'menu'">
            <div class="form-group">
              <label>Descripción:</label>
              <textarea v-model="formData.descripcion" class="form-input"></textarea>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Hora Inicio:</label>
                <input v-model="formData.hora_inicio" type="time" required class="form-input" />
              </div>
              <div class="form-group">
                <label>Hora Fin:</label>
                <input v-model="formData.hora_fin" type="time" required class="form-input" />
              </div>
            </div>
            <div class="form-group">
              <label>Días de la semana (Ej. Lunes-Viernes):</label>
              <input v-model="formData.dias_semana" type="text" required class="form-input" />
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Fecha Inicio (Opcional):</label>
                <input v-model="formData.fecha_inicio" type="date" class="form-input" />
              </div>
              <div class="form-group">
                <label>Fecha Fin (Opcional):</label>
                <input v-model="formData.fecha_fin" type="date" class="form-input" />
              </div>
            </div>
          </template>

          <template v-if="modalType === 'paquete'">
            <div class="form-group">
              <label>Descripción:</label>
              <textarea v-model="formData.descripcion" class="form-input"></textarea>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Precio:</label>
                <input v-model.number="formData.precio" type="number" step="0.1" required class="form-input" />
              </div>
              <div class="form-group" style="display: flex; align-items: center; gap: 8px; padding-top: 24px;">
                <input v-model="formData.es_temporal" type="checkbox" id="tempCheck" />
                <label for="tempCheck" style="margin:0; cursor:pointer;">¿Es Temporal?</label>
              </div>
            </div>
            <div v-if="formData.es_temporal" class="form-row">
              <div class="form-group">
                <label>Fecha/Hora Inicio:</label>
                <input v-model="formData.fecha_inicio" type="datetime-local" class="form-input" />
              </div>
              <div class="form-group">
                <label>Fecha/Hora Fin:</label>
                <input v-model="formData.fecha_fin" type="datetime-local" class="form-input" />
              </div>
            </div>
            <div class="form-group">
              <label>Días disponibles (Opcional):</label>
              <input v-model="formData.dias_disponibles" type="text" class="form-input" />
            </div>
          </template>

          <div class="modal-actions">
            <button type="button" @click="closeModal" class="btn-cancel" :disabled="isSubmitting">Cancelar</button>
            <button type="submit" class="btn-primary" :disabled="isSubmitting">
              {{ isSubmitting ? 'Guardando...' : 'Guardar' }}
            </button>
          </div>
        </form>
      </div>
    </div>

  </div>
</template>

<style scoped>
/* ── ESTILOS GENERALES Y LAYOUT ── */
.menu-container { padding: var(--espacio-6, 24px); color: var(--tenant-texto, #111827); display: flex; flex-direction: column; gap: var(--espacio-6, 24px); min-height: 100%; }
.menu-header { display: flex; flex-direction: column; gap: var(--espacio-2, 8px); }
.page-title { font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); margin: 0; }
.page-subtitle { font-size: var(--font-size-base, 15px); color: var(--tenant-texto-muted, #6b7280); margin: 0; }

.tabs-nav { display: flex; gap: var(--espacio-6, 24px); border-bottom: 1px solid var(--color-borde, #e5e7eb); overflow-x: auto; }
.tab-btn { background: none; border: none; padding: var(--espacio-3, 12px) 0; font-size: var(--font-size-base, 15px); font-weight: var(--font-weight-medium, 500); color: var(--tenant-texto-muted, #6b7280); cursor: pointer; border-bottom: 2px solid transparent; transition: color 0.2s, border-color 0.2s; white-space: nowrap; }
.tab-btn:hover { color: var(--tenant-texto, #111827); }
.tab-btn.active { color: var(--tenant-primario, #002D72); border-bottom-color: var(--tenant-primario, #002D72); }

/* ── TOOLBAR Y BOTONES ── */
.toolbar { display: flex; flex-wrap: wrap; gap: var(--espacio-4, 16px); align-items: center; justify-content: space-between; background: var(--color-superficie, #ffffff); padding: var(--espacio-3, 12px) var(--espacio-4, 16px); border-radius: 8px; border: 1px solid var(--color-borde, #e5e7eb); }
.search-box { display: flex; align-items: center; gap: var(--espacio-2, 8px); background: var(--color-superficie-alt, #f3f4f6); padding: var(--espacio-2, 8px) var(--espacio-3, 12px); border-radius: 6px; flex: 1; min-width: 250px; max-width: 400px; border: 1px solid transparent; transition: border-color 0.2s; }
.search-box:focus-within { border-color: var(--tenant-primario, #002D72); background: var(--color-superficie, #ffffff); }
.search-icon { width: 18px; height: 18px; color: var(--tenant-texto-muted, #6b7280); }
.search-input { border: none; background: transparent; outline: none; width: 100%; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto, #111827); font-family: inherit; }

.filters-group { display: flex; gap: var(--espacio-3, 12px); flex-wrap: wrap; }
.filter-select { padding: var(--espacio-2, 8px) var(--espacio-3, 12px); font-size: var(--font-size-sm, 13px); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; background-color: var(--color-superficie, #ffffff); color: var(--tenant-texto, #111827); outline: none; cursor: pointer; transition: border-color 0.2s; }

.btn-primary { background-color: var(--tenant-primario, #002D72); color: white; padding: 8px 16px; border-radius: 6px; border: none; font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: opacity 0.2s; white-space: nowrap; }
.btn-primary:hover { opacity: 0.9; }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-cancel { background-color: transparent; color: var(--tenant-texto-muted, #6b7280); padding: 8px 16px; border-radius: 6px; border: 1px solid var(--color-borde, #e5e7eb); font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; transition: background 0.2s; }
.btn-cancel:hover { background-color: var(--color-superficie-alt, #f3f4f6); }

/* ── TARJETAS Y GRID ── */
.tab-content { flex: 1; }
.grid-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: var(--espacio-4, 16px); }
.card { background-color: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; padding: var(--espacio-4, 16px); display: flex; flex-direction: column; gap: var(--espacio-3, 12px); transition: box-shadow 0.2s, border-color 0.2s; }
.inactive-card { opacity: 0.6; background-color: var(--color-superficie-alt, #f3f4f6); }
.card-header { display: flex; justify-content: space-between; align-items: flex-start; gap: var(--espacio-2, 8px); }
.card-title { font-size: var(--font-size-md, 17px); font-weight: var(--font-weight-bold, 600); margin: 0; }
.card-price { font-size: var(--font-size-base, 15px); font-weight: var(--font-weight-bold, 600); color: var(--color-exitoso, #16a34a); background-color: rgba(22, 163, 74, 0.1); padding: 2px 8px; border-radius: 12px; }
.card-desc { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); margin: 0; }
.mt-auto { margin-top: auto; }
.card-footer { display: flex; justify-content: space-between; align-items: center; padding-top: var(--espacio-3, 12px); border-top: 1px dashed var(--color-borde, #e5e7eb); }
.justify-end { justify-content: flex-end; }
.badges-container { display: flex; flex-wrap: wrap; gap: var(--espacio-2, 8px); flex: 1; align-items: center; }
.badge { font-size: var(--font-size-xs, 11px); background-color: var(--color-superficie-alt, #f3f4f6); color: var(--tenant-texto-muted, #6b7280); padding: 4px 8px; border-radius: 4px; font-weight: var(--font-weight-medium, 500); }
.badge.warning { background-color: rgba(217, 119, 6, 0.1); color: var(--color-advertencia, #d97706); }
.badge.success { background-color: rgba(22, 163, 74, 0.1); color: var(--color-exitoso, #16a34a); }
.badge.danger { background-color: rgba(220, 38, 38, 0.1); color: var(--color-cancelar, #ef4444); border: 1px solid rgba(220,38,38,0.2); }
.actions-container { display: flex; gap: var(--espacio-2, 8px); }
.action-btn { background: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: var(--tenant-texto-muted, #6b7280); transition: all 0.2s ease;}
.action-btn svg { width: 16px; height: 16px; }

/* Efectos hover de los botones */
.edit-btn:hover { background-color: rgba(37, 99, 235, 0.1); border-color: var(--color-info, #2563eb); color: var(--color-info, #2563eb); }
.delete-btn:hover { background-color: rgba(220, 38, 38, 0.1); border-color: var(--color-cancelar, #ef4444); color: var(--color-cancelar, #ef4444); }
.reactivate-btn:hover { background-color: rgba(22, 163, 74, 0.1); border-color: var(--color-exitoso, #16a34a); color: var(--color-exitoso, #16a34a); }

.sub-section { display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }
.section-title { font-size: var(--font-size-lg, 20px); font-weight: var(--font-weight-bold, 600); margin: 0; }
.mt-4 { margin-top: var(--espacio-8, 32px); }
.loading-state, .empty-state { text-align: center; padding: var(--espacio-8, 32px); color: var(--tenant-texto-muted, #6b7280); background-color: var(--color-superficie, #ffffff); border: 1px dashed var(--color-borde, #e5e7eb); border-radius: 8px; }

/* ── MODAL ── */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; padding: var(--espacio-4, 16px); }
.modal-content { background: var(--color-superficie, #ffffff); padding: var(--espacio-6, 24px); border-radius: 12px; width: 100%; max-width: 500px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); max-height: 90vh; overflow-y: auto; }
.modal-title { margin: 0 0 var(--espacio-4, 16px) 0; font-size: var(--font-size-lg, 20px); font-weight: 600; color: var(--tenant-texto, #111827); border-bottom: 1px solid var(--color-borde, #e5e7eb); padding-bottom: var(--espacio-3, 12px); }
.modal-form { display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }
.form-group { display: flex; flex-direction: column; gap: 4px; flex: 1; }
.form-row { display: flex; gap: var(--espacio-4, 16px); }
.form-group label { font-size: var(--font-size-sm, 13px); font-weight: 500; color: var(--tenant-texto, #111827); }
.form-input, .form-select { width: 100%; padding: 8px 12px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; font-size: var(--font-size-sm, 13px); outline: none; transition: border-color 0.2s; font-family: inherit; }
.form-input:focus, .form-select:focus { border-color: var(--tenant-primario, #002D72); }
textarea.form-input { resize: vertical; min-height: 80px; }
.modal-actions { display: flex; justify-content: flex-end; gap: var(--espacio-3, 12px); margin-top: var(--espacio-4, 16px); padding-top: var(--espacio-4, 16px); border-top: 1px solid var(--color-borde, #e5e7eb); }
</style>