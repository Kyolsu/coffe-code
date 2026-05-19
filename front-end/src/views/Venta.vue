<script setup lang="ts">
import { ref, computed, onMounted, nextTick, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import API_URL from '../config/api'

const router = useRouter()
const authStore = useAuthStore()
const API_BASE = `${API_URL}/api`

// ── TIPOS ──────────────────────────────────────────────
interface Categoria {
  id_categoria: number
  nombre_cat: string
}

interface Producto {
  id_producto: number
  nombre_producto: string
  precio_base: number
  categoria: string
  url_imagen: string
}

interface Cliente {
  id_cliente: number
  nombre: string
}

interface IngredienteOpcion {
  id_producto_ingrediente: number
  id_ingrediente: number
  nombre_ingrediente: string
  es_obligatorio: boolean
  precio_modificador: number
  activo: boolean
  seleccionado?: boolean
}

interface PaqueteProducto {
  id_producto: number
  nombre_producto: string
  precio_adicional: number
}

interface PaqueteGrupo {
  id_grupo: number
  nombre_grupo: string
  es_obligatorio: boolean
  cantidad_minima: number
  cantidad_maxima: number
  productos: PaqueteProducto[]
}

interface Paquete {
  id_paquete: number
  nombre_paquete: string
  precio: number
  descripcion: string
  url_imagen: string
  grupos: PaqueteGrupo[]
}

interface Promocion {
  id_promocion: number
  nombre: string
  descripcion: string
  tipo: 'porcentaje' | 'monto' | 'bogo'
  valor: number
  es_temporal: boolean
  activo: boolean
  solo_clientes?: boolean
  hora_inicio?: string | null
  hora_fin?: string | null
  dias?: string | null
  dias_aplicables?: string | string[] | null
}

interface Beneficio {
  id_cliente_beneficio: number
  nombre_beneficio: string
  tipo: string
  disponible: number
}

interface ClienteConBeneficios {
  id_cliente: number
  nombre: string
  beneficios: Beneficio[]
}

interface CartItem {
  cartId: number
  productId: number
  name: string
  qty: number
  basePrice: number
  modifiers: IngredienteOpcion[]
  unitTotal: number
  note?: string
  isPackage?: boolean
  packageId?: number
  packageSelections?: { id_grupo: number; id_producto: number; nombre: string }[]
  extraPrice?: number
  categoria?: string
}

// ── ESTADO ─────────────────────────────────────────────
const cart = ref<CartItem[]>([])
const categorias = ref<Categoria[]>([])
const allProducts = ref<Producto[]>([])
const activeCategory = ref<string>('Todos')
const searchQuery = ref('')
const isLoading = ref(true)

// Menús y productos por menú activo
const menus = ref<any[]>([])
const productosEnMenusActivos = ref<number[]>([])

const esMenuActivoAhora = (menu: any): boolean => {
  const ahora = new Date()
  const horaActual = ahora.getHours() * 60 + ahora.getMinutes()
  const diaSemana = ahora.getDay()
  
  const diasMap: Record<number, string> = {
    0: 'domingo', 1: 'lunes', 2: 'martes', 3: 'miercoles', 
    4: 'jueves', 5: 'viernes', 6: 'sabado'
  }
  const diaActual = diasMap[diaSemana]
  
  // Verificar horario
  if (menu.hora_inicio && menu.hora_fin) {
    const horaInicio = menu.hora_inicio.toString().split(':')
    const horaFin = menu.hora_fin.toString().split(':')
    const minutosInicio = parseInt(horaInicio[0]) * 60 + parseInt(horaInicio[1] || '0')
    const minutosFin = parseInt(horaFin[0]) * 60 + parseInt(horaFin[1] || '0')
    
    if (horaActual < minutosInicio || horaActual >= minutosFin) {
      return false
    }
  }
  
  // Verificar días de la semana
  if (menu.dias_semana) {
    const diasMenu = menu.dias_semana.toLowerCase().split(',').map((d: string) => d.trim())
    if (!diasMenu.includes(diaActual)) {
      return false
    }
  }
  
  return true
}

// Opciones de Producto
const showOptionsModal = ref(false)
const selectedProductForOptions = ref<Producto | null>(null)
const currentOptions = ref<IngredienteOpcion[]>([])
const isLoadingOptions = ref(false)
const editingCartItemId = ref<number | null>(null)

// Clientes
const clientes = ref<Cliente[]>([])
const selectedClient = ref<Cliente | null>(null)
const showClientModal = ref(false)
const clientSearchQuery = ref('')

// Promociones por item
const itemPromociones = ref<Record<number, { id_promocion: number; nombre: string; tipo: string; valor: number }[]>>({})

// RFID
const rfidListening = ref(false)
const rfidInput = ref('')
const rfidDetectedClient = ref<ClienteConBeneficios | null>(null)
const rfidError = ref('')
const rfidInputRef = ref<HTMLInputElement | null>(null)

// Paquetes
const paquetes = ref<Paquete[]>([])
const paquetesLoading = ref(false)
const showPackageModal = ref(false)
const selectedPackage = ref<Paquete | null>(null)
const packageSelections = ref<Map<number, PaqueteProducto[]>>(new Map())
const packageValidationError = ref('')

// Promociones
const promociones = ref<Promocion[]>([])
const appliedPromociones = ref<{ id_promocion: number; nombre: string; tipo: string; valor: number }[]>([])

// Modal de promoción
const showPromoModal = ref(false)
const selectedPromo = ref<Promocion | null>(null)
const promoProductos = ref<any[]>([])
const promoSelectedProducts = ref<Record<number, number>>({})

const totalPromoSeleccionados = computed(() => {
  return Object.values(promoSelectedProducts.value).reduce((sum, qty) => sum + qty, 0)
})

// Notas
const itemNotes = ref<Record<number, string>>({})
const orderNote = ref('')

// Vista
const activeView = ref<'products' | 'paquetes' | 'promos'>('products')

// Pago
const paymentMethods = ['Efectivo', 'Tarjeta', 'Transferencia']
const selectedPayment = ref('Efectivo')
const showPaymentMenu = ref(false)

// Confirmación de pago
const showConfirmModal = ref(false)
const isProcessingPayment = ref(false)

// Toast
const toastMsg = ref('')
const toastType = ref<'success' | 'warning' | 'error'>('success')
const showToast = ref(false)

// ── PERSISTENCIA ───────────────────────────────────────
const TICKET_KEY = 'ticket_en_proceso'

const saveTicket = () => {
  const data = {
    cart: cart.value,
    selectedClient: selectedClient.value,
    appliedPromociones: appliedPromociones.value,
    orderNote: orderNote.value,
    selectedPayment: selectedPayment.value,
    timestamp: Date.now()
  }
  sessionStorage.setItem(TICKET_KEY, JSON.stringify(data))
}

const loadTicket = () => {
  const saved = sessionStorage.getItem(TICKET_KEY)
  if (saved) {
    try {
      const data = JSON.parse(saved)
      cart.value = data.cart || []
      selectedClient.value = data.selectedClient || null
      appliedPromociones.value = data.appliedPromociones || []
      orderNote.value = data.orderNote || ''
      selectedPayment.value = data.selectedPayment || 'Efectivo'
      return true
    } catch (e) {
      console.error('Error al cargar ticket:', e)
      return false
    }
  }
  return false
}

const clearSavedTicket = () => {
  sessionStorage.removeItem(TICKET_KEY)
}

// ── AUDIO ──────────────────────────────────────────────
let audioContext: AudioContext | null = null

const playSound = (type: 'success' | 'error' | 'added' | 'beep') => {
  try {
    if (!audioContext) audioContext = new (window.AudioContext || (window as any).webkitAudioContext)()
    const ctx = audioContext
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    osc.connect(gain)
    gain.connect(ctx.destination)
    
    const now = ctx.currentTime
    
    if (type === 'success') {
      osc.frequency.setValueAtTime(880, now)
      osc.frequency.setValueAtTime(1100, now + 0.1)
      gain.gain.setValueAtTime(0.3, now)
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.3)
      osc.start(now)
      osc.stop(now + 0.3)
    } else if (type === 'error') {
      osc.frequency.setValueAtTime(200, now)
      osc.frequency.setValueAtTime(150, now + 0.15)
      gain.gain.setValueAtTime(0.3, now)
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.3)
      osc.start(now)
      osc.stop(now + 0.3)
    } else if (type === 'added') {
      osc.frequency.setValueAtTime(600, now)
      gain.gain.setValueAtTime(0.2, now)
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.1)
      osc.start(now)
      osc.stop(now + 0.1)
    } else if (type === 'beep') {
      osc.frequency.setValueAtTime(1200, now)
      gain.gain.setValueAtTime(0.25, now)
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.15)
      osc.start(now)
      osc.stop(now + 0.15)
    }
  } catch (e) { console.log('Audio not supported') }
}

