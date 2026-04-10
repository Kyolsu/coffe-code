<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const API_BASE = 'http://localhost:3000/api'

// ── TIPOS ──────────────────────────────────────────────
interface IngredienteOpcion {
  id_producto_ingrediente: number
  id_ingrediente: number
  nombre_ingrediente: string
  es_obligatorio: boolean
  precio_modificador: number
  activo: boolean
  // Estado local para la UI
  seleccionado?: boolean
}

interface CartItem {
  cartId: number // ID único para el carrito (permite el mismo producto con dif. opciones)
  productId: number
  name: string
  qty: number
  basePrice: number
  modifiers: IngredienteOpcion[]
  unitTotal: number // Precio base + suma de modificadores
}

interface Producto {
  id_producto: number
  nombre_producto: string
  precio_base: number
  categoria: string
  url_imagen: string
}

interface Categoria {
  id_categoria: number
  nombre_cat: string
}

interface Cliente {
  id_cliente: number
  nombre: string
}

// ── ESTADO ─────────────────────────────────────────────
const cart = ref<CartItem[]>([])
const categorias = ref<Categoria[]>([])
const allProducts = ref<Producto[]>([])
const activeCategory = ref<string>('Todos')
const searchQuery = ref('')
const isLoading = ref(true)

// Opciones de Producto (Modificadores)
const showOptionsModal = ref(false)
const selectedProductForOptions = ref<Producto | null>(null)
const currentOptions = ref<IngredienteOpcion[]>([])
const isLoadingOptions = ref(false)

// Clientes
const clientes = ref<Cliente[]>([])
const selectedClient = ref<Cliente | null>(null)
const showClientModal = ref(false)
const clientSearchQuery = ref('')

// Pago
const paymentMethods = ['Efectivo', 'Tarjeta', 'Transferencia']
const selectedPayment = ref('Efectivo')
const showPaymentMenu = ref(false)

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
  const [catRes, prodRes, cliRes] = await Promise.all([
    fetchConToken('/tienda/categorias/mostrar'),
    fetchConToken('/productos/mostrar'),
    fetchConToken('/clientes/mostrar-activos')
  ])

  categorias.value = [{ id_categoria: 0, nombre_cat: 'Todos' }, ...(catRes.datos || [])]
  
  allProducts.value = (prodRes.datos || []).map((p: any) => ({
    id_producto: p.id_producto,
    nombre_producto: p.nombre_producto,
    precio_base: Number(p.precio_base || p.precio || 0),
    categoria: p.categoria || 'Sin categoría',
    url_imagen: p.url_imagen || ''
  }))

  clientes.value = cliRes.datos || []
  isLoading.value = false
}

onMounted(() => {
  loadData()
})

// ── COMPUTADOS ─────────────────────────────────────────
const filteredProducts = computed(() => {
  return allProducts.value.filter(p => {
    const matchCat = activeCategory.value === 'Todos' || p.categoria === activeCategory.value
    const matchSearch = p.nombre_producto.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchCat && matchSearch
  })
})

const filteredClientes = computed(() => {
  return clientes.value.filter(c => 
    c.nombre.toLowerCase().includes(clientSearchQuery.value.toLowerCase())
  )
})

// ── LÓGICA DE PRODUCTOS E INGREDIENTES ──────────────────
const handleProductClick = async (product: Producto) => {
  isLoadingOptions.value = true
  
  // Consultamos el endpoint real de tu backend
  const res = await fetchConToken(`/productos/producto-ingrediente/mostrar-especifico/${product.id_producto}`)
  
  // Filtramos solo los activos y pre-seleccionamos los obligatorios
  const opcionesActivas = (res.datos || []).filter((i: any) => i.activo).map((i: any) => ({
    ...i,
    precio_modificador: Number(i.precio_modificador || 0),
    seleccionado: i.es_obligatorio // Si es obligatorio, ya viene marcado
  }))

  if (opcionesActivas.length > 0) {
    // Si tiene ingredientes, abrimos el modal
    currentOptions.value = opcionesActivas
    selectedProductForOptions.value = product
    showOptionsModal.value = true
  } else {
    // Si es un producto simple (ej. un refresco), lo agregamos directo
    addDirectlyToCart(product, [])
  }
  
  isLoadingOptions.value = false
}

