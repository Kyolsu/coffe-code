<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import API_URL from '../config/api'

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
  { id: 'categorias', label: 'Categorías' },
  { id: 'menus_zonas', label: 'Menús y Zonas' },
  { id: 'paquetes', label: 'Paquetes y Promos' }
]
const activeTab = ref('productos')

const productos = ref<any[]>([])
const ingredientes = ref<any[]>([])
const menus = ref<any[]>([])
const zonas = ref<any[]>([])
const paquetes = ref<any[]>([])
const promociones = ref<any[]>([])
const categorias = ref<any[]>([]) 

const isLoading = ref(false)
const API_BASE = `${API_URL}/api`

// ── TOAST NOTIFICATIONS ──────────────────────────────────────────────────────
const toasts = ref<{ id: number; message: string; type: 'success' | 'error' | 'warning' }[]>([])
let toastId = 0

const showToast = (message: string, type: 'success' | 'error' | 'warning' = 'success') => {
  const id = ++toastId
  toasts.value.push({ id, message, type })
  setTimeout(() => {
    toasts.value = toasts.value.filter(t => t.id !== id)
  }, 3000)
}

const cleanText = (str: string) => {
  if (!str) return ''
  return str.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "")
}

const searchQuery = ref('')
const statusFilter = ref('activos')
const catFilter = ref('')
const zonaFilter = ref('')

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

  const menusMap = new Map()
  for (const m of (menusActivos.datos || [])) {
    menusMap.set(m.id_menu, { ...m, _activo: m.activo !== false && m.activo !== null })
  }
  for (const m of (menusInactivos.datos || [])) {
    menusMap.set(m.id_menu, { ...m, _activo: m.activo !== false && m.activo !== null })
  }

  const zonasMap = new Map()
  for (const z of (zonasActivas.datos || [])) {
    zonasMap.set(z.id_zona, { ...z, _activo: true })
  }
  for (const z of (zonasInactivas.datos || [])) {
    zonasMap.set(z.id_zona, { ...z, _activo: false })
  }

  menus.value = Array.from(menusMap.values())
  zonas.value = Array.from(zonasMap.values())

  isLoading.value = false
}

const loadPaquetes = async () => {
  isLoading.value = true
  const res = await fetchConToken('/paquetes/vista-completa')
  console.log('Paquetes response:', res)
  paquetes.value = (res.datos || []).map((p: any) => ({
    ...p,
    paquete: p.nombre || p.nombre_paquete || p.paquete || 'Sin nombre',
    descripcion: p.descripcion || p.descripcion_paquete || '',
    _activo: p.activo !== false && p.activo !== 0 && p.activo !== null
  }))
  isLoading.value = false
}

const loadPromociones = async () => {
  isLoading.value = true
  const res = await fetchConToken('/promociones/mostrar')
  console.log('📦 DEBUG Menu - Promociones raw:', JSON.stringify(res.datos))
  promociones.value = (res.datos || []).map((p: any) => ({
    ...p,
    nombre_promocion: p.nombre_promocion || p.nombre || p.promocion,
    descripcion: p.descripcion || p.descripcion_promocion || '',
    tipo: p.tipo || 'porcentaje',
    valor: p.valor || 0,
    dias: p.dias || p.dias_aplicables || [],
    es_temporal: p.es_temporal || false,
    solo_clientes: p.solo_clientes || false,
    _activo: true
  }))
  isLoading.value = false
}

const loadCategorias = async () => {
  isLoading.value = true
  const [activas, inactivas] = await Promise.all([
    fetchConToken('/tienda/categorias/mostrar'),
    fetchConToken('/tienda/categorias/mostrar-inactivas')
  ])
  categorias.value = [
    ...(activas.datos || []).map((c: any) => ({ ...c, _activo: true })),
    ...(inactivas.datos || []).map((c: any) => ({ ...c, _activo: false }))
  ]
  isLoading.value = false
}

const ingredientesDisponibles = ref<any[]>([])
const selectedIngredients = ref<number[]>([])

// Grupos de paquete (para crear paquete con opciones)
const paqueteGrupos = ref<{ nombre: string; obligatorio: boolean; cantidad: number; productos: number[]; categoriaFiltro: string }[]>([])
const productosDisponibles = ref<any[]>([])

// Grupos de promoción (similar a paquetes)
const promoGrupos = ref<{ nombre: string; obligatorio: boolean; cantidad: number; productos: number[]; categoriaFiltro: string }[]>([])

// Variables para promoción
const clientesDisponibles = ref<any[]>([])
const selectedClientes = ref<number[]>([])
const promoBusquedaCliente = ref('')
const promoAplicarPaquetes = ref(false)
const promoProductosSeleccionados = ref<number[]>([])
const promoPaquetesSeleccionados = ref<number[]>([])
const promoCategoriaFiltro = ref<string>('')
const promoScope = ref<'todos' | 'productos' | 'categorias'>('todos')
const promoCategoriasSeleccionadas = ref<string[]>([])

const loadProductosParaPaquetes = async () => {
  const res = await fetchConToken('/productos/mostrar')
  productosDisponibles.value = res.datos || []
}

const loadClientesParaPromocion = async () => {
  const res = await fetchConToken('/clientes/mostrar-activos')
  clientesDisponibles.value = res.datos || []
}

const filteredClientes = computed(() => {
  if (!promoBusquedaCliente.value) return clientesDisponibles.value
  const term = cleanText(promoBusquedaCliente.value)
  return clientesDisponibles.value.filter((c: any) => {
    const nombre = c.nombre_cliente || c.nombre || ''
    const email = c.correo || c.email || ''
    return cleanText(nombre).includes(term) || cleanText(email).includes(term)
  })
})

const getPromoProductosFiltrados = (categoria: string) => {
  if (!categoria) return productosDisponibles.value.filter((p: any) => p._activo !== false)
  return productosDisponibles.value.filter((p: any) => p.categoria === categoria && p._activo !== false)
}

const paquetesActivos = computed(() => {
  return paquetes.value.filter((p: any) => p._activo !== false)
})

const addGrupo = () => {
  paqueteGrupos.value.push({ nombre: '', obligatorio: true, cantidad: 1, productos: [], categoriaFiltro: '' })
}

const removeGrupo = (index: number) => {
  paqueteGrupos.value.splice(index, 1)
}

const addGrupoPromo = () => {
  promoGrupos.value.push({ nombre: '', obligatorio: true, cantidad: 1, productos: [], categoriaFiltro: '' })
}

const removeGrupoPromo = (index: number) => {
  promoGrupos.value.splice(index, 1)
}

const loadIngredientesDisponibles = async () => {
  const res = await fetchConToken('/productos/ingredientes/mostrar')
  const all = res.datos || []
  ingredientesDisponibles.value = all.filter((i: any) => {
    const estadoLimpio = cleanText(i.estado)
    return estadoLimpio === 'disponible' || estadoLimpio === 'activo' || i.activo === true
  })
}

const setTab = (tabId: string) => {
  activeTab.value = tabId
  searchQuery.value = ''
  if (tabId === 'productos' && productos.value.length === 0) loadProductos()
  if (tabId === 'ingredientes' && ingredientes.value.length === 0) loadIngredientes()
  if (tabId === 'categorias' && categorias.value.length === 0) loadCategorias()
  if (tabId === 'menus_zonas') loadMenusYZonas()
  if (tabId === 'paquetes') {
    if (paquetes.value.length === 0) loadPaquetes()
    if (promociones.value.length === 0) loadPromociones()
  }
}