// ── TOAST ──────────────────────────────────────────────
const displayToast = (msg: string, type: 'success' | 'warning' | 'error' = 'success') => {
  toastMsg.value = msg
  toastType.value = type
  showToast.value = true
  setTimeout(() => showToast.value = false, 3000)
}

// ── FETCH DATOS ────────────────────────────────────────
const fetchConToken = async (endpoint: string) => {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, {
      headers: { 'auth-token': authStore.token || '', 'Content-Type': 'application/json' }
    })
    return await res.json()
  } catch (error) {
    console.error(`Error en ${endpoint}:`, error)
    return { status: 'error', datos: [] }
  }
}

const loadData = async () => {
  isLoading.value = true
  
  // Cargar todos los menús (activos e inactivos)
  const [menusRes, catRes, prodRes, cliRes] = await Promise.all([
    fetchConToken('/menu/mostrar-activo'),
    fetchConToken('/tienda/categorias/mostrar'),
    fetchConToken('/productos/mostrar'),
    fetchConToken('/clientes/mostrar-activos')
  ])

  // Guardar todos los menús
  menus.value = menusRes.datos || []
  
  // Filtrar menús activos ahora (hora y día)
  const menusActivosAhora = menus.value.filter((m: any) => esMenuActivoAhora(m))
  console.log('DEBUG - Todos los menús:', menus.value.map((m: any) => ({ nombre: m.nombre_menu, hora_inicio: m.hora_inicio, hora_fin: m.hora_fin, dias: m.dias_semana })))
  console.log('DEBUG - Menús activos ahora:', menusActivosAhora.map((m: any) => ({ nombre: m.nombre_menu })))
  
  // Obtener productos de cada menú activo ahora
  const productosEnMenuIds = new Set<number>()
  for (const menu of menusActivosAhora) {
    try {
      const resProdMenu = await fetchConToken(`/menu/mostrar-menu/${menu.id_menu}`)
      if (resProdMenu.datos && resProdMenu.datos.length > 0) {
        resProdMenu.datos.forEach((mp: any) => {
          if (mp.id_producto) productosEnMenuIds.add(mp.id_producto)
        })
      }
    } catch (e) { console.warn('Error obteniendo productos del menú', menu.id_menu) }
  }
  productosEnMenusActivos.value = Array.from(productosEnMenuIds)
  console.log('DEBUG - Productos en menús activos:', productosEnMenusActivos.value)

  categorias.value = [{ id_categoria: 0, nombre_cat: 'Todos' }, ...(catRes.datos || [])]
  
  allProducts.value = (prodRes.datos || []).map((p: any) => ({
    id_producto: p.id_producto,
    nombre_producto: p.nombre_producto,
    precio_base: Number(p.precio_base || p.precio || 0),
    categoria: p.categoria || 'Sin categoría',
    url_imagen: p.url_imagen || '',
    disponibilidad: p.disponibilidad !== undefined ? p.disponibilidad : true
  }))

  clientes.value = cliRes.datos || []
  
  // Cargar paquetes y promociones
  await Promise.all([loadPaquetes(), loadPromociones()])
  
  isLoading.value = false
}

const loadPaquetes = async () => {
  paquetesLoading.value = true
  try {
    const res = await fetchConToken('/paquetes/menu-completo')
    console.log('📦 [DEBUG] Paquetes response:', JSON.stringify(res, null, 2))
    // Formatear datos del paquete - ajustar campos según respuesta real
    if (res.datos && res.datos.length > 0) {
      paquetes.value = res.datos.map((p: any) => ({
        id_paquete: p.id_paquete,
        nombre_paquete: p.nombre,
        precio: Number(p.precio),
        descripcion: p.descripcion || '',
        url_imagen: p.imagen || '',
        grupos: (p.grupos || []).map((g: any) => ({
          id_grupo: g.id_grupo,
          nombre_grupo: g.nombre_grupo,
          es_obligatorio: g.obligatorio,
          cantidad_minima: g.obligatorio ? 1 : 0,
          cantidad_maxima: g.cantidad || 1,
          productos: (g.opciones || []).map((prod: any) => ({
            id_producto: prod.id_producto,
            nombre_producto: prod.nombre_producto,
            precio_adicional: Number(prod.precio_extra || 0)
          }))
        }))
      }))
    }
  } catch (e) { console.log('Paquetes no disponibles') }
  paquetesLoading.value = false
}

const loadPromociones = async () => {
  try {
    const [promosRes, prodPromosRes, cliPromosRes] = await Promise.all([
      fetchConToken('/promociones/mostrar'),
      fetchConToken('/promociones/productos/mostrar'),
      fetchConToken('/promociones/clientes/mostrar')
    ])
    
    if (promosRes.datos && promosRes.datos.length > 0) {
      console.log('📦 DEBUG - Promociones raw:', JSON.stringify(promosRes.datos))
      
      // Map productos y clientes por promoción
      const productosPorPromo = new Map<number, number[]>()
      const clientesPorPromo = new Map<number, number[]>()
      
      if (prodPromosRes.datos) {
        (prodPromosRes.datos as any[]).forEach((pp: any) => {
          if (!productosPorPromo.has(pp.id_promocion)) productosPorPromo.set(pp.id_promocion, [])
          productosPorPromo.get(pp.id_promocion)!.push(pp.id_producto)
        })
      }
      
      if (cliPromosRes.datos) {
        (cliPromosRes.datos as any[]).forEach((cp: any) => {
          if (!clientesPorPromo.has(cp.id_promocion)) clientesPorPromo.set(cp.id_promocion, [])
          clientesPorPromo.get(cp.id_promocion)!.push(cp.id_cliente)
        })
      }
      
      promociones.value = promosRes.datos.map((p: any) => {
        let tipoNormalizado = p.tipo || p.tipo_promocion || 'descuento'
        
        // Normalizar tipos: descuento -> porcentaje, 2x1 -> bogo, fijo -> monto
        // Si es porcentaje con valor 0, probablemente es un 2x1
        if ((tipoNormalizado === 'descuento' || tipoNormalizado === 'porcentaje') && (p.valor === 0 || p.valor_descuento === 0)) {
          tipoNormalizado = 'bogo'
        } else if (tipoNormalizado === 'descuento') {
          tipoNormalizado = 'porcentaje'
        } else if (tipoNormalizado === '2x1') {
          tipoNormalizado = 'bogo'
        } else if (tipoNormalizado === 'fijo') {
          tipoNormalizado = 'monto'
        }
        
        // Parsear dias_aplicables
        let diasArray: string[] | null = null
        if (p.dias_aplicables) {
          if (Array.isArray(p.dias_aplicables)) {
            diasArray = p.dias_aplicables
          } else if (typeof p.dias_aplicables === 'string') {
            const cleaned = p.dias_aplicables.replace(/[{}]/g, '')
            diasArray = cleaned.split(',').map((d: string) => d.trim().toLowerCase())
          }
        }
        
        const clientesSpecificos = clientesPorPromo.get(p.id_promocion) || []
        
        return {
          id_promocion: p.id_promocion,
          nombre: p.nombre || p.nombre_promocion || p.promocion,
          descripcion: p.descripcion || '',
          tipo: tipoNormalizado,
          valor: Number(p.valor || p.valor_descuento || 0),
          es_temporal: p.es_temporal || false,
          activo: p.activo !== false,
          solo_clientes: p.solo_clientes || p.solo_clientes_registrados || false,
          hora_inicio: p.hora_inicio || null,
          hora_fin: p.hora_fin || null,
          dias: p.dias || null,
          dias_aplicables: diasArray,
          productos: productosPorPromo.get(p.id_promocion) || [],
          clientes: clientesSpecificos
        }
      })
    }
  } catch (e) { console.log('Promociones no disponibles', e) }
}

onMounted(() => {
  const ticketCargado = loadTicket()
  loadData().then(() => {
    if (ticketCargado && cart.value.length > 0) {
      displayToast('Ticket restored', 'success')
    }
  })
})

watch([cart, selectedClient], () => {
  if (cart.value.length > 0) {
    saveTicket()
  }
}, { deep: true })