const confirmOptionsAndAddToCart = () => {
  if (!selectedProductForOptions.value) return
  
  const selectedModifiers = currentOptions.value.filter(o => o.seleccionado)
  addDirectlyToCart(selectedProductForOptions.value, selectedModifiers)
  
  showOptionsModal.value = false
  selectedProductForOptions.value = null
  currentOptions.value = []
}

const addDirectlyToCart = (product: Producto, modifiers: IngredienteOpcion[]) => {
  // Calculamos el precio total por unidad (base + extras)
  const modsPrice = modifiers.reduce((acc, mod) => acc + mod.precio_modificador, 0)
  const finalUnitPrice = product.precio_base + modsPrice

  // Buscamos si ya existe el mismo producto CON EXACTAMENTE LOS MISMOS MODIFICADORES
  const existing = cart.value.find(item => {
    if (item.productId !== product.id_producto) return false
    if (item.modifiers.length !== modifiers.length) return false
    
    // Verificamos que tengan los mismos IDs de modificadores
    const existingModIds = item.modifiers.map(m => m.id_ingrediente).sort()
    const newModIds = modifiers.map(m => m.id_ingrediente).sort()
    return existingModIds.every((val, index) => val === newModIds[index])
  })

  if (existing) {
    existing.qty++
  } else {
    cart.value.push({
      cartId: Date.now(), // ID único para el render
      productId: product.id_producto,
      name: product.nombre_producto,
      qty: 1,
      basePrice: product.precio_base,
      modifiers: [...modifiers],
      unitTotal: finalUnitPrice
    })
  }
}

// ── CÁLCULOS TICKET ─────────────────────────────────────
const IVA_RATE = 0.16
const subtotal = computed(() => cart.value.reduce((acc, item) => acc + item.qty * item.unitTotal, 0))
const discount = computed(() => 0) 
const taxBase  = computed(() => subtotal.value - discount.value)
const iva      = computed(() => taxBase.value * IVA_RATE)
const total    = computed(() => taxBase.value + iva.value)

// ── ACCIONES DEL CARRITO ────────────────────────────────
const updateQty = (cartId: number, delta: number) => {
  const item = cart.value.find(i => i.cartId === cartId)
  if (item) {
    item.qty += delta
    if (item.qty <= 0) cart.value = cart.value.filter(i => i.cartId !== cartId)
  }
}

const clearCart = () => {
  if (confirm('¿Estás seguro de vaciar el ticket actual?')) {
    cart.value = []
    selectedClient.value = null
  }
}

const processPay = () => {
  if (cart.value.length === 0) return alert('El carrito está vacío.')
  
  // Aquí construirías el payload para tu futuro endpoint POST /ordenes
  const payload = {
    id_cliente: selectedClient.value?.id_cliente || null,
    metodo_pago: selectedPayment.value,
    total: total.value,
    productos: cart.value // Ya incluye modifiers
  }
  console.log('Procesando pago:', payload)
  alert(`Pago registrado en consola por $${total.value.toFixed(2)}`)
  cart.value = []
  selectedClient.value = null
}
</script>