// ── LÓGICA DEL MODAL Y CRUD (CREAR/EDITAR) ───────────────────────────────────
const showModal = ref(false)
const modalType = ref('')
const formData = ref<Record<string, any>>({})
const isSubmitting = ref(false)
const isEditing = ref(false)
const editingId = ref<string | number | null>(null)

// Días de la semana para menús
const diasSemana = [
  { valor: 'Lunes', label: 'Lun' },
  { valor: 'Martes', label: 'Mar' },
  { valor: 'Miércoles', label: 'Mié' },
  { valor: 'Jueves', label: 'Jue' },
  { valor: 'Viernes', label: 'Vie' },
  { valor: 'Sábado', label: 'Sáb' },
  { valor: 'Domingo', label: 'Dom' }
]
const selectedDias = ref<string[]>([])
const selectedDiasPaquete = ref<string[]>([])

const openAddModal = async (type: string) => {
  modalType.value = type
  isEditing.value = false
  editingId.value = null
  formData.value = {}
  selectedIngredients.value = []
  if (type === 'menu') selectedDias.value = []
  if (type === 'paquete') {
    paqueteGrupos.value = []
    selectedDiasPaquete.value = []
    await loadProductosParaPaquetes()
  }

  if (type === 'promocion') {
    promoGrupos.value = []
    promoProductosSeleccionados.value = []
    promoPaquetesSeleccionados.value = []
    selectedClientes.value = []
    promoBusquedaCliente.value = ''
    promoAplicarPaquetes.value = false
    promoScope.value = 'todos'
    selectedDiasPaquete.value = []
    await Promise.all([
      loadProductosParaPaquetes(),
      loadClientesParaPromocion(),
      loadPaquetes()
    ])
  }
  
  if (type === 'producto') {
    if (zonas.value.length === 0) await loadMenusYZonas()
    if (categorias.value.length === 0) await loadCategorias()
    await loadIngredientesDisponibles()
  }
  showModal.value = true
}