// ── COMPUTADOS ─────────────────────────────────────────
const filteredProducts = computed(() => {
  return allProducts.value.filter(p => {
    // Solo mostrar productos que están en menús activos ahora Y están disponibles
    const enMenuActivo = productosEnMenusActivos.value.includes(p.id_producto)
    const isDisponible = p.disponibilidad !== false
    const matchCat = activeCategory.value === 'Todos' || p.categoria === activeCategory.value
    const matchSearch = p.nombre_producto.toLowerCase().includes(searchQuery.value.toLowerCase())
    return enMenuActivo && isDisponible && matchCat && matchSearch
  })
})

const filteredClientes = computed(() => {
  return clientes.value.filter(c => 
    c.nombre.toLowerCase().includes(clientSearchQuery.value.toLowerCase())
  )
})

const activePaquetes = computed(() => paquetes.value.filter(p => p.precio > 0))

const activePromociones = computed(() => {
  const ahora = new Date()
  const horaActual = ahora.getHours() * 60 + ahora.getMinutes()
  const diaSemana = ahora.getDay()
  const diasMap: Record<number, string> = { 0: 'domingo', 1: 'lunes', 2: 'martes', 3: 'miercoles', 4: 'jueves', 5: 'viernes', 6: 'sabado' }
  const diaActual = diasMap[diaSemana]
  
  return promociones.value.filter(p => {
    // Solo activas
    if (p.activo === false) return false
    
    // Si tiene clientes específicos, verificar que el cliente seleccionado esté en la lista
    if (p.clientes && p.clientes.length > 0) {
      if (!selectedClient.value) return false
      if (!p.clientes.includes(selectedClient.value.id_cliente)) return false
    }
    
    // Si solo es para clientes registrados (no específicos)
    if (p.solo_clientes && (!p.clientes || p.clientes.length === 0)) {
      if (!selectedClient.value) return false
    }
    
    // Verificar horario
    if (p.hora_inicio && p.hora_fin) {
      const horaInicio = p.hora_inicio.toString().split(':')
      const horaFin = p.hora_fin.toString().split(':')
      const minutosInicio = parseInt(horaInicio[0]) * 60 + parseInt(horaInicio[1] || '0')
      const minutosFin = parseInt(horaFin[0]) * 60 + parseInt(horaFin[1] || '0')
      if (horaActual < minutosInicio || horaActual >= minutosFin) return false
    }
    
    // Verificar días
    if (p.dias_aplicables && Array.isArray(p.dias_aplicables) && p.dias_aplicables.length > 0) {
      if (!p.dias_aplicables.includes(diaActual)) return false
    }
    
    return true
  })
})

const packageExtraPrice = computed(() => {
  if (!selectedPackage.value) return 0
  let extra = 0
  packageSelections.value.forEach((productos) => {
    productos.forEach(p => { extra += p.precio_adicional })
  })
  return extra
})

// Descuentos - el precio ya incluye IVA, calculamos la base sin IVA
const subtotalConIva = computed(() => 
  cart.value.reduce((acc, item) => acc + item.qty * item.unitTotal, 0)
)

const subtotalSinIva = computed(() => subtotalConIva.value / 1.16)

const totalDescuentos = computed(() => {
  let totalDesc = 0
  
  for (const promo of appliedPromociones.value) {
    if (promo.tipo === 'porcentaje') {
      // Porcentaje sobre el subtotal sin IVA
      totalDesc += subtotalSinIva.value * (promo.valor / 100)
    } else if (promo.tipo === 'monto') {
      // Monto fijo
      totalDesc += promo.valor
    } else if (promo.tipo === 'bogo') {
      // 2x1: descuento del producto más barato que sea bebida (sin IVA)
      const itemsSinPaquete = cart.value.filter(i => !i.isPackage)
      const bebidas = itemsSinPaquete.filter(i => i.categoria?.toLowerCase().includes('bebidas'))
      const totalBebidas = bebidas.reduce((acc, item) => acc + item.qty, 0)
      if (totalBebidas >= 2) {
        const precios = bebidas.map(i => i.unitTotal / 1.16)
        const masBarato = Math.min(...precios)
        totalDesc += masBarato
      }
    }
  }
  
  return totalDesc
})

const taxBase = computed(() => subtotalSinIva.value - totalDescuentos.value)
const iva = computed(() => taxBase.value * 0.16)
const total = computed(() => subtotalConIva.value - totalDescuentos.value)

// ── PRODUCTOS E INGREDIENTES ────────────────────────────
const handleProductClick = async (product: Producto) => {
  isLoadingOptions.value = true
  const res = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${product.id_producto}`)
  console.log('🍔 [DEBUG] Ingredientes response for product', product.id_producto, ':', JSON.stringify(res, null, 2))
  
  const opcionesActivas = (res.datos || []).filter((i: any) => i.activo).map((i: any) => ({
    ...i,
    precio_modificador: Number(i.precio_modificador || 0),
    seleccionado: i.es_obligatorio
  }))

  if (opcionesActivas.length > 0) {
    currentOptions.value = opcionesActivas
    selectedProductForOptions.value = product
    showOptionsModal.value = true
  } else {
    addDirectlyToCart(product, [])
  }
  isLoadingOptions.value = false
}

const confirmOptionsAndAddToCart = () => {
  if (!selectedProductForOptions.value) return
  const selectedModifiers = currentOptions.value.filter(o => o.seleccionado)
  
  if (editingCartItemId.value !== null) {
    const cartItem = cart.value.find(item => item.cartId === editingCartItemId.value)
    if (cartItem) {
      const modsPrice = selectedModifiers.reduce((acc, mod) => acc + mod.precio_modificador, 0)
      cartItem.modifiers = [...selectedModifiers]
      cartItem.unitTotal = cartItem.basePrice + modsPrice
      displayToast('Ingredientes actualizados', 'success')
    }
    editingCartItemId.value = null
  } else {
    addDirectlyToCart(selectedProductForOptions.value, selectedModifiers)
  }
  showOptionsModal.value = false
  selectedProductForOptions.value = null
  currentOptions.value = []
}

const closeOptionsModal = () => {
  showOptionsModal.value = false
  selectedProductForOptions.value = null
  currentOptions.value = []
  editingCartItemId.value = null
}

const isEditingCartItem = computed(() => editingCartItemId.value !== null)

const addDirectlyToCart = (product: Producto, modifiers: IngredienteOpcion[]) => {
  const modsPrice = modifiers.reduce((acc, mod) => acc + mod.precio_modificador, 0)
  const finalUnitPrice = product.precio_base + modsPrice

  const existing = cart.value.find(item => {
    if (item.productId !== product.id_producto || item.isPackage) return false
    if (item.modifiers.length !== modifiers.length) return false
    const existingModIds = item.modifiers.map(m => m.id_ingrediente).sort()
    const newModIds = modifiers.map(m => m.id_ingrediente).sort()
    return existingModIds.every((val, index) => val === newModIds[index])
  })

  if (existing) {
    existing.qty++
  } else {
    cart.value.push({
      cartId: Date.now(),
      productId: product.id_producto,
      name: product.nombre_producto,
      qty: 1,
      basePrice: product.precio_base,
      modifiers: [...modifiers],
      unitTotal: finalUnitPrice,
      categoria: product.categoria
    })
  }
  console.log('🛒 Cart actual:', JSON.stringify(cart.value.map(i => ({ name: i.name, categoria: i.categoria }))))
  playSound('added')
  displayToast(`${product.nombre_producto} agregado`, 'success')
}

const openEditCartItemModal = async (cartItem: CartItem) => {
  try {
    const res = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${cartItem.productId}`)
    const opcionesActivas = (res.datos || []).filter((i: any) => i.activo)
    
    if (opcionesActivas.length > 0) {
      const currentModIds = new Set(cartItem.modifiers.map(m => m.id_ingrediente))
      currentOptions.value = opcionesActivas.map((i: any) => ({
        ...i,
        precio_modificador: Number(i.precio_modificador || 0),
        seleccionado: currentModIds.has(i.id_ingrediente)
      }))
      selectedProductForOptions.value = {
        id_producto: cartItem.productId,
        nombre_producto: cartItem.name,
        precio_base: cartItem.basePrice,
        categoria: cartItem.categoria || '',
        url_imagen: '',
        id_zona: null,
        zona: '',
        disponibilidad: true
      }
      editingCartItemId.value = cartItem.cartId
      showOptionsModal.value = true
    } else {
      displayToast('Este producto no tiene ingredientes configurados', 'warning')
    }
  } catch (e) {
    console.warn('Error al cargar opciones', e)
    displayToast('Error al cargar ingredientes', 'error')
  }
}