<template>
  <div class="venta-layout">
    
    <div class="venta-main">
      <section class="panel panel--products">
        <div class="products-top">
          <div class="search-bar">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/><path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <input v-model="searchQuery" type="text" placeholder="Buscar en el menú..." class="search-input" />
          </div>
          <h2 class="venta-title">Terminal POS</h2>
        </div>

        <div class="categories-bar">
          <div class="categories-scroll">
            <button
              v-for="cat in categorias"
              :key="cat.id_categoria"
              class="cat-chip"
              :class="{ active: activeCategory === cat.nombre_cat }"
              @click="activeCategory = cat.nombre_cat"
            >
              {{ cat.nombre_cat }}
            </button>
          </div>
        </div>

        <div v-if="isLoading" class="loading-state">Cargando menú...</div>
        
        <div v-else class="product-grid">
          <button 
            v-for="product in filteredProducts" 
            :key="product.id_producto" 
            class="product-card" 
            @click="handleProductClick(product)"
            :disabled="isLoadingOptions"
          >
            <img v-if="product.url_imagen" :src="product.url_imagen" class="product-img" />
            <div v-else class="product-emoji">📦</div>
            <span class="product-name" :title="product.nombre_producto">{{ product.nombre_producto }}</span>
            <span class="product-price">${{ product.precio_base.toFixed(2) }}</span>
          </button>

          <div v-if="filteredProducts.length === 0" class="product-empty">
            No se encontraron productos.
          </div>
        </div>
      </section>

      <section class="panel panel--cart">
        <div class="panel-header">
          <span class="panel-title">Ticket de Venta</span>
          <button class="btn-client" @click="showClientModal = true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            {{ selectedClient ? selectedClient.nombre : 'Público General' }}
          </button>
        </div>

        <div class="cart-items">
          <div v-if="cart.length === 0" class="cart-empty">
            <svg viewBox="0 0 24 24" fill="none"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" stroke="currentColor" stroke-width="1.5"/><line x1="3" y1="6" x2="21" y2="6" stroke="currentColor" stroke-width="1.5"/></svg>
            <p>El ticket está vacío</p>
          </div>

          <div v-for="item in cart" :key="item.cartId" class="cart-item">
            <div class="item-info">
              <span class="item-name">{{ item.name }}</span>
              <span class="item-unit">${{ item.unitTotal.toFixed(2) }} 
                <span v-if="item.modifiers.length > 0" class="mods-text">c/extras</span>
              </span>
              <ul v-if="item.modifiers.length > 0" class="item-mods-list">
                <li v-for="mod in item.modifiers" :key="mod.id_ingrediente">
                  + {{ mod.nombre_ingrediente }} <span v-if="mod.precio_modificador > 0">(+${{mod.precio_modificador}})</span>
                </li>
              </ul>
            </div>
            
            <div class="qty-controls">
              <button @click="updateQty(item.cartId, -1)">-</button>
              <span>{{ item.qty }}</span>
              <button @click="updateQty(item.cartId, 1)">+</button>
            </div>
            
            <span class="item-total">${{ (item.qty * item.unitTotal).toFixed(2) }}</span>
          </div>
        </div>

        <div class="cart-totals">
          <div class="totals-row">
            <span>Subtotal</span>
            <span>${{ subtotal.toFixed(2) }}</span>
          </div>
          <div class="totals-row">
            <span>IVA (16%)</span>
            <span>${{ iva.toFixed(2) }}</span>
          </div>
          <div class="totals-total">
            <span>Total</span>
            <span class="totals-amount">${{ total.toFixed(2) }}</span>
          </div>
        </div>

        <div class="cart-actions">
          <div class="actions-row">
            <button class="btn btn--danger" @click="clearCart">Cancelar</button>
            <button class="btn btn--secondary" @click="showPaymentMenu = !showPaymentMenu">
              {{ selectedPayment }}
            </button>
            
            <div v-if="showPaymentMenu" class="payment-menu">
              <button v-for="method in paymentMethods" :key="method" @click="selectedPayment = method; showPaymentMenu = false">
                {{ method }}
              </button>
            </div>
          </div>
          
          <button class="btn btn--primary btn-block" @click="processPay">
            Cobrar ${{ total.toFixed(2) }}
          </button>
        </div>
      </section>

    </div>

    <div v-if="showOptionsModal && selectedProductForOptions" class="modal-overlay" @click.self="showOptionsModal = false">
      <div class="modal-content options-modal">
        <div class="modal-header">
          <h3>Personalizar {{ selectedProductForOptions.nombre_producto }}</h3>
          <p class="base-price">Precio base: ${{ selectedProductForOptions.precio_base.toFixed(2) }}</p>
        </div>
        
        <div class="options-list">
          <label v-for="opcion in currentOptions" :key="opcion.id_producto_ingrediente" class="option-row" :class="{ 'is-disabled': opcion.es_obligatorio }">
            <div class="option-info">
              <input 
                type="checkbox" 
                v-model="opcion.seleccionado" 
                :disabled="opcion.es_obligatorio" 
              />
              <span class="option-name">{{ opcion.nombre_ingrediente }}</span>
              <span v-if="opcion.es_obligatorio" class="badge-req">Requerido</span>
            </div>
            <span v-if="opcion.precio_modificador > 0" class="option-price">+${{ opcion.precio_modificador.toFixed(2) }}</span>
          </label>
        </div>
        
        <div class="modal-actions">
          <button class="btn btn--secondary" @click="showOptionsModal = false">Cancelar</button>
          <button class="btn btn--primary" @click="confirmOptionsAndAddToCart">Agregar al carrito</button>
        </div>
      </div>
    </div>

    <div v-if="showClientModal" class="modal-overlay" @click.self="showClientModal = false">
      <div class="modal-content">
        <h3 style="margin-top:0;">Seleccionar Cliente</h3>
        <input v-model="clientSearchQuery" type="text" placeholder="Buscar por nombre..." class="form-input" style="margin-bottom: 12px;"/>
        
        <div class="client-list">
          <button class="client-item" @click="selectedClient = null; showClientModal = false">
            <strong>Público General (Sin registrar)</strong>
          </button>
          <button v-for="cli in filteredClientes" :key="cli.id_cliente" class="client-item" @click="selectedClient = cli; showClientModal = false">
            {{ cli.nombre }}
          </button>
        </div>
        
        <button class="btn btn--secondary" style="width: 100%; margin-top: 12px;" @click="showClientModal = false">Cerrar</button>
      </div>
    </div>

  </div>