const handleEdit = async (type: string, item: any) => {
  modalType.value = type
  isEditing.value = true
  formData.value = {}
  selectedIngredients.value = []
  
  // Limpiar datos de paquetes y promociones
  paqueteGrupos.value = []
  promoGrupos.value = []
  selectedDiasPaquete.value = []
  promoProductosSeleccionados.value = []
  promoPaquetesSeleccionados.value = []
  selectedClientes.value = []
  promoAplicarPaquetes.value = false
  promoScope.value = 'productos'

  // Función interna para limpiar textos y asegurar el match
  const cleanStr = (s: string) => (s || '').toString().toLowerCase().trim()

  if (type === 'producto') {
    if (zonas.value.length === 0) await loadMenusYZonas()
    if (categorias.value.length === 0) await loadCategorias()
    await loadIngredientesDisponibles()
    
    editingId.value = item.id_producto
    formData.value.nombre = item.nombre_producto
    formData.value.precio = item.precio_base
    formData.value.descripcion = item.descripcion_pro || item.descripcion || ''
    formData.value.url_imagen = item.url_imagen || ''
    
    // Búsqueda segura
    const catEncontrada = categorias.value.find(c => cleanStr(c.nombre_cat || c.nombre) === cleanStr(item.categoria))
    if (catEncontrada) formData.value.id_categoria = catEncontrada.id_categoria || catEncontrada.id
    
    const zonaEncontrada = zonas.value.find(z => cleanStr(z.nombre_zona || z.nombre) === cleanStr(item.zona))
    if (zonaEncontrada) formData.value.id_zona = zonaEncontrada.id_zona || zonaEncontrada.id

    // Cargar ingredientes vinculados al producto
    try {
      const resIng = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${item.id_producto}`)
      console.log('Ingredientes del producto:', resIng)
      if (resIng.datos && resIng.datos.length > 0) {
        // Intentar varios campos posibles para el ID del ingrediente
        selectedIngredients.value = resIng.datos.map((pi: any) => 
          pi.id_ingrediente || pi.id || pi.id_producto_ingrediente
        )
      }
    } catch (e) {
      console.error('Error al cargar ingredientes del producto', e)
    }
  }
  else if (type === 'ingrediente') {
    editingId.value = item.id
    formData.value.nombre = item.ingrediente
    formData.value.precio = item.precio
    formData.value.tipo = item.tipo || 'opcional'
  }
  else if (type === 'categoria') {
    editingId.value = item.id_categoria
    formData.value.nombre = item.nombre_cat || item.nombre
    formData.value.descripcion = item.descripcion_cat || item.descripcion || ''
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
    formData.value.fecha_inicio = item.fecha_inicio ? item.fecha_inicio.split('T')[0] : ''
    formData.value.fecha_fin = item.fecha_fin ? item.fecha_fin.split('T')[0] : ''
    // Parsear días de semana
    if (item.dias_semana) {
      const dias = item.dias_semana.split(',').map((d: string) => d.trim())
      selectedDias.value = dias.filter((d: string) => diasSemana.some(ds => ds.valor === d))
    } else {
      selectedDias.value = []
    }
  }
  else if (type === 'paquete') {
    // Soportar diferentes nombres de campo para el ID
    const pkgId = item.id || item.id_paquete
    editingId.value = pkgId
    console.log('Editando paquete:', item)
    formData.value.nombre = item.paquete
    formData.value.precio = item.precio
    formData.value.descripcion = item.descripcion || item.descripción
    formData.value.es_temporal = item.es_temporal
    formData.value.fecha_inicio = item.fecha_inicio ? item.fecha_inicio.split('T')[0] : ''
    formData.value.fecha_fin = item.fecha_fin ? item.fecha_fin.split('T')[0] : ''
    formData.value.dias_disponibles = item.dias_disponibles

    // Cargar días disponibles en el checkbox
    if (item.dias_disponibles) {
      const diasArr = item.dias_disponibles.split(',').map((d: string) => d.trim())
      selectedDiasPaquete.value = diasArr.filter((d: string) => diasSemana.some(ds => ds.valor === d))
    } else {
      selectedDiasPaquete.value = []
    }

// Cargar grupos del paquete
    try {
      // Usar menu-completo que devuelve grupos con sus productos
      const resMenuCompleto = await fetchConToken('/paquetes/menu-completo')
      console.log('Menu completo response:', resMenuCompleto)
      
      if (resMenuCompleto.datos) {
        // Filtrar el paquete específico usando pkgId correcto
        const paqueteCompleto = resMenuCompleto.datos.find((p: any) => 
          p.id_paquete === pkgId
        )
        console.log('Paquete encontrado:', paqueteCompleto)
        
        if (paqueteCompleto && paqueteCompleto.grupos && paqueteCompleto.grupos.length > 0) {
          // Cargar productos disponibles
          await loadProductosParaPaquetes()
          
          // Por cada grupo, obtener sus productos
          for (const grupo of paqueteCompleto.grupos) {
            const grupoConProductos = {
              nombre: grupo.nombre_grupo || grupo.nombre,
              obligatorio: grupo.es_obligatorio || false,
              cantidad: grupo.cantidad || 1,
              productos: grupo.productos ? grupo.productos.map((pg: any) => pg.id_producto) : [],
              categoriaFiltro: ''
            }
            paqueteGrupos.value.push(grupoConProductos)
          }
          console.log('Grupos cargados:', paqueteGrupos.value)
        }
      }
} catch (e) {
      console.error('Error al cargar grupos del paquete', e)
    }
  }
else if (type === 'promocion') {
    const promoId = item.id_promocion || item.id
    editingId.value = promoId
    formData.value.nombre = item.nombre_promocion || item.nombre || item.promocion
    formData.value.descripcion = item.descripcion || item.descripcion_promocion || ''
    
    // Normalizar tipo: porcentaje -> descuento, bogo -> 2x1, monto -> fijo
    let tipoNorm = item.tipo || 'descuento'
    if (tipoNorm === 'porcentaje') tipoNorm = 'descuento'
    else if (tipoNorm === 'bogo') tipoNorm = '2x1'
    else if (tipoNorm === 'monto') tipoNorm = 'fijo'
    formData.value.tipo = tipoNorm
    
    formData.value.valor = item.valor || 0
    formData.value.es_temporal = item.es_temporal || false
    formData.value.es_permanente = item.es_permanente || false
    formData.value.hora_inicio = item.hora_inicio || ''
    formData.value.hora_fin = item.hora_fin || ''
    formData.value.solo_clientes = item.solo_clientes || false

    // Cargar datos relacionados con la promoción
    await Promise.all([
      loadProductosParaPaquetes(),
      loadClientesParaPromocion(),
      loadPaquetes()
    ])

    // Cargar días disponibles en el checkbox (soporta dias y dias_aplicables)
    const diasData = item.dias_aplicables || item.dias || item.dias_disponibles || []
    if (Array.isArray(diasData)) {
      selectedDiasPaquete.value = diasData.filter((d: string) => {
        const diaLimpio = d.toLowerCase().replace(/á/g,'a').replace(/é/g,'e').replace(/í/g,'i').replace(/ó/g,'o').replace(/ú/g,'u')
        return diasSemana.some(ds => ds.valor.toLowerCase().replace(/á/g,'a').replace(/é/g,'e').replace(/í/g,'i').replace(/ó/g,'o').replace(/ú/g,'u') === diaLimpio)
      })
    } else if (typeof diasData === 'string') {
      let diasStr = diasData.replace(/[{}]/g, '')
      const diasArr = diasStr.split(',').map((d: string) => d.trim())
      selectedDiasPaquete.value = diasArr.filter((d: string) => {
        const diaLimpio = d.toLowerCase().replace(/á/g,'a').replace(/é/g,'e').replace(/í/g,'i').replace(/ó/g,'o').replace(/ú/g,'u')
        return diasSemana.some(ds => ds.valor.toLowerCase().replace(/á/g,'a').replace(/é/g,'e').replace(/í/g,'i').replace(/ó/g,'o').replace(/ú/g,'u') === diaLimpio)
      })
    } else {
      selectedDiasPaquete.value = []
    }

    // Cargar productos vinculados a la promoción
    try {
      const resProdPromo = await fetchConToken('/promociones/productos/mostrar')
      if (resProdPromo.datos) {
        const productosPromo = resProdPromo.datos.filter((pp: any) => pp.id_promocion === promoId)
        promoProductosSeleccionados.value = productosPromo.map((pp: any) => pp.id_producto)
        
        // Determinar el ámbito
        if (productosPromo.length > 0) {
          promoScope.value = 'productos'
        }
      }
    } catch (e) {
      console.error('Error al cargar productos de promoción', e)
    }

    // Cargar paquetes vinculados a la promoción
    try {
      const resPaqPromo = await fetchConToken('/promociones/paquetes/mostrar')
      if (resPaqPromo.datos) {
        const paquetesPromo = resPaqPromo.datos.filter((pp: any) => pp.id_promocion === promoId)
        promoPaquetesSeleccionados.value = paquetesPromo.map((pp: any) => pp.id_paquete)
        
        if (paquetesPromo.length > 0) {
          promoAplicarPaquetes.value = true
        }
      }
    } catch (e) {
      console.error('Error al cargar paquetes de promoción', e)
    }

    // Cargar clientes vinculados a la promoción
    try {
      const resCliPromo = await fetchConToken('/promociones/clientes/mostrar')
      if (resCliPromo.datos) {
        const clientesPromo = resCliPromo.datos.filter((cp: any) => cp.id_promocion === promoId)
        selectedClientes.value = clientesPromo.map((cp: any) => cp.id_cliente)
      }
    } catch (e) {
      console.error('Error al cargar clientes de promoción', e)
    }
  }

  showModal.value = true
}

// ── LÓGICA DE DESACTIVAR Y REACTIVAR ─────────────────────────────────────────
const handleDelete = async (type: string, id: number | string) => {
  if (!confirm(`¿Estás seguro de desactivar este ${type}?`)) return

  let endpoint = ''
  let localUpdate: ((id: number | string) => void) | null = null

  if (type === 'producto') { endpoint = `/productos/desactivar/${id}`; localUpdate = (id) => { const idx = productos.value.findIndex(p => p.id_producto === id); if (idx !== -1) productos.value[idx]._activo = false } }
  else if (type === 'ingrediente') { endpoint = `/productos/ingrediente/desactivar/${id}`; localUpdate = (id) => { const idx = ingredientes.value.findIndex(i => i.id === id); if (idx !== -1) ingredientes.value[idx]._activo = false } }
  else if (type === 'categoria') { endpoint = `/tienda/categorias/desactivar/${id}`; localUpdate = (id) => { const idx = categorias.value.findIndex(c => c.id_categoria === id); if (idx !== -1) categorias.value[idx]._activo = false } }
  else if (type === 'zona') { endpoint = `/tienda/zonas/desactivar/${id}`; localUpdate = (id) => { const idx = zonas.value.findIndex(z => z.id_zona === id); if (idx !== -1) zonas.value[idx]._activo = false } }
  else if (type === 'menu') { endpoint = `/menu/desactivar/${id}`; localUpdate = (id) => { const idx = menus.value.findIndex(m => m.id_menu === id); if (idx !== -1) menus.value[idx]._activo = false } }
  else if (type === 'paquete') { endpoint = `/paquetes/desactivar/${id}`; localUpdate = (id) => { const idx = paquetes.value.findIndex(p => p.id === id); if (idx !== -1) paquetes.value[idx]._activo = false } }
  else if (type === 'promocion') { endpoint = `/promociones/eliminar/${id}`; localUpdate = (id) => { const idx = promociones.value.findIndex(p => p.id_promocion === id); if (idx !== -1) promociones.value[idx]._activo = false } }

  const res = await fetchConToken(endpoint, 'DELETE')
  if (res.status === 'ok') {
    showToast(`${type} desactivado correctamente`, 'success')
    if (localUpdate) localUpdate(id)
  } else {
    showToast(res.mensaje || 'Error al desactivar', 'error')
  }
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
  else if (type === 'categoria') {
    endpoint = `/tienda/categorias/modificar/${item.id_categoria}`
    payload = { activo: true }
    reloadFn = loadCategorias
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
  else if (type === 'promocion') {
    const promoId = item.id_promocion || item.id
    endpoint = `/promociones/modificar/${promoId}`
    payload = { activo: true }
    reloadFn = loadPromociones
  }

  const res = await fetchConToken(endpoint, 'PUT', payload)
  if (res.status === 'ok' || res.status === 200) {
    showToast(`${type} reactivado correctamente`, 'success')
    reloadFn()
  } else {
    showToast(res.mensaje || 'Error al reactivar', 'error')
  }
}
// ── ENVÍO DE FORMULARIOS ─────────────────────────────────────────────────────
const closeModal = () => {
  showModal.value = false
  formData.value = {}
  paqueteGrupos.value = []
  promoGrupos.value = []
  promoProductosSeleccionados.value = []
  promoPaquetesSeleccionados.value = []
  selectedClientes.value = []
  promoBusquedaCliente.value = ''
  promoAplicarPaquetes.value = false
  promoScope.value = 'productos'
  promoCategoriasSeleccionadas.value = []
  promoCategoriaFiltro.value = ''
}

const handleSubmit = async () => {
  if (formData.value.precio !== undefined && formData.value.precio < 0) {
    showToast('El precio no puede ser negativo', 'error')
    return
  }

  if (!formData.value.nombre || formData.value.nombre.trim() === '') {
    showToast('El nombre es obligatorio', 'error')
    return
  }

  if (modalType.value === 'paquete') {
    for (const grupo of paqueteGrupos.value) {
      if (!grupo.nombre.trim()) {
        showToast('Todos los grupos deben tener nombre', 'error')
        return
      }
      if (grupo.productos.length === 0) {
        showToast(`El grupo "${grupo.nombre}" debe tener al menos un producto`, 'error')
        return
      }
    }
  }

  if (modalType.value === 'promocion' && !isEditing.value) {
    if (promoScope.value === 'productos' && promoProductosSeleccionados.value.length === 0) {
      showToast('Selecciona al menos un producto', 'error')
      return
    }
    if (promoScope.value === 'categorias' && promoCategoriasSeleccionadas.value.length === 0) {
      showToast('Selecciona al menos una categoría', 'error')
      return
    }
  }

  isSubmitting.value = true

  if (modalType.value === 'paquete' && !isEditing.value) {
    formData.value.dias_disponibles = selectedDiasPaquete.value.join(', ')
    const res = await fetchConToken('/paquetes/agregar', 'POST', formData.value)
    
    if (res.status === 'ok' || res.status === 201) {
      const idPaquete = res.id_paquete
      
      for (const grupo of paqueteGrupos.value) {
        const grupoRes = await fetchConToken('/paquetes/grupos/agregar', 'POST', {
          id_paquete: idPaquete,
          nombre_grupo: grupo.nombre,
          es_obligatorio: grupo.obligatorio,
          cantidad: grupo.cantidad
        })
        
        if (grupoRes.status === 'ok' || grupoRes.status === 201) {
          const idGrupo = grupoRes.id_paquete_grupo
          
          for (const idProd of grupo.productos) {
            await fetchConToken('/paquetes/grupos-productos/vincular', 'POST', {
              id_grupo: idGrupo,
              id_producto: idProd
            })
          }
        }
      }
      
      showToast('Paquete creado correctamente', 'success')
      closeModal()
      loadPaquetes()
    } else {
      showToast(res.mensaje || 'Error al crear paquete', 'error')
    }
  }

  if (modalType.value === 'promocion' && !isEditing.value) {
    formData.value.dias = selectedDiasPaquete.value.join(', ')
    const promoData = {
      nombre: formData.value.nombre,
      descripcion: formData.value.descripcion || '',
      tipo: formData.value.tipo,
      valor: formData.value.tipo === '2x1' ? 0 : (formData.value.valor || 0),
      es_temporal: formData.value.es_temporal || false,
      fecha_inicio: formData.value.fecha_inicio || null,
      fecha_fin: formData.value.fecha_fin || null,
      hora_inicio: formData.value.hora_inicio || null,
      hora_fin: formData.value.hora_fin || null,
      dias: selectedDiasPaquete.value.length > 0 ? `{${selectedDiasPaquete.value.join(',')}}` : null,
      es_permanente: !formData.value.es_temporal,
      solo_clientes: formData.value.solo_clientes || false
    }
    console.log('Enviando promoción:', promoData)
    const res = await fetchConToken('/promociones/agregar', 'POST', promoData)
    
    if (res.status === 'ok' || res.status === 201) {
      const idPromo = res.id_promocion

      if (promoScope.value === 'productos' && promoProductosSeleccionados.value.length > 0) {
        for (const idProd of promoProductosSeleccionados.value) {
          await fetchConToken('/promociones/productos/vincular', 'POST', {
            id_promocion: idPromo,
            id_producto: idProd
          })
        }
      }

      if (promoScope.value === 'categorias' && promoCategoriasSeleccionadas.value.length > 0) {
        const productosPorCategoria = productosDisponibles.value.filter((p: any) => 
          promoCategoriasSeleccionadas.value.includes(p.categoria)
        )
        for (const prod of productosPorCategoria) {
          await fetchConToken('/promociones/productos/vincular', 'POST', {
            id_promocion: idPromo,
            id_producto: prod.id_producto
          })
        }
      }

      if (promoAplicarPaquetes.value && promoPaquetesSeleccionados.value.length > 0) {
        for (const idPaq of promoPaquetesSeleccionados.value) {
          await fetchConToken('/promociones/paquetes/vincular', 'POST', {
            id_promocion: idPromo,
            id_paquete: idPaq
          })
        }
      }

      if (promoGrupos.value.length > 0) {
        for (const grupo of promoGrupos.value) {
          const grupoRes = await fetchConToken('/paquetes/grupos/agregar', 'POST', {
            id_paquete: idPromo,
            nombre_grupo: grupo.nombre,
            es_obligatorio: grupo.obligatorio,
            cantidad: grupo.cantidad
          })
          
          if (grupoRes.status === 'ok' || grupoRes.status === 201) {
            const idGrupo = grupoRes.id_paquete_grupo
            
            for (const idProd of grupo.productos) {
              await fetchConToken('/paquetes/grupos-productos/vincular', 'POST', {
                id_grupo: idGrupo,
                id_producto: idProd
              })
            }
          }
        }
      }

      if (formData.value.solo_clientes && selectedClientes.value.length > 0) {
        for (const idCli of selectedClientes.value) {
          await fetchConToken('/promociones/clientes/vincular', 'POST', {
            id_promocion: idPromo,
            id_cliente: idCli
          })
        }
      }
      
      showToast('Promoción creada correctamente', 'success')
      
      promociones.value.unshift({
        id_promocion: idPromo,
        nombre: promoData.nombre,
        nombre_promocion: promoData.nombre,
        descripcion: promoData.descripcion,
        tipo: promoData.tipo,
        valor: promoData.valor,
        dias: promoData.dias,
        es_temporal: promoData.es_temporal,
        es_permanente: promoData.es_permanente,
        solo_clientes: promoData.solo_clientes,
        activo: true,
        _activo: true
      })
      
      closeModal()
    } else {
      showToast(res.mensaje || 'Error al crear promoción', 'error')
    }
  } else {
    let endpoint = ''
    const method = isEditing.value ? 'PUT' : 'POST'
    let reloadFn: Function = () => {}

    if (modalType.value === 'ingrediente' && !isEditing.value) {
      formData.value.tipo = 'opcional'
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
      case 'categoria':
        endpoint = isEditing.value ? `/tienda/categorias/modificar/${editingId.value}` : '/tienda/categorias/agregar'
        reloadFn = loadCategorias
        break
      case 'zona':
        endpoint = isEditing.value ? `/tienda/zonas/modificar/${editingId.value}` : '/tienda/zonas/agregar'
        reloadFn = loadMenusYZonas
        break
      case 'menu':
        endpoint = isEditing.value ? `/menu/modificar/${editingId.value}` : '/menu/agregar'
        reloadFn = loadMenusYZonas
        formData.value.dias_semana = selectedDias.value.join(', ')
        break
      case 'paquete':
        endpoint = isEditing.value ? `/paquetes/actualizar/${editingId.value}` : '/paquetes/agregar'
        formData.value.dias_disponibles = selectedDiasPaquete.value.join(', ')
        reloadFn = loadPaquetes
        break
      case 'promocion':
        endpoint = isEditing.value ? `/promociones/modificar/${editingId.value}` : '/promociones/agregar'
        formData.value.dias = selectedDiasPaquete.value.length > 0 ? `{${selectedDiasPaquete.value.join(',')}}` : null
        formData.value.es_permanente = !formData.value.es_temporal
        reloadFn = loadPromociones
        break
    }

    const res = await fetchConToken(endpoint, method, formData.value)

    if (res.status === 'ok' || res.status === 201) {
      // Si es edición de producto, actualizar los ingredientes
      if (modalType.value === 'producto' && isEditing.value && editingId.value) {
        try {
          // Obtener ingredientes actuales del producto
          const resIngActual = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${editingId.value}`)
          const ingredientesActuales = resIngActual.datos ? resIngActual.datos.map((pi: any) => pi.id_ingrediente || pi.id || pi.id_producto_ingrediente) : []
          
          // Desvincular ingredientes que ya no están seleccionados
          for (const idIng of ingredientesActuales) {
            if (!selectedIngredients.value.includes(idIng)) {
              // Buscar el id de la relación para desvincular
              const rel = resIngActual.datos.find((pi: any) => (pi.id_ingrediente || pi.id || pi.id_producto_ingrediente) === idIng)
              if (rel && rel.id_producto_ingrediente) {
                await fetchConToken(`/productos/producto-ingrediente/desvincular/${rel.id_producto_ingrediente}`, 'DELETE')
              }
            }
          }
          
          // Vincular nuevos ingredientes seleccionados
          for (const idIng of selectedIngredients.value) {
            if (!ingredientesActuales.includes(idIng)) {
              await fetchConToken('/productos/producto-ingrediente/vincular', 'POST', {
                id_producto: editingId.value,
                id_ingrediente: idIng,
                es_obligatorio: false,
                precio: 0
              })
            }
          }
        } catch (e) {
          console.error('Error al actualizar ingredientes', e)
        }
      }
      
      // Si es edición de promoción, actualizar los datos relacionados
      if (modalType.value === 'promocion' && isEditing.value && editingId.value) {
        try {
          // Actualizar productos vinculados
          const resProdActual = await fetchConToken('/promociones/productos/mostrar')
          const productosActuales = resProdActual.datos 
            ? resProdActual.datos.filter((pp: any) => pp.id_promocion === editingId.value).map((pp: any) => pp.id_producto)
            : []
          
          // Desvincular productos que ya no están seleccionados
          for (const idProd of productosActuales) {
            if (!promoProductosSeleccionados.value.includes(idProd)) {
              await fetchConToken('/promociones/productos/desvincular', 'POST', {
                id_promocion: editingId.value,
                id_producto: idProd
              })
            }
          }
          // Vincular nuevos productos
          for (const idProd of promoProductosSeleccionados.value) {
            if (!productosActuales.includes(idProd)) {
              await fetchConToken('/promociones/productos/vincular', 'POST', {
                id_promocion: editingId.value,
                id_producto: idProd
              })
            }
          }
          
          // Actualizar paquetes vinculados
          const resPaqActual = await fetchConToken('/promociones/paquetes/mostrar')
          const paquetesActuales = resPaqActual.datos 
            ? resPaqActual.datos.filter((pp: any) => pp.id_promocion === editingId.value).map((pp: any) => pp.id_paquete)
            : []
          
          for (const idPaq of paquetesActuales) {
            if (!promoPaquetesSeleccionados.value.includes(idPaq)) {
              await fetchConToken('/promociones/paquetes/desvincular', 'POST', {
                id_promocion: editingId.value,
                id_paquete: idPaq
              })
            }
          }
          for (const idPaq of promoPaquetesSeleccionados.value) {
            if (!paquetesActuales.includes(idPaq)) {
              await fetchConToken('/promociones/paquetes/vincular', 'POST', {
                id_promocion: editingId.value,
                id_paquete: idPaq
              })
            }
          }
          
          // Actualizar clientes vinculados
          const resCliActual = await fetchConToken('/promociones/clientes/mostrar')
          const clientesActuales = resCliActual.datos 
            ? resCliActual.datos.filter((cp: any) => cp.id_promocion === editingId.value).map((cp: any) => cp.id_cliente)
            : []
          
          for (const idCli of clientesActuales) {
            if (!selectedClientes.value.includes(idCli)) {
              await fetchConToken('/promociones/clientes/desvincular', 'POST', {
                id_promocion: editingId.value,
                id_cliente: idCli
              })
            }
          }
          for (const idCli of selectedClientes.value) {
            if (!clientesActuales.includes(idCli)) {
              await fetchConToken('/promociones/clientes/vincular', 'POST', {
                id_promocion: editingId.value,
                id_cliente: idCli
              })
            }
          }
        } catch (e) {
          console.error('Error al actualizar datos de promoción', e)
        }
      }
      
      // Si es edición de paquete, actualizar los grupos
      if (modalType.value === 'paquete' && isEditing.value && editingId.value) {
        try {
          // Obtener grupos actuales del paquete
          const resGruposActuales = await fetchConToken(`/paquetes/grupo/mostrar/${editingId.value}`)
          const gruposActuales = resGruposActuales.datos || []
          
          // Desvincular grupos que ya no existen
          for (const grupo of gruposActuales) {
            // Desvincular productos del grupo
            // Primero obtener los productos del grupo usando menu-completo
            const resMenu = await fetchConToken('/paquetes/menu-completo')
            const pkgData = resMenu.datos.find((p: any) => p.id_paquete === editingId.value)
            if (pkgData && pkgData.grupos) {
              const grpData = pkgData.grupos.find((g: any) => g.id_paquete_grupo === grupo.id_paquete_grupo)
              if (grpData && grpData.productos) {
                for (const prod of grpData.productos) {
                  await fetchConToken('/paquetes/grupos-productos/desvincular', 'DELETE', {
                    id_grupo: grupo.id_paquete_grupo,
                    id_producto: prod.id_producto
                  })
                }
              }
            }
            // Desactivar el grupo
            await fetchConToken(`/paquetes/grupos/desactivar/${grupo.id_paquete_grupo}`, 'DELETE')
          }
          
          // Crear los nuevos grupos
          for (const grupo of paqueteGrupos.value) {
            const grupoRes = await fetchConToken('/paquetes/grupos/agregar', 'POST', {
              id_paquete: editingId.value,
              nombre_grupo: grupo.nombre,
              es_obligatorio: grupo.obligatorio,
              cantidad: grupo.cantidad
            })
            
            if (grupoRes.status === 'ok' || grupoRes.status === 201) {
              const idGrupo = grupoRes.id_paquete_grupo
              for (const idProd of grupo.productos) {
                await fetchConToken('/paquetes/grupos-productos/vincular', 'POST', {
                  id_grupo: idGrupo,
                  id_producto: idProd
                })
              }
            }
          }
        } catch (e) {
          console.error('Error al actualizar grupos del paquete', e)
        }
      }
      
      showToast('Guardado correctamente', 'success')
      closeModal()
      reloadFn()
    } else {
      showToast(res.mensaje || 'Error al guardar', 'error')
    }
  }

  isSubmitting.value = false
}