// ── PAQUETES ────────────────────────────────────────────
const openPackageModal = (paquete: Paquete) => {
  selectedPackage.value = paquete
  packageSelections.value = new Map()
  packageValidationError.value = ''
  showPackageModal.value = true
}

const togglePackageProduct = (grupoId: number, producto: PaqueteProducto) => {
  const current = packageSelections.value.get(grupoId) || []
  const idx = current.findIndex(p => p.id_producto === producto.id_producto)
  
  const grupo = selectedPackage.value?.grupos.find(g => g.id_grupo === grupoId)
  const max = grupo?.cantidad_maxima || 1
  
  if (idx >= 0) {
    current.splice(idx, 1)
  } else if (current.length < max) {
    current.push(producto)
  }
  
  packageSelections.value.set(grupoId, [...current])
  packageValidationError.value = ''
}

const isProductSelected = (grupoId: number, productoId: number) => {
  const current = packageSelections.value.get(grupoId) || []
  return current.some(p => p.id_producto === productoId)
}

const validatePackageSelection = (): boolean => {
  if (!selectedPackage.value) return false
  
  for (const grupo of selectedPackage.value.grupos) {
    const selected = packageSelections.value.get(grupo.id_grupo) || []
    if (grupo.es_obligatorio && selected.length < grupo.cantidad_minima) {
      packageValidationError.value = `Selecciona al menos ${grupo.cantidad_minima} producto(s) en "${grupo.nombre_grupo}"`
      return false
    }
  }
  return true
}

const addPackageToCart = () => {
  if (!selectedPackage.value || !validatePackageSelection()) return
  
  const selections: { id_grupo: number; id_producto: number; nombre: string }[] = []
  let extraPrice = 0
  
  packageSelections.value.forEach((productos, grupoId) => {
    const grupo = selectedPackage.value!.grupos.find(g => g.id_grupo === grupoId)
    productos.forEach(p => {
      selections.push({ id_grupo: grupoId, id_producto: p.id_producto, nombre: p.nombre_producto })
      extraPrice += p.precio_adicional
    })
  })

  const finalPrice = selectedPackage.value.precio + extraPrice
  
  cart.value.push({
    cartId: Date.now(),
    productId: selectedPackage.value.id_paquete,
    name: selectedPackage.value.nombre_paquete,
    qty: 1,
    basePrice: selectedPackage.value.precio,
    modifiers: [],
    unitTotal: finalPrice,
    isPackage: true,
    packageId: selectedPackage.value.id_paquete,
    packageSelections: selections,
    extraPrice: extraPrice
  })

  playSound('added')
  displayToast(`${selectedPackage.value.nombre_paquete} agregado`, 'success')
  showPackageModal.value = false
}

// ── RFID ────────────────────────────────────────────────
const toggleRfidListening = async () => {
  rfidListening.value = !rfidListening.value
  rfidError.value = ''
  
  if (rfidListening.value) {
    await nextTick()
    rfidInputRef.value?.focus()
    displayToast('Escuchando RFID...', 'warning')
  }
}

const handleRfidInput = async () => {
  const code = rfidInput.value.trim()
  if (!code || code.length < 4) return

  rfidListening.value = false
  playSound('beep')
  
  // Endpoint pendiente - por ahora simulating
  // const res = await fetchConToken(`/clientes/buscar-rfid/${code}`)
  
  displayToast('Buscando cliente...', 'warning')
  
  // Simular búsqueda (reemplazar con endpoint real cuando esté disponible)
  setTimeout(() => {
    rfidInput.value = ''
    displayToast('Endpoint RFID pendiente - configure backend', 'warning')
  }, 1000)
  
  // Código cuando endpoint esté disponible:
  // if (res.status === 'ok' && res.datos?.cliente) {
  //   rfidDetectedClient.value = res.datos
  //   showClientConfirmModal = true
  // } else {
  //   rfidError.value = 'Cliente no encontrado'
  //   displayToast('Cliente no encontrado', 'error')
  //   playSound('error')
  // }
}

// ── CLIENTE ─────────────────────────────────────────────
const selectClient = (cli: Cliente | null) => {
  selectedClient.value = cli
  rfidDetectedClient.value = null
  applyClientPromotions()
  showClientModal.value = false
}

const applyClientPromotions = () => {
  if (!selectedClient.value || !rfidDetectedClient.value?.beneficios) {
    appliedPromociones.value = []
    return
  }
  
  // Aplicar promociones que tenga el cliente linked
  // Por ahora vacío - cuando endpoint esté disponible
  appliedPromociones.value = []
}

// ── MODAL DE PROMOCIÓN ─────────────────────────────────────
const openPromoModal = async (promo: Promocion) => {
  selectedPromo.value = promo
  promoSelectedProducts.value = {}
  
  // Cargar productos disponibles para esta promoción
  if (promo.productos && promo.productos.length > 0) {
    // La promoción tiene productos específicos vinculados
    promoProductos.value = allProducts.value.filter(p => promo.productos.includes(p.id_producto))
  } else {
    // La promoción aplica a todos los productos disponibles
    promoProductos.value = allProducts.value.filter(p => p.disponibilidad !== false && productosEnMenusActivos.value.includes(p.id_producto))
  }
  
  showPromoModal.value = true
}

const togglePromoProduct = (productId: number) => {
  const current = promoSelectedProducts.value[productId] || 0
  const total = Object.values(promoSelectedProducts.value).reduce((sum, qty) => sum + qty, 0)
  
  if (current === 0 && total >= 2) {
    displayToast('Máximo 2 productos por promoción', 'warning')
    return
  }
  
  if (current === 0) {
    promoSelectedProducts.value[productId] = 1
  } else {
    delete promoSelectedProducts.value[productId]
  }
}

const confirmPromoSelection = () => {
  if (!selectedPromo.value) return
  
  const selectedIds = Object.keys(promoSelectedProducts.value).map(Number)
  if (selectedIds.length === 0) {
    displayToast('Selecciona al menos un producto', 'warning')
    return
  }
  
  // Agregar productos con precio de promoción
  const promo = selectedPromo.value
  for (const productId of selectedIds) {
    const producto = promoProductos.value.find(p => p.id_producto === productId)
    if (!producto) continue
    
    let finalPrice = producto.precio_base
    if (promo.tipo === 'porcentaje') {
      finalPrice = producto.precio_base * (1 - promo.valor / 100)
    } else if (promo.tipo === 'monto') {
      finalPrice = Math.max(0, producto.precio_base - promo.valor)
    }
    // bogo (2x1) se maneja diferente - precio completo
    
    addDirectlyToCart(producto, [], finalPrice)
  }
  
  // Agregar la promoción a las aplicadas
  appliedPromociones.value.push({
    id_promocion: promo.id_promocion,
    nombre: promo.nombre,
    tipo: promo.tipo,
    valor: promo.valor
  })
  
  showPromoModal.value = false
  selectedPromo.value = null
}

const removePromoFromCart = (idPromo: number) => {
  appliedPromociones.value = appliedPromociones.value.filter(p => p.id_promocion !== idPromo)
}

// ── CARRITO ─────────────────────────────────────────────
const updateQty = (cartId: number, delta: number) => {
  const item = cart.value.find(i => i.cartId === cartId)
  if (item) {
    item.qty += delta
    if (item.qty <= 0) {
      removeFromCart(cartId)
    }
  }
}

const removeFromCart = (cartId: number) => {
  cart.value = cart.value.filter(i => i.cartId !== cartId)
  delete itemNotes.value[cartId]
}

const clearCart = () => {
  if (confirm('¿Estás seguro de vaciar el ticket actual?')) {
    cart.value = []
    selectedClient.value = null
    rfidDetectedClient.value = null
    appliedPromociones.value = []
    itemNotes.value = {}
    orderNote.value = ''
    itemPromociones.value = {}
    clearSavedTicket()
  }
}

// ── PAGO ────────────────────────────────────────────────
const openConfirmModal = () => {
  if (cart.value.length === 0) {
    displayToast('El carrito está vacío', 'warning')
    return
  }
  showConfirmModal.value = true
}