</template>

<style scoped>
/* ── LAYOUT RAÍZ ── */
.venta-layout { display: flex; min-height: 100vh; background-color: var(--tenant-fondo, #f9fafb); }
.venta-main { flex: 1; display: flex; gap: var(--espacio-4, 16px); padding: var(--espacio-5, 20px); overflow: hidden; min-height: 0; }

/* ── PANELES ── */
.panel { background: var(--color-superficie, #ffffff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 16px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
.panel--products { flex: 1; gap: var(--espacio-4, 16px); padding: var(--espacio-5, 20px); overflow: hidden; }
.panel--cart { width: 380px; flex-shrink: 0; gap: 0; }

/* ── PRODUCTOS: TOP ── */
.products-top { display: flex; align-items: center; justify-content: space-between; gap: var(--espacio-4, 16px); }
.venta-title { margin: 0; font-size: var(--font-size-xl, 24px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #111827); }
.search-bar { flex: 1; max-width: 400px; display: flex; align-items: center; gap: 8px; background: var(--color-superficie-alt, #f3f4f6); border: 1px solid transparent; border-radius: 8px; padding: 10px 16px; transition: border-color 0.2s; }
.search-bar:focus-within { border-color: var(--tenant-primario, #002D72); background: var(--color-superficie, #fff); }
.search-icon { width: 18px; height: 18px; color: var(--tenant-texto-muted, #6b7280); }
.search-input { background: none; border: none; outline: none; color: var(--tenant-texto, #111827); font-size: var(--font-size-sm, 13px); width: 100%; }

/* ── CATEGORÍAS ── */
.categories-bar { display: flex; align-items: center; margin-bottom: 8px; }
.categories-scroll { display: flex; gap: 8px; overflow-x: auto; scrollbar-width: none; padding-bottom: 4px; }
.categories-scroll::-webkit-scrollbar { display: none; }
.cat-chip { background: var(--color-superficie-alt, #f3f4f6); border: 1px solid var(--color-borde, #e5e7eb); color: var(--tenant-texto-muted, #6b7280); border-radius: 20px; padding: 6px 16px; font-size: var(--font-size-sm, 13px); font-weight: 500; cursor: pointer; white-space: nowrap; transition: all 0.2s; }
.cat-chip:hover { border-color: var(--tenant-primario, #002D72); color: var(--tenant-primario, #002D72); }
.cat-chip.active { background: var(--tenant-primario, #002D72); border-color: var(--tenant-primario, #002D72); color: white; }

/* ── GRID DE PRODUCTOS ── */
.product-grid { flex: 1; display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: var(--espacio-4, 16px); overflow-y: auto; align-content: start; }
.product-card { background: var(--color-superficie, #fff); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 12px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; cursor: pointer; transition: all 0.2s; padding: var(--espacio-3, 12px); box-shadow: 0 1px 2px rgba(0,0,0,0.02); }
.product-card:hover { transform: translateY(-3px); border-color: var(--tenant-primario, #002D72); box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
.product-card:active { transform: scale(0.96); }
.product-card:disabled { opacity: 0.6; cursor: wait; transform: none; }
.product-emoji { width: 60px; height: 60px; background: var(--color-superficie-alt, #f3f4f6); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 28px; margin-bottom: 4px; }
.product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; margin-bottom: 4px; }
.product-name { font-size: var(--font-size-sm, 13px); font-weight: 600; color: var(--tenant-texto, #111827); text-align: center; line-height: 1.2; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.product-price { font-size: var(--font-size-sm, 13px); color: var(--color-exitoso, #16a34a); font-weight: 500; }
.product-empty, .loading-state { grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--tenant-texto-muted, #6b7280); font-size: var(--font-size-md, 17px); }

/* ── CABECERA TICKET ── */
.panel-header { display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; border-bottom: 1px solid var(--color-borde, #e5e7eb); background: var(--color-superficie-alt, #f3f4f6); }
.panel-title { font-size: var(--font-size-md, 17px); font-weight: 600; color: var(--tenant-texto, #111827); }
.btn-client { background: var(--color-superficie, #fff); border: 1px solid var(--color-info, #2563eb); color: var(--color-info, #2563eb); border-radius: 20px; padding: 4px 12px; font-size: var(--font-size-xs, 11px); font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: background 0.2s; max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.btn-client svg { width: 14px; height: 14px; }
.btn-client:hover { background: rgba(37, 99, 235, 0.1); }

/* ── ITEMS DEL CARRITO ── */
.cart-items { flex: 1; overflow-y: auto; padding: 12px 20px; display: flex; flex-direction: column; gap: 12px; }
.cart-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; color: var(--tenant-texto-muted, #6b7280); opacity: 0.6; }
.cart-empty svg { width: 48px; height: 48px; }
.cart-item { display: grid; grid-template-columns: 1fr auto auto; align-items: flex-start; gap: 12px; padding-bottom: 12px; border-bottom: 1px dashed var(--color-borde, #e5e7eb); }
.item-info { display: flex; flex-direction: column; }
.item-name { font-size: var(--font-size-sm, 13px); font-weight: 600; color: var(--tenant-texto, #111827); }
.item-unit { font-size: var(--font-size-xs, 11px); color: var(--tenant-texto-muted, #6b7280); }
.mods-text { font-size: 10px; color: var(--tenant-primario); font-style: italic; }
.item-mods-list { margin: 4px 0 0 0; padding-left: 8px; list-style: none; font-size: 11px; color: var(--tenant-texto-muted, #6b7280); }
.item-mods-list li { margin-bottom: 2px; }

.qty-controls { display: flex; align-items: center; background: var(--color-superficie-alt, #f3f4f6); border-radius: 6px; overflow: hidden; border: 1px solid var(--color-borde, #e5e7eb); margin-top: 2px; }
.qty-controls button { background: none; border: none; padding: 4px 10px; font-weight: 600; cursor: pointer; color: var(--tenant-texto, #111827); transition: background 0.2s; }
.qty-controls button:hover { background: var(--color-borde, #e5e7eb); }
.qty-controls span { padding: 0 8px; font-size: var(--font-size-sm, 13px); font-weight: 600; }
.item-total { font-size: var(--font-size-md, 17px); font-weight: 600; color: var(--tenant-texto, #111827); text-align: right; min-width: 60px; margin-top: 2px;}

/* ── TOTALES Y ACCIONES ── */
.cart-totals { padding: 16px 20px; display: flex; flex-direction: column; gap: 8px; background: var(--color-superficie-alt, #f3f4f6); }
.totals-row { display: flex; justify-content: space-between; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); }
.totals-total { display: flex; justify-content: space-between; align-items: center; margin-top: 8px; padding-top: 8px; border-top: 1px solid var(--color-borde, #e5e7eb); }
.totals-total span:first-child { font-size: var(--font-size-md, 17px); font-weight: 600; color: var(--tenant-texto, #111827); }
.totals-amount { font-size: var(--font-size-xl, 24px); font-weight: 700; color: var(--color-exitoso, #16a34a); }

.cart-actions { padding: 16px 20px; display: flex; flex-direction: column; gap: 12px; border-top: 1px solid var(--color-borde, #e5e7eb); }
.actions-row { display: flex; gap: 8px; position: relative; }
.btn { border: none; border-radius: 8px; font-size: var(--font-size-sm, 13px); font-weight: 600; cursor: pointer; transition: opacity 0.2s; padding: 10px 16px; }
.btn:hover { opacity: 0.85; }
.btn-block { width: 100%; padding: 14px; font-size: var(--font-size-md, 17px); }
.btn--primary { background: var(--color-exitoso, #16a34a); color: white; }
.btn--danger { background: rgba(220, 38, 38, 0.1); color: var(--color-cancelar, #ef4444); flex: 1; }
.btn--secondary { background: var(--color-superficie-alt, #f3f4f6); border: 1px solid var(--color-borde, #e5e7eb); color: var(--tenant-texto, #111827); flex: 1; }

.payment-menu { position: absolute; bottom: 100%; right: 0; background: white; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); display: flex; flex-direction: column; overflow: hidden; z-index: 10; margin-bottom: 8px; width: 50%; }
.payment-menu button { padding: 10px 16px; text-align: left; background: none; border: none; border-bottom: 1px solid var(--color-superficie-alt, #f3f4f6); cursor: pointer; }
.payment-menu button:hover { background: var(--color-superficie-alt, #f3f4f6); }

/* ── MODALES ── */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-content { background: var(--color-superficie, #fff); padding: 24px; border-radius: 12px; width: 400px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); max-height: 90vh; display: flex; flex-direction: column; }
.form-input { width: 100%; padding: 8px 12px; border: 1px solid var(--color-borde, #e5e7eb); border-radius: 6px; }

/* Modal Opciones */
.options-modal { width: 450px; }
.modal-header { border-bottom: 1px solid var(--color-borde, #e5e7eb); padding-bottom: 12px; margin-bottom: 16px; }
.modal-header h3 { margin: 0 0 4px 0; font-size: var(--font-size-lg, 20px); color: var(--tenant-texto, #111827); }
.base-price { margin: 0; font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #6b7280); }

.options-list { flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
.option-row { display: flex; align-items: center; justify-content: space-between; padding: 12px; background: var(--color-superficie-alt, #f3f4f6); border: 1px solid var(--color-borde, #e5e7eb); border-radius: 8px; cursor: pointer; transition: border-color 0.2s; }
.option-row:hover:not(.is-disabled) { border-color: var(--tenant-primario, #002D72); }
.option-row.is-disabled { opacity: 0.7; cursor: not-allowed; }
.option-info { display: flex; align-items: center; gap: 12px; }
.option-info input[type="checkbox"] { width: 18px; height: 18px; cursor: pointer; accent-color: var(--tenant-primario, #002D72); }
.option-row.is-disabled input[type="checkbox"] { cursor: not-allowed; }
.option-name { font-size: var(--font-size-sm, 13px); font-weight: 500; color: var(--tenant-texto, #111827); }
.badge-req { font-size: 10px; background: rgba(220, 38, 38, 0.1); color: var(--color-error, #dc2626); padding: 2px 6px; border-radius: 4px; font-weight: 600; text-transform: uppercase; }
.option-price { font-size: var(--font-size-sm, 13px); font-weight: 600; color: var(--color-exitoso, #16a34a); }

.modal-actions { display: flex; gap: 12px; justify-content: flex-end; border-top: 1px solid var(--color-borde, #e5e7eb); padding-top: 16px; }

/* Modal Cliente */
.client-list { overflow-y: auto; display: flex; flex-direction: column; gap: 4px; flex: 1; }
.client-item { padding: 12px; text-align: left; background: var(--color-superficie-alt, #f3f4f6); border: none; border-radius: 6px; cursor: pointer; transition: background 0.2s; }
.client-item:hover { background: rgba(37, 99, 235, 0.1); color: var(--color-info, #2563eb); }
</style>