// ── FILTROS COMPUTADOS ───────────────────────────────────────────────────────
const term = computed(() => cleanText(searchQuery.value))

const filteredProductos = computed(() => {
  return productos.value.filter(p => {
    const desc = p.descripcion_pro || p.descripcion || ''
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

const filteredCategorias = computed(() => {
  return categorias.value.filter(c => {
    const nombreCat = c.nombre_cat || c.nombre || ''
    const matchSearch = cleanText(nombreCat).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? c._activo : !c._activo)
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

const getProductosPorCategoria = (categoria: string) => {
  if (!categoria) return productosDisponibles.value
  return productosDisponibles.value.filter(p => p.categoria === categoria)
}

const filteredPaquetes = computed(() => {
  return paquetes.value.filter(p => {
    const matchSearch = cleanText(p.paquete).includes(term.value) || cleanText(p.descripcion || p.descripción || '').includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? p._activo : !p._activo)
    return matchSearch && matchStatus
  })
})

const filteredPromociones = computed(() => {
  return promociones.value.filter(p => {
    const nombre = p.nombre_promocion || p.nombre || p.promocion || ''
    const desc = p.descripcion || p.descripcion_promocion || ''
    const matchSearch = cleanText(nombre).includes(term.value) || cleanText(desc).includes(term.value)
    const matchStatus = statusFilter.value === 'todos' ? true : (statusFilter.value === 'activos' ? p._activo : !p._activo)
    return matchSearch && matchStatus
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

        
      </div>

      <div v-if="canManage" class="actions-group">
        <button v-if="activeTab === 'productos'" @click="openAddModal('producto')" class="btn-primary">+ Nuevo Producto</button>
        <button v-if="activeTab === 'ingredientes'" @click="openAddModal('ingrediente')" class="btn-primary">+ Nuevo Ingrediente</button>
        <button v-if="activeTab === 'categorias'" @click="openAddModal('categoria')" class="btn-primary">+ Nueva Categoría</button>
        <div v-if="activeTab === 'menus_zonas'" style="display:flex; gap:8px;">
          <button @click="openAddModal('zona')" class="btn-primary">+ Nueva Zona</button>
          <button @click="openAddModal('menu')" class="btn-primary">+ Nuevo Menú</button>
        </div>
        <div v-if="activeTab === 'paquetes'" style="display:flex; gap:8px;">
          <button @click="openAddModal('paquete')" class="btn-primary">+ Nuevo Paquete</button>
          <button @click="openAddModal('promocion')" class="btn-primary">+ Nueva Promoción</button>
        </div>
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

      <div v-show="activeTab === 'categorias' && !isLoading" class="grid-container">
        <div v-if="filteredCategorias.length === 0" class="empty-state">No se encontraron categorías.</div>
        <div v-for="item in filteredCategorias" :key="item.id_categoria" :class="['card', { 'inactive-card': !item._activo }]">
          <div class="card-header">
            <h3 class="card-title">{{ item.nombre_cat || item.nombre }}</h3>
          </div>
          <p class="card-desc">{{ item.descripcion_cat || item.descripcion || 'Sin descripción' }}</p>
          <div class="card-footer mt-auto">
            <div class="badges-container">
              <span :class="['badge', item._activo ? 'success' : 'danger']">{{ item._activo ? 'Activa' : 'Inactiva' }}</span>
            </div>
            
            <div v-if="canManage" class="actions-container">
              <template v-if="item._activo">
                <button @click="handleEdit('categoria', item)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                <button @click="handleDelete('categoria', item.id_categoria)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
              </template>
              <template v-else>
                <button @click="handleReactivate('categoria', item)" class="action-btn reactivate-btn" title="Reactivar">
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

      <div v-show="activeTab === 'paquetes' && !isLoading" class="split-section">
        <section class="sub-section">
          <h2 class="section-title">Paquetes</h2>
          <div class="grid-container">
            <div v-if="filteredPaquetes.length === 0" class="empty-state">No se encontraron paquetes.</div>
            <div v-for="paquete in filteredPaquetes" :key="paquete.id" :class="['card', { 'inactive-card': !paquete._activo }]">
              <div class="card-header">
                <h3 class="card-title">{{ paquete.paquete }}</h3>
                <span class="card-price">${{ paquete.precio }}</span>
              </div>
              <p class="card-desc">{{ paquete.descripcion || paquete.descripción || 'Sin descripción' }}</p>
              <div class="card-footer mt-auto">
                <div class="badges-container">
                  <span v-if="paquete.tipo" class="badge">{{ paquete.tipo }}</span>
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
        </section>

        <section class="sub-section mt-4">
          <h2 class="section-title">Promociones</h2>
          <div class="grid-container">
            <div v-if="filteredPromociones.length === 0" class="empty-state">No se encontraron promociones.</div>
            <div v-for="promo in filteredPromociones" :key="promo.id_promocion || promo.id" :class="['card', { 'inactive-card': !promo._activo }]">
              <div class="card-header">
                <h3 class="card-title">{{ promo.nombre_promocion || promo.nombre || promo.promocion }}</h3>
                <span v-if="promo.valor" class="card-price">{{ promo.tipo === 'porcentaje' ? `${promo.valor}%` : `$${promo.valor}` }}</span>
              </div>
              <p class="card-desc">{{ promo.descripcion || promo.descripcion_promocion || 'Sin descripción' }}</p>
              <div class="card-footer mt-auto">
                <div class="badges-container">
                  <span v-if="promo.tipo" class="badge">{{ promo.tipo }}</span>
                  <span v-if="promo.dias" class="badge warning">{{ promo.dias }}</span>
                  <span v-if="promo.es_temporal" class="badge">Temporal</span>
                  <span v-if="promo.es_permanente" class="badge success">Permanente</span>
                  <span v-if="!promo._activo" class="badge danger">Inactiva</span>
                </div>
                
                <div v-if="canManage" class="actions-container">
                  <template v-if="promo._activo">
                    <button @click="handleEdit('promocion', promo)" class="action-btn edit-btn" title="Editar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                    <button @click="handleDelete('promocion', promo.id_promocion || promo.id)" class="action-btn delete-btn" title="Desactivar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                  </template>
                  <template v-else>
                    <button @click="handleReactivate('promocion', promo)" class="action-btn reactivate-btn" title="Reactivar">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                    </button>
                  </template>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </main>

    <!-- Toast Notifications -->
    <div class="toast-container">
      <div v-for="toast in toasts" :key="toast.id" :class="['toast', toast.type]">
        <span v-if="toast.type === 'success'">&#10003;</span>
        <span v-else-if="toast.type === 'error'">&#10007;</span>
        <span v-else>&#9888;</span>
        {{ toast.message }}
      </div>
    </div>

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

          <template v-if="modalType === 'categoria'">
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
              <input v-model="formData.url_imagen" type="text" class="form-input" placeholder="https://..." />
              <div v-if="formData.url_imagen" class="img-preview">
                <img :src="formData.url_imagen" alt="Preview" @error="formData.url_imagen = ''" />
              </div>
            </div>
            <div v-if="ingredientesDisponibles.length > 0" class="form-group">
              <label>Ingredientes/Modificadores:</label>
              <div class="ingredients-grid">
                <label v-for="ing in ingredientesDisponibles" :key="ing.id" class="ingredient-checkbox">
                  <input type="checkbox" :value="ing.id" v-model="selectedIngredients" />
                  <span class="ing-nombre">{{ ing.ingrediente }}</span>
                  <span v-if="ing.precio > 0" class="ing-precio">+${{ ing.precio }}</span>
                </label>
              </div>
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
              <label>Días de la semana:</label>
              <div class="dias-semana-container">
                <label v-for="dia in diasSemana" :key="dia.valor" class="dia-checkbox">
                  <input type="checkbox" :value="dia.valor" v-model="selectedDias" />
                  <span>{{ dia.label }}</span>
                </label>
              </div>
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
              <div class="dias-semana-container">
                <label v-for="dia in diasSemana" :key="dia.valor" class="dia-checkbox">
                  <input type="checkbox" :value="dia.valor" v-model="selectedDiasPaquete" />
                  <span>{{ dia.label }}</span>
                </label>
              </div>
            </div>

            <div class="grupos-paquete">
              <div class="grupos-header">
                <label>Grupos de Selección (Opciones)</label>
                <button type="button" @click="addGrupo" class="btn-add-group">+ Agregar Grupo</button>
              </div>

              <div v-for="(grupo, gIndex) in paqueteGrupos" :key="gIndex" class="grupo-item">
                <div class="grupo-header">
                  <input v-model="grupo.nombre" type="text" class="form-input" placeholder="Nombre del grupo (ej: Bebida)" />
                  <button type="button" @click="removeGrupo(gIndex)" class="btn-remove-group">✕</button>
                </div>
                <div class="grupo-opts">
                  <label class="checkbox-label">
                    <input type="checkbox" v-model="grupo.obligatorio" />
                    Obligatorio
                  </label>
                  <label class="checkbox-label">
                    Cantidad:
                    <input type="number" v-model.number="grupo.cantidad" min="1" max="10" class="input-cantidad" />
                  </label>
                </div>
                <div class="productos-grupo">
                  <div class="productos-filtro">
                    <label>Filtrar por categoría:</label>
                    <select v-model="grupo.categoriaFiltro" class="form-select" style="width: auto; min-width: 150px;">
                      <option value="">Todas las categorías</option>
                      <option v-for="cat in categoriasUnicas" :key="cat" :value="cat">{{ cat }}</option>
                    </select>
                  </div>
                  <div class="productos-list">
                    <label v-for="prod in getProductosPorCategoria(grupo.categoriaFiltro)" :key="prod.id_producto" class="producto-option">
                      <input type="checkbox" :value="prod.id_producto" v-model="grupo.productos" />
                      <span>{{ prod.nombre_producto }}</span>
                      <span class="prod-cat">({{ prod.categoria }})</span>
                    </label>
                  </div>
                </div>
              </div>
            </div>
          </template>

          <template v-if="modalType === 'promocion'">
            <div class="form-group">
              <label>Descripción:</label>
              <textarea v-model="formData.descripcion" class="form-input"></textarea>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Tipo de Promoción:</label>
                <select v-model="formData.tipo" required class="form-select">
                  <option disabled value="">Selecciona...</option>
                  <option value="descuento">Descuento (%)</option>
                  <option value="2x1">2x1</option>
                  <option value="fijo">Precio Fijo</option>
                  <option value="otro">Otro</option>
                </select>
              </div>
              <div class="form-group">
                <label>Valor{{ formData.tipo === '2x1' ? ' (opcional para 2x1)' : '' }}:</label>
                <input v-model.number="formData.valor" type="number" step="0.1" min="0" class="form-input" :placeholder="formData.tipo === '2x1' ? 'No requerido para 2x1' : 'Porcentaje o monto'" :disabled="formData.tipo === '2x1'" />
              </div>
            </div>

            <!-- Ámbito de aplicación -->
            <div class="form-group">
              <label>Ámbito de aplicación:</label>
              <div class="scope-options">
                <label class="radio-label">
                  <input type="radio" v-model="promoScope" value="productos" />
                  Productos específicos
                </label>
                <label class="radio-label">
                  <input type="radio" v-model="promoScope" value="categorias" />
                  Por categorías
                </label>
              </div>
            </div>

            <!-- Selector de productos específicos -->
            <div v-if="promoScope === 'productos'" class="productos-grupo">
              <div class="productos-filtro">
                <label>Filtrar por categoría:</label>
                <select v-model="promoCategoriaFiltro" class="form-select" style="width: auto; min-width: 150px;">
                  <option value="">Todas las categorías</option>
                  <option v-for="cat in categoriasUnicas" :key="cat" :value="cat">{{ cat }}</option>
                </select>
              </div>
              <div class="productos-list">
                <label v-for="prod in getPromoProductosFiltrados(promoCategoriaFiltro)" :key="prod.id_producto" class="producto-option">
                  <input type="checkbox" :value="prod.id_producto" v-model="promoProductosSeleccionados" />
                  <span>{{ prod.nombre_producto }}</span>
                  <span class="prod-cat">({{ prod.categoria }})</span>
                </label>
              </div>
            </div>

            <!-- Selector de categorías -->
            <div v-if="promoScope === 'categorias'" class="form-group">
              <label>Selecciona categorías:</label>
              <div class="categorias-selector">
                <label v-for="cat in categoriasUnicas" :key="cat" class="categoria-checkbox">
                  <input type="checkbox" :value="cat" v-model="promoCategoriasSeleccionadas" />
                  <span>{{ cat }}</span>
                </label>
              </div>
            </div>

            <!-- Aplicar a paquetes -->
            <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: 12px;">
              <input v-model="promoAplicarPaquetes" type="checkbox" id="promoPaquetesCheck" />
              <label for="promoPaquetesCheck" style="margin:0; cursor:pointer;">Aplicar también a paquetes</label>
            </div>

            <div v-if="promoAplicarPaquetes && paquetesActivos.length > 0" class="productos-grupo">
              <label style="display: block; font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); margin-bottom: var(--espacio-1, 4px);">Selecciona paquetes:</label>
              <div class="productos-list">
                <label v-for="paq in paquetesActivos" :key="paq.id" class="producto-option">
                  <input type="checkbox" :value="paq.id" v-model="promoPaquetesSeleccionados" />
                  <span>{{ paq.paquete || paq.nombre }}</span>
                </label>
              </div>
            </div>
            <div v-else-if="promoAplicarPaquetes" class="empty-state" style="padding: 8px; font-size: 12px;">No hay paquetes activos disponibles</div>

            <!-- Temporal -->
            <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: 12px;">
              <input v-model="formData.es_temporal" type="checkbox" id="promoTempCheck" />
              <label for="promoTempCheck" style="margin:0; cursor:pointer;">¿Es Temporal?</label>
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

            <!-- Días -->
            <div class="form-group">
              <label>Días disponibles:</label>
              <div class="dias-semana-container">
                <label v-for="dia in diasSemana" :key="dia.valor" class="dia-checkbox">
                  <input type="checkbox" :value="dia.valor" v-model="selectedDiasPaquete" />
                  <span>{{ dia.label }}</span>
                </label>
              </div>
            </div>

            <!-- Horario -->
            <div class="form-row">
              <div class="form-group">
                <label>Hora Inicio (Opcional):</label>
                <input v-model="formData.hora_inicio" type="time" class="form-input" />
              </div>
              <div class="form-group">
                <label>Hora Fin (Opcional):</label>
                <input v-model="formData.hora_fin" type="time" class="form-input" />
              </div>
            </div>

            <!-- Solo clientes -->
            <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: 12px;">
              <input v-model="formData.solo_clientes" type="checkbox" id="soloClientesCheck" />
              <label for="soloClientesCheck" style="margin:0; cursor:pointer;">¿Solo para clientes registrados?</label>
            </div>

            <!-- Selector de clientes -->
            <div v-if="formData.solo_clientes" class="clientes-selector">
              <div class="form-group">
                <label>Buscar clientes:</label>
                <input v-model="promoBusquedaCliente" type="text" class="form-input" placeholder="Escribe el nombre o correo..." />
              </div>
              <div v-if="filteredClientes.length > 0" class="clientes-list">
                <label v-for="cli in filteredClientes.slice(0, 10)" :key="cli.id_cliente || cli.id" class="cliente-option">
                  <input type="checkbox" :value="cli.id_cliente || cli.id" v-model="selectedClientes" />
                  <span>{{ cli.nombre_cliente || cli.nombre }}</span>
                  <span class="cli-email">{{ cli.correo || cli.email }}</span>
                </label>
              </div>
              <div v-if="filteredClientes.length > 10" class="more-info">
                + {{ filteredClientes.length - 10 }} más resultados
              </div>
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

/* ── DÍAS DE LA SEMANA CHECKBOXES ── */
.dias-semana-container { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 4px; }
.dia-checkbox { display: flex; align-items: center; gap: 4px; cursor: pointer; font-size: 13px; }
.dia-checkbox input { accent-color: var(--tenant-primario, #002D72); }

/* ── INGREDIENTES CHECKBOXES ── */
.ingredients-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 4px; }
.ingredient-checkbox { display: flex; align-items: center; gap: 6px; padding: 6px 10px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; cursor: pointer; font-size: 13px; transition: background 0.2s; }
.ingredient-checkbox:hover { background: var(--color-superficie-alt, #f3f4f6); }
.ingredient-checkbox input { accent-color: var(--tenant-primario, #002D72); }
.ing-nombre { font-weight: 500; }
.ing-precio { color: var(--color-exitoso, #16a34a); font-size: 12px; }

/* ── IMAGEN PREVIEW ── */
.img-preview { margin-top: 8px; }
.img-preview img { max-width: 150px; max-height: 100px; border-radius: 6px; border: 1px solid var(--color-borde, #e5e7eb); }

/* ── GRUPOS DE PAQUETE ── */
.grupos-paquete { border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; padding: var(--espacio-3, 12px); background: var(--color-superficie-alt, #f3f4f6); }
.grupos-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--espacio-3, 12px); }
.grupos-header label { font-size: var(--font-size-sm, 13px); font-weight: 600; color: var(--tenant-texto, #111827); }
.btn-add-group { background: var(--tenant-primario, #002D72); color: white; border: none; padding: 4px 12px; border-radius: 4px; font-size: var(--font-size-xs, 11px); cursor: pointer; }
.grupo-item { border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; padding: var(--espacio-3, 12px); margin-bottom: var(--espacio-2, 8px); background: var(--color-superficie, #ffffff); }
.grupo-header { display: flex; gap: var(--espacio-2, 8px); align-items: center; margin-bottom: var(--espacio-2, 8px); }
.grupo-header .form-input { flex: 1; }
.btn-remove-group { background: transparent; border: 1px solid var(--color-cancelar, #ef4444); color: var(--color-cancelar, #ef4444); border-radius: 4px; width: 24px; height: 24px; cursor: pointer; font-size: 12px; }
.grupo-opts { display: flex; gap: var(--espacio-4, 16px); margin-bottom: var(--espacio-2, 8px); }
.checkbox-label { display: flex; align-items: center; gap: 4px; font-size: var(--font-size-sm, 13px); cursor: pointer; }
.input-cantidad { width: 50px; padding: 2px 6px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 4px; font-size: var(--font-size-sm, 13px); }
.productos-grupo label { display: block; font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); margin-bottom: var(--espacio-1, 4px); }
.productos-list { display: flex; flex-wrap: wrap; gap: var(--espacio-1, 4px); max-height: 100px; overflow-y: auto; }
.producto-option { display: flex; align-items: center; gap: 4px; padding: 2px 8px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 4px; font-size: var(--font-size-xs, 11px); cursor: pointer; background: var(--color-superficie, #ffffff); }
.producto-option:hover { background: var(--color-superficie-alt, #f3f4f6); }
.producto-option input { accent-color: var(--tenant-primario, #002D72); }
.prod-cat { color: var(--tenant-texto-muted, #6b7280); font-size: 10px; }
.productos-filtro { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.productos-filtro label { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); }

/* ── TOAST NOTIFICATIONS ── */
.toast-container { position: fixed; top: 20px; right: 20px; z-index: 2000; display: flex; flex-direction: column; gap: 8px; }
.toast { padding: 12px 20px; border-radius: 8px; font-size: 14px; font-weight: 500; box-shadow: 0 4px 12px rgba(0,0,0,0.15); animation: slideIn 0.3s ease; display: flex; align-items: center; gap: 8px; }
.toast.success { background: #dcfce7; color: #166534; border: 1px solid #86efac; }
.toast.error { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
.toast.warning { background: #fef3c7; color: #92400e; border: 1px solid #fcd34d; }
@keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

/* ── PROMOCIONES ── */
.scope-options { display: flex; gap: 16px; flex-wrap: wrap; margin-top: 4px; }
.radio-label { display: flex; align-items: center; gap: 6px; font-size: var(--font-size-sm, 13px); cursor: pointer; }
.radio-label input { accent-color: var(--tenant-primario, #002D72); }
.clientes-selector { border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; padding: var(--espacio-3, 12px); background: var(--color-superficie-alt, #f3f4f6); }
.clientes-list { display: flex; flex-direction: column; gap: 4px; max-height: 150px; overflow-y: auto; margin-top: 8px; }
.cliente-option { display: flex; align-items: center; gap: 8px; padding: 4px 8px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 4px; font-size: var(--font-size-sm, 13px); cursor: pointer; background: var(--color-superficie, #ffffff); }
.cliente-option:hover { background: var(--color-superficie-alt, #f3f4f6); }
.cliente-option input { accent-color: var(--tenant-primario, #002D72); }
.cli-email { color: var(--tenant-texto-muted, #6b7280); font-size: var(--font-size-xs, 11px); }
.more-info { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); margin-top: 4px; font-style: italic; }
.categorias-selector { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
.categoria-checkbox { display: flex; align-items: center; gap: 6px; padding: 6px 12px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; font-size: var(--font-size-sm, 13px); cursor: pointer; background: var(--color-superficie, #ffffff); }
.categoria-checkbox:hover { background: var(--color-superficie-alt, #f3f4f6); }
.categoria-checkbox input { accent-color: var(--tenant-primario, #002D72); }
</style>