const processPay = async () => {
  if (cart.value.length === 0) return
  
  isProcessingPayment.value = true
  
  try {
    // Por ahora simulando - cuando endpoints estén disponibles:
    // 1. POST /api/ordenes/agregar
    // 2. POST /api/ordenes/detalles/agregar para cada item
    // 3. POST /api/ordenes/pagos/agregar
    
    const payload = {
      id_cliente: selectedClient.value?.id_cliente || null,
      metodo_pago: selectedPayment.value,
      subtotal: subtotalConIva.value,
      descuento: totalDescuentos.value,
      impuestos: iva.value,
      total: total.value,
      notas: orderNote.value,
      productos: cart.value.map(item => ({
        ...item,
        nota: itemNotes.value[item.cartId] || ''
      })),
      promociones_aplicadas: appliedPromociones.value
    }
    
    console.log('Procesando orden:', payload)
    
    // Simular delay
    await new Promise(r => setTimeout(r, 1500))
    
    playSound('success')
    displayToast('Orden procesada correctamente', 'success')
    
    // Limpiar
    cart.value = []
    selectedClient.value = null
    rfidDetectedClient.value = null
    appliedPromociones.value = []
    itemNotes.value = {}
    orderNote.value = ''
    itemPromociones.value = {}
    clearSavedTicket()
    showConfirmModal.value = false
    
  } catch (error) {
    playSound('error')
    displayToast('Error al procesar la orden', 'error')
  } finally {
    isProcessingPayment.value = false
  }
}

const formatDiscount = (promo: { tipo: string; valor: number }) => {
  if (promo.tipo === 'porcentaje') return `-${promo.valor}%`
  if (promo.tipo === 'monto') return `-$${promo.valor}`
  return '2x1'
}
</script>

<template>
  <div class="venta-layout">
    <!-- HEADER -->
    <header class="venta-header">
      <div class="header-left">
        <h1 class="venta-title">Terminal POS</h1>
      </div>
      <div class="header-center">
        <button 
          class="rfid-btn" 
          :class="{ active: rfidListening }"
          @click="toggleRfidListening"
        >
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 2a10 10 0 0 1 10 10v4a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a10 10 0 0 1 10-10z"/>
            <path d="M12 12v.01"/>
          </svg>
          <span>RFID</span>
        </button>
        <input 
          v-if="rfidListening"
          ref="rfidInputRef"
          v-model="rfidInput"
          class="rfid-input"
          placeholder="Esperando código RFID..."
          @keyup.enter="handleRfidInput"
          @blur="rfidListening = false"
        />
      </div>
      <div class="header-right">
        <button class="btn-client" @click="showClientModal = true">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
          </svg>
          {{ selectedClient ? selectedClient.nombre : 'Público General' }}
        </button>
        <button class="logout-btn" @click="router.push('/login')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
        </button>
      </div>
    </header>

    <!-- MAIN -->
    <div class="venta-main">
      <!-- LEFT PANEL: Products -->
      <section class="panel panel--products">
        <div class="products-top">
          <div class="search-bar">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none">
              <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/>
              <path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
            <input v-model="searchQuery" type="text" placeholder="Buscar..." class="search-input" />
          </div>
        </div>

        <!-- Tabs -->
        <div class="view-tabs">
          <button 
            class="view-tab" 
            :class="{ active: activeView === 'products' }"
            @click="activeView = 'products'"
          >Productos</button>
          <button 
            class="view-tab" 
            :class="{ active: activeView === 'paquetes' }"
            @click="activeView = 'paquetes'"
          >Paquetes</button>
          <button 
            class="view-tab" 
            :class="{ active: activeView === 'promos' }"
            @click="activeView = 'promos'"
          >Promociones</button>
        </div>

        <!-- Categories -->
        <div v-if="activeView === 'products'" class="categories-bar">
          <div class="categories-scroll">
            <button
              v-for="cat in categorias"
              :key="cat.id_categoria"
              class="cat-chip"
              :class="{ active: activeCategory === cat.nombre_cat }"
              @click="activeCategory = cat.nombre_cat"
            >{{ cat.nombre_cat }}</button>
          </div>
        </div>

        <!-- Products Grid -->
        <div v-if="isLoading" class="loading-state">Cargando...</div>
        
        <div v-else-if="activeView === 'products'" class="product-grid">
          <button 
            v-for="product in filteredProducts" 
            :key="product.id_producto" 
            class="product-card"
            @click="handleProductClick(product)"
            :disabled="isLoadingOptions"
          >
            <img v-if="product.url_imagen" :src="product.url_imagen" class="product-img" />
            <div v-else class="product-emoji">📦</div>
            <span class="product-name">{{ product.nombre_producto }}</span>
            <span class="product-price">${{ product.precio_base.toFixed(2) }}</span>
          </button>
          <div v-if="filteredProducts.length === 0" class="empty-state">No se encontraron productos</div>
        </div>

        <!-- Paquetes Grid -->
        <div v-else-if="activeView === 'paquetes'" class="product-grid">
          <div v-if="paquetesLoading" class="loading-state">Cargando paquetes...</div>
          <div v-else-if="activePaquetes.length === 0" class="empty-state">No hay paquetes disponibles</div>
          <button 
            v-for="paquete in activePaquetes" 
            :key="paquete.id_paquete" 
            class="product-card"
            @click="openPackageModal(paquete)"
          >
            <div class="product-emoji">🎁</div>
            <span class="product-name">{{ paquete.nombre_paquete }}</span>
            <span class="product-price">${{ paquete.precio.toFixed(2) }}</span>
          </button>
        </div>

        <!-- Promociones Grid -->
        <div v-else-if="activeView === 'promos'" class="product-grid">
          <div v-if="activePromociones.length === 0" class="empty-state">No hay promociones activas</div>
          <div 
            v-for="promo in activePromociones" 
            :key="promo.id_promocion" 
            class="product-card promo-card"
            @click="openPromoModal(promo)"
          >
            <div class="product-emoji">🏷️</div>
            <span class="product-name">{{ promo.nombre }}</span>
            <span class="promo-badge" :class="promo.tipo">
              {{ promo.tipo === 'porcentaje' ? `-${promo.valor}%` : promo.tipo === 'monto' ? `-$${promo.valor}` : '2x1' }}
            </span>
            <span class="promo-hint">Toca para aplicar</span>
          </div>
        </div>
      </section>

      <!-- RIGHT PANEL: Cart -->
      <section class="panel panel--cart">
        <div class="panel-header">
          <span class="panel-title">Ticket de Venta</span>
          <button class="btn-client-small" @click="showClientModal = true">
            {{ selectedClient ? selectedClient.nombre : 'Público' }}
          </button>
        </div>

        <!-- Beneficios aplicados -->
        <div v-if="appliedPromociones.length > 0" class="applied-promos">
          <div v-for="promo in appliedPromociones" :key="promo.id_promocion" class="promo-applied-tag">
            {{ promo.nombre }}
          </div>
        </div>

        <div class="cart-scroll-wrapper">
          <div class="cart-items">
          <div v-if="cart.length === 0" class="cart-empty">
            <svg viewBox="0 0 24 24" fill="none"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" stroke="currentColor" stroke-width="1.5"/><line x1="3" y1="6" x2="21" y2="6" stroke="currentColor" stroke-width="1.5"/></svg>
            <p>El ticket está vacío</p>
          </div>

          <div v-for="item in cart" :key="item.cartId" class="cart-item">
            <div class="item-info">
              <span class="item-name">
                {{ item.name }}
                <span v-if="item.isPackage" class="badge-package">PAQUETE</span>
              </span>
              <span class="item-unit">${{ item.unitTotal.toFixed(2) }}</span>
              <ul v-if="item.modifiers.length > 0" class="item-mods-list">
                <li v-for="mod in item.modifiers" :key="mod.id_ingrediente">
                  + {{ mod.nombre_ingrediente }} <span v-if="mod.precio_modificador > 0">(+${{mod.precio_modificador}})</span>
                </li>
              </ul>
              <div v-if="itemPromociones[item.cartId]?.length" class="item-promos">
                <span v-for="promo in itemPromociones[item.cartId]" :key="promo.id_promocion" class="promo-item-tag">
                  {{ promo.tipo === 'porcentaje' ? `${promo.valor}%` : promo.tipo === 'bogo' ? '2x1' : promo.tipo === 'monto' ? `-$${promo.valor}` : promo.nombre }}
                </span>
              </div>
              <div v-if="item.packageSelections?.length" class="package-selections">
                <span v-for="sel in item.packageSelections" :key="sel.id_producto" class="sel-chip">
                  {{ sel.nombre }}
                </span>
              </div>
              <input 
                v-model="itemNotes[item.cartId]"
                type="text" 
                class="item-note-input" 
                placeholder="Nota: sin cebolla..."
              />
            </div>
            
            <div class="qty-controls">
              <button @click="updateQty(item.cartId, -1)">−</button>
              <span>{{ item.qty }}</span>
              <button @click="updateQty(item.cartId, 1)">+</button>
            </div>
            
            <div class="item-right">
              <span class="item-total">${{ (item.qty * item.unitTotal).toFixed(2) }}</span>
              <button class="edit-btn" @click="openEditCartItemModal(item)" title="Editar ingredientes">✏️</button>
              <button class="delete-btn" @click="removeFromCart(item.cartId)">🗑️</button>
            </div>
          </div>
        </div>
        </div>

        <div class="cart-totals">
          <div class="totals-row"><span>Subtotal (inc. IVA)</span><span>${{ subtotalConIva.toFixed(2) }}</span></div>
          <div v-if="totalDescuentos > 0" class="totals-row discount">
            <span>Descuentos</span><span>-${{ totalDescuentos.toFixed(2) }}</span>
          </div>
          <div class="totals-row"><span>IVA (16%)</span><span>${{ iva.toFixed(2) }}</span></div>
          <div class="totals-total"><span>Total</span><span class="totals-amount">${{ total.toFixed(2) }}</span></div>
        </div>

        <div class="order-note-section">
          <input v-model="orderNote" type="text" placeholder="Notas de orden..." class="order-note-input" />
        </div>

        <div class="cart-actions">
          <div class="actions-row">
            <button class="btn btn--danger" @click="clearCart">Cancelar</button>
            <button class="btn btn--secondary" @click="showPaymentMenu = !showPaymentMenu">
              {{ selectedPayment }}
            </button>
            <div v-if="showPaymentMenu" class="payment-menu">
              <button v-for="method in paymentMethods" :key="method" @click="selectedPayment = method; showPaymentMenu = false">{{ method }}</button>
            </div>
          </div>
          <button class="btn btn--primary btn-block" @click="openConfirmModal">
            Cobrar ${{ total.toFixed(2) }}
          </button>
        </div>
      </section>
    </div>

    <!-- MODAL: Options -->
    <div v-if="showOptionsModal && selectedProductForOptions" class="modal-overlay" @click.self="showOptionsModal = false">
      <div class="modal-content options-modal">
        <div class="modal-header">
          <h3>{{ selectedProductForOptions.nombre_producto }}</h3>
          <p class="base-price">Precio base: ${{ selectedProductForOptions.precio_base.toFixed(2) }}</p>
        </div>
        <div class="options-list">
          <label v-for="opcion in currentOptions" :key="opcion.id_producto_ingrediente" class="option-row" :class="{ 'is-disabled': opcion.es_obligatorio }">
            <div class="option-info">
              <input type="checkbox" v-model="opcion.seleccionado" :disabled="opcion.es_obligatorio" />
              <span class="option-name">{{ opcion.nombre_ingrediente }}</span>
              <span v-if="opcion.es_obligatorio" class="badge-req">Requerido</span>
            </div>
            <span v-if="opcion.precio_modificador > 0" class="option-price">+${{ opcion.precio_modificador.toFixed(2) }}</span>
          </label>
        </div>
        <div class="modal-actions">
          <button class="btn btn--secondary" @click="closeOptionsModal">Cancelar</button>
          <button class="btn btn--primary" @click="confirmOptionsAndAddToCart">
            {{ isEditingCartItem ? 'Actualizar' : 'Agregar' }}
          </button>
        </div>
      </div>
    </div>

    <!-- MODAL: Package -->
    <div v-if="showPackageModal && selectedPackage" class="modal-overlay" @click.self="showPackageModal = false">
      <div class="modal-content package-modal">
        <div class="modal-header">
          <h3>{{ selectedPackage.nombre_paquete }}</h3>
          <p class="base-price">Precio: ${{ selectedPackage.precio.toFixed(2) }}</p>
        </div>
        <div class="package-groups">
          <div v-for="grupo in selectedPackage.grupos" :key="grupo.id_grupo" class="package-group">
            <div class="group-header">
              <span class="group-name">{{ grupo.nombre_grupo }}</span>
              <span v-if="grupo.es_obligatorio" class="badge-req">Obligatorio</span>
              <span class="group-count">{{ (packageSelections.get(grupo.id_grupo) || []).length }}/{{ grupo.cantidad_maxima }}</span>
            </div>
            <div class="group-products">
              <button 
                v-for="prod in grupo.productos" 
                :key="prod.id_producto"
                class="product-chip"
                :class="{ selected: isProductSelected(grupo.id_grupo, prod.id_producto) }"
                @click="togglePackageProduct(grupo.id_grupo, prod)"
              >
                {{ prod.nombre_producto }}
                <span v-if="prod.precio_adicional > 0">+${{ prod.precio_adicional }}</span>
              </button>
            </div>
          </div>
          <p v-if="packageValidationError" class="validation-error">{{ packageValidationError }}</p>
          <p v-if="packageExtraPrice > 0" class="extra-price">Extras: +${{ packageExtraPrice.toFixed(2) }}</p>
        </div>
        <div class="modal-actions">
          <button class="btn btn--secondary" @click="showPackageModal = false">Cancelar</button>
          <button class="btn btn--primary" @click="addPackageToCart">Agregar Paquete</button>
        </div>
      </div>
    </div>

    <!-- MODAL: Promo -->
    <div v-if="showPromoModal && selectedPromo" class="modal-overlay" @click.self="showPromoModal = false">
      <div class="modal-content promo-modal">
        <div class="modal-header">
          <h3>{{ selectedPromo.nombre }}</h3>
          <p class="promo-desc">{{ selectedPromo.descripcion }}</p>
          <p class="promo-value">
            {{ selectedPromo.tipo === 'porcentaje' ? `-${selectedPromo.valor}%` : selectedPromo.tipo === 'monto' ? `-$${selectedPromo.valor}` : '2x1 (Llévate 2)' }}
          </p>
          <p class="promo-limit">Selecciona hasta 2 productos</p>
        </div>
        <div class="promo-products-list">
          <div 
            v-for="prod in promoProductos" 
            :key="prod.id_producto"
            class="promo-product-item"
            :class="{ selected: promoSelectedProducts[prod.id_producto] }"
            @click="togglePromoProduct(prod.id_producto)"
          >
            <div class="promo-prod-info">
              <span class="promo-prod-name">{{ prod.nombre_producto }}</span>
              <span class="promo-prod-cat">{{ prod.categoria }}</span>
            </div>
            <div class="promo-prod-price">
              <span class="original-price">${{ prod.precio_base.toFixed(2) }}</span>
              <span v-if="selectedPromo.tipo === 'porcentaje'" class="disc-price">
                ${{ (prod.precio_base * (1 - selectedPromo.valor / 100)).toFixed(2) }}
              </span>
              <span v-else-if="selectedPromo.tipo === 'monto'" class="disc-price">
                ${{ Math.max(0, prod.precio_base - selectedPromo.valor).toFixed(2) }}
              </span>
              <span v-else class="disc-price">${{ prod.precio_base.toFixed(2) }} (x2)</span>
            </div>
          </div>
        </div>
        <div class="modal-actions">
          <button class="btn btn--secondary" @click="showPromoModal = false">Cancelar</button>
          <button class="btn btn--primary" @click="confirmPromoSelection">
            Agregar ({{ totalPromoSeleccionados }})
          </button>
        </div>
      </div>
    </div>

    <!-- MODAL: Client -->
    <div v-if="showClientModal" class="modal-overlay" @click.self="showClientModal = false">
      <div class="modal-content">
        <h3>Seleccionar Cliente</h3>
        <input v-model="clientSearchQuery" type="text" placeholder="Buscar..." class="form-input" />
        <div class="client-list">
          <button class="client-item" @click="selectClient(null)">
            <strong>Público General</strong>
          </button>
          <button v-for="cli in filteredClientes" :key="cli.id_cliente" class="client-item" @click="selectClient(cli)">
            {{ cli.nombre }}
          </button>
        </div>
        <button class="btn btn--secondary btn-full" @click="showClientModal = false">Cerrar</button>
      </div>
    </div>

    <!-- MODAL: Confirm -->
    <div v-if="showConfirmModal" class="modal-overlay">
      <div class="modal-content confirm-modal">
        <h3>¿Confirmar Orden?</h3>
        <div class="confirm-details">
          <div class="confirm-row"><span>Cliente:</span><span>{{ selectedClient?.nombre || 'Público General' }}</span></div>
          <div class="confirm-row"><span>Método:</span><span>{{ selectedPayment }}</span></div>
          <hr />
          <div class="confirm-row"><span>Subtotal (inc. IVA):</span><span>${{ subtotalConIva.toFixed(2) }}</span></div>
          <div v-if="totalDescuentos > 0" class="confirm-row discount"><span>Descuentos:</span><span>-${{ totalDescuentos.toFixed(2) }}</span></div>
          <div class="confirm-row"><span>IVA:</span><span>${{ iva.toFixed(2) }}</span></div>
          <hr />
          <div class="confirm-row total"><span>TOTAL:</span><span>${{ total.toFixed(2) }}</span></div>
        </div>
        <div class="modal-actions">
          <button class="btn btn--secondary" @click="showConfirmModal = false" :disabled="isProcessingPayment">Cancelar</button>
          <button class="btn btn--primary" @click="processPay" :disabled="isProcessingPayment">
            {{ isProcessingPayment ? 'Procesando...' : 'Confirmar' }}
          </button>
        </div>
      </div>
    </div>

    <!-- TOAST -->
    <div v-if="showToast" class="toast" :class="toastType">
      {{ toastMsg }}
    </div>
  </div>
</template>

<style scoped>
/* ── RESET & BASE ── */
* { box-sizing: border-box; }

/* ── LAYOUT ── */
.venta-layout { display: flex; flex-direction: column; min-height: 100vh; background: #f5f5f5; overflow: hidden; }
.venta-main { flex: 1; display: flex; gap: 16px; padding: 16px; overflow: hidden; }

/* ── HEADER ── */
.venta-header { display: flex; align-items: center; justify-content: space-between; padding: 12px 20px; background: #fff; border-bottom: 1px solid #e5e7eb; gap: 16px; }
.header-left { display: flex; align-items: center; gap: 12px; }
.menu-btn { background: none; border: none; cursor: pointer; padding: 8px; border-radius: 8px; }
.menu-btn:hover { background: #f3f4f6; }
.menu-btn svg { width: 24px; height: 24px; color: #374151; }
.venta-title { margin: 0; font-size: 20px; font-weight: 700; color: #111827; }

.header-center { display: flex; align-items: center; gap: 8px; flex: 1; justify-content: center; }
.rfid-btn { display: flex; align-items: center; gap: 6px; padding: 10px 16px; background: #f3f4f6; border: 1px solid #d1d5db; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600; color: #374151; transition: all 0.2s; }
.rfid-btn:hover { background: #e5e7eb; }
.rfid-btn.active { background: #002D72; color: #fff; border-color: #002D72; }
.rfid-btn svg { width: 18px; height: 18px; }
.rfid-input { padding: 10px 14px; border: 2px solid #002D72; border-radius: 8px; font-size: 14px; width: 250px; outline: none; }

.header-right { display: flex; align-items: center; gap: 12px; }
.btn-client { display: flex; align-items: center; gap: 6px; padding: 8px 14px; background: #fff; border: 1px solid #2563eb; color: #2563eb; border-radius: 20px; font-size: 13px; font-weight: 600; cursor: pointer; }
.btn-client:hover { background: rgba(37, 99, 235, 0.1); }
.btn-client svg { width: 16px; height: 16px; }
.logout-btn { background: none; border: none; cursor: pointer; padding: 8px; border-radius: 8px; }
.logout-btn:hover { background: #fee2e2; }
.logout-btn svg { width: 20px; height: 20px; color: #dc2626; }

/* ── PANELS ── */
.panel { background: #fff; border-radius: 16px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
.panel--products { flex: 1; padding: 16px; gap: 12px; overflow: hidden; }
.panel--cart { width: 380px; flex-shrink: 0; display: flex; flex-direction: column; height: calc(100vh - 80px); }

/* ── SEARCH & TABS ── */
.products-top { display: flex; align-items: center; gap: 12px; }
.search-bar { flex: 1; display: flex; align-items: center; gap: 8px; background: #f3f4f6; border-radius: 10px; padding: 10px 14px; border: 1px solid transparent; transition: all 0.2s; }
.search-bar:focus-within { border-color: #002D72; background: #fff; }
.search-icon { width: 18px; height: 18px; color: #9ca3af; }
.search-input { border: none; background: none; outline: none; font-size: 14px; width: 100%; color: #111827; }

.view-tabs { display: flex; gap: 8px; border-bottom: 1px solid #e5e7eb; padding-bottom: 8px; }
.view-tab { flex: 1; padding: 12px; background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; color: #6b7280; transition: all 0.2s; }
.view-tab:hover { border-color: #002D72; }
.view-tab.active { background: #002D72; color: #fff; border-color: #002D72; }

/* ── CATEGORIES ── */
.categories-bar { display: flex; margin-bottom: 8px; }
.categories-scroll { display: flex; gap: 8px; overflow-x: auto; padding-bottom: 4px; scrollbar-width: none; }
.categories-scroll::-webkit-scrollbar { display: none; }
.cat-chip { padding: 8px 16px; background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 20px; font-size: 13px; font-weight: 500; color: #6b7280; cursor: pointer; white-space: nowrap; transition: all 0.2s; }
.cat-chip:hover { border-color: #002D72; color: #002D72; }
.cat-chip.active { background: #002D72; color: #fff; border-color: #002D72; }

/* ── PRODUCT GRID ── */
.product-grid { flex: 1; display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 12px; overflow-y: auto; align-content: start; padding: 4px; }
.product-card { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; padding: 16px; background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; cursor: pointer; transition: all 0.2s; min-height: 140px; }
.product-card:hover { transform: translateY(-2px); border-color: #002D72; box-shadow: 0 4px 12px rgba(0,45,114,0.15); }
.product-card:active { transform: scale(0.98); }
.product-card:disabled { opacity: 0.6; }
.product-emoji { width: 56px; height: 56px; background: #f3f4f6; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 28px; }
.product-img { width: 56px; height: 56px; object-fit: cover; border-radius: 10px; }
.product-name { font-size: 14px; font-weight: 600; color: #111827; text-align: center; line-height: 1.2; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; width: 100%; }
.product-price { font-size: 15px; color: #16a34a; font-weight: 700; }
.promo-card { background: #fef3c7; border-color: #fcd34d; }
.promo-badge { font-size: 13px; font-weight: 700; padding: 4px 10px; border-radius: 6px; }
.promo-badge.porcentaje { background: #dbeafe; color: #1d4ed8; }
.promo-badge.monto { background: #d1fae5; color: #059669; }
.promo-badge.bogo { background: #fce7f3; color: #db2777; }
.loading-state, .empty-state { grid-column: 1 / -1; text-align: center; padding: 40px; color: #9ca3af; font-size: 15px; }

/* ── CART HEADER ── */
.panel-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; border-bottom: 1px solid #e5e7eb; background: #f9fafb; }
.panel-title { font-size: 16px; font-weight: 700; color: #111827; }
.btn-client-small { background: #fff; border: 1px solid #2563eb; color: #2563eb; border-radius: 16px; padding: 4px 10px; font-size: 12px; font-weight: 600; cursor: pointer; max-width: 120px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

.applied-promos { display: flex; flex-wrap: wrap; gap: 6px; padding: 8px 16px; background: #ecfdf5; border-bottom: 1px solid #d1fae5; }
.promo-applied-tag { font-size: 11px; background: #10b981; color: #fff; padding: 3px 8px; border-radius: 4px; font-weight: 600; }

/* ── CART ITEMS ── */
.cart-items { flex: 1; min-height: 0; overflow-y: auto; padding: 12px 16px; display: flex; flex-direction: column; gap: 12px; }
.cart-scroll-wrapper { flex: 1; min-height: 0; overflow: hidden; display: flex; flex-direction: column; }
.cart-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; color: #9ca3af; }
.cart-empty svg { width: 48px; height: 48px; }

.cart-item { display: grid; grid-template-columns: 1fr auto auto; gap: 10px; padding-bottom: 12px; border-bottom: 1px dashed #e5e7eb; align-items: start; }
.item-info { display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.item-name { font-size: 14px; font-weight: 600; color: #111827; display: flex; align-items: center; gap: 6px; }
.badge-package { font-size: 9px; background: #f3f4f6; color: #6b7280; padding: 2px 4px; border-radius: 3px; font-weight: 700; }
.item-unit { font-size: 12px; color: #6b7280; }
.item-mods-list { margin: 2px 0 0 0; padding-left: 12px; font-size: 11px; color: #9ca3af; }
.item-promos { display: flex; flex-wrap: wrap; gap: 4px; margin-top: 4px; padding-left: 12px; }
.promo-item-tag { font-size: 10px; background: #fef3c7; color: #b45309; padding: 2px 6px; border-radius: 4px; font-weight: 600; border: 1px solid #fcd34d; }
.package-selections { display: flex; flex-wrap: wrap; gap: 4px; margin-top: 4px; }
.sel-chip { font-size: 10px; background: #e0e7ff; color: #4338ca; padding: 2px 6px; border-radius: 4px; }

.item-note-input { margin-top: 6px; padding: 6px 8px; border: 1px solid #e5e7eb; border-radius: 6px; font-size: 11px; width: 100%; }

.qty-controls { display: flex; align-items: center; background: #f3f4f6; border-radius: 8px; overflow: hidden; border: 1px solid #e5e7eb; }
.qty-controls button { background: none; border: none; padding: 10px 14px; font-size: 18px; font-weight: 700; cursor: pointer; color: #111827; transition: background 0.2s; min-width: 44px; min-height: 44px; display: flex; align-items: center; justify-content: center; }
.qty-controls button:hover { background: #e5e7eb; }
.qty-controls span { padding: 0 12px; font-size: 15px; font-weight: 700; min-width: 32px; text-align: center; }

.item-right { display: flex; flex-direction: column; align-items: flex-end; gap: 4px; }
.item-total { font-size: 15px; font-weight: 700; color: #111827; }
.delete-btn { background: none; border: none; cursor: pointer; padding: 4px; font-size: 16px; opacity: 0.6; transition: opacity 0.2s; }
.delete-btn:hover { opacity: 1; }
.edit-btn { background: none; border: none; cursor: pointer; padding: 4px; font-size: 14px; opacity: 0.6; transition: opacity 0.2s; }
.edit-btn:hover { opacity: 1; }

/* ── TOTALS ── */
.cart-totals { padding: 16px; background: #f9fafb; display: flex; flex-direction: column; gap: 8px; }
.totals-row { display: flex; justify-content: space-between; font-size: 14px; color: #6b7280; }
.totals-row.discount { color: #dc2626; }
.totals-total { display: flex; justify-content: space-between; align-items: center; margin-top: 8px; padding-top: 8px; border-top: 1px solid #e5e7eb; }
.totals-total span:first-child { font-size: 16px; font-weight: 600; color: #111827; }
.totals-amount { font-size: 22px; font-weight: 700; color: #16a34a; }

.order-note-section { padding: 0 16px; }
.order-note-input { width: 100%; padding: 10px 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 13px; }

.cart-actions { padding: 16px; display: flex; flex-direction: column; gap: 10px; border-top: 1px solid #e5e7eb; }
.actions-row { display: flex; gap: 8px; position: relative; }
.btn { border: none; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; padding: 14px 16px; transition: all 0.2s; }
.btn:hover { opacity: 0.85; }
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-block { width: 100%; padding: 16px; font-size: 18px; }
.btn--primary { background: #16a34a; color: #fff; }
.btn--danger { background: #fef2f2; color: #dc2626; flex: 1; }
.btn--secondary { background: #f3f4f6; border: 1px solid #e5e7eb; color: #111827; flex: 1; }

.payment-menu { position: absolute; bottom: 100%; right: 0; background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); display: flex; flex-direction: column; overflow: hidden; z-index: 10; margin-bottom: 8px; width: 50%; }
.payment-menu button { padding: 12px 16px; text-align: left; background: none; border: none; border-bottom: 1px solid #f3f4f6; cursor: pointer; font-size: 14px; }
.payment-menu button:hover { background: #f3f4f6; }

/* ── MODALS ── */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-content { background: #fff; padding: 20px; border-radius: 16px; width: 90%; max-width: 420px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); max-height: 85vh; display: flex; flex-direction: column; }
.modal-header { border-bottom: 1px solid #e5e7eb; padding-bottom: 12px; margin-bottom: 16px; }
.modal-header h3 { margin: 0 0 4px 0; font-size: 18px; color: #111827; }
.base-price { margin: 0; font-size: 14px; color: #6b7280; }

.options-list, .package-groups { flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px; }
.option-row { display: flex; align-items: center; justify-content: space-between; padding: 14px; background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 10px; cursor: pointer; transition: border-color 0.2s; }
.option-row:hover:not(.is-disabled) { border-color: #002D72; }
.option-row.is-disabled { opacity: 0.7; }
.option-info { display: flex; align-items: center; gap: 12px; }
.option-info input[type="checkbox"] { width: 20px; height: 20px; cursor: pointer; accent-color: #002D72; }
.option-name { font-size: 14px; font-weight: 500; color: #111827; }
.badge-req { font-size: 10px; background: #fee2e2; color: #dc2626; padding: 3px 8px; border-radius: 4px; font-weight: 700; text-transform: uppercase; }
.option-price { font-size: 14px; font-weight: 600; color: #16a34a; }

.package-group { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 10px; padding: 14px; }
.group-header { display: flex; align-items: center; gap: 8px; margin-bottom: 10px; }
.group-name { font-size: 14px; font-weight: 600; color: #111827; flex: 1; }
.group-count { font-size: 12px; color: #6b7280; background: #e5e7eb; padding: 2px 8px; border-radius: 4px; }
.group-products { display: flex; flex-wrap: wrap; gap: 8px; }
.product-chip { display: flex; flex-direction: column; align-items: center; padding: 10px 14px; background: #fff; border: 1px solid #d1d5db; border-radius: 8px; font-size: 12px; cursor: pointer; transition: all 0.2s; }
.product-chip:hover { border-color: #002D72; }
.product-chip.selected { background: #002D72; color: #fff; border-color: #002D72; }
.product-chip span { font-size: 10px; opacity: 0.8; }
.validation-error { color: #dc2626; font-size: 13px; font-weight: 600; padding: 10px; background: #fef2f2; border-radius: 8px; }
.extra-price { font-size: 14px; font-weight: 600; color: #16a34a; text-align: right; padding: 8px 0; }

.promo-modal { max-width: 400px; }
.promo-desc { font-size: 13px; color: #6b7280; margin: 4px 0; }
.promo-value { font-size: 24px; font-weight: 700; color: #16a34a; margin: 8px 0; }
.promo-limit { font-size: 12px; color: #6b7280; margin-bottom: 12px; }
.promo-products-list { max-height: 300px; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
.promo-product-item { display: flex; justify-content: space-between; align-items: center; padding: 12px; background: #f9fafb; border: 2px solid #e5e7eb; border-radius: 8px; cursor: pointer; transition: all 0.2s; }
.promo-product-item:hover { border-color: #002D72; }
.promo-product-item.selected { border-color: #16a34a; background: #ecfdf5; }
.promo-prod-info { display: flex; flex-direction: column; }
.promo-prod-name { font-size: 14px; font-weight: 600; color: #111827; }
.promo-prod-cat { font-size: 12px; color: #6b7280; }
.promo-prod-price { display: flex; flex-direction: column; align-items: flex-end; }
.original-price { font-size: 12px; color: #9ca3af; text-decoration: line-through; }
.disc-price { font-size: 16px; font-weight: 700; color: #16a34a; }
.promo-hint { font-size: 10px; color: #9ca3af; display: block; margin-top: 4px; }

.modal-actions { display: flex; gap: 12px; justify-content: flex-end; border-top: 1px solid #e5e7eb; padding-top: 16px; }

.client-list { overflow-y: auto; display: flex; flex-direction: column; gap: 6px; flex: 1; max-height: 300px; margin-bottom: 12px; }
.client-item { padding: 14px; text-align: left; background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 8px; cursor: pointer; font-size: 14px; transition: all 0.2s; }
.client-item:hover { background: #e0e7ff; border-color: #002D72; }
.form-input { width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px; margin-bottom: 12px; }
.btn-full { width: 100%; }

.confirm-modal { max-width: 360px; }
.confirm-details { margin: 16px 0; }
.confirm-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; }
.confirm-row.discount { color: #dc2626; }
.confirm-row.total { font-size: 18px; font-weight: 700; color: #111827; border-top: 1px solid #e5e7eb; padding-top: 12px; margin-top: 8px; }
.confirm-details hr { border: none; border-top: 1px solid #e5e7eb; margin: 8px 0; }

/* ── TOAST ── */
.toast { position: fixed; top: 20px; right: 20px; padding: 14px 20px; border-radius: 10px; font-size: 14px; font-weight: 600; z-index: 2000; animation: slideIn 0.3s ease; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
.toast.success { background: #10b981; color: #fff; }
.toast.warning { background: #f59e0b; color: #fff; }
.toast.error { background: #dc2626; color: #fff; }

@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
</style>