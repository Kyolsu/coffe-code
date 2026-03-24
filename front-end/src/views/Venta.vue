<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── TIPOS ──────────────────────────────────────────────
interface CartItem {
  id: number
  name: string
  qty: number
  unitPrice: number
}

interface Producto {
  id_producto: number
  nombre_producto: string
  precio_base: number
  id_categoria: number
  url_imagen: string
}

interface Categoria {
  id_categoria: number
  nombre: string
}

// ── ESTADO ─────────────────────────────────────────────

// Carrito
const cart = ref<CartItem[]>([])

// Categorías de productos reales
const categorias = ref<Categoria[]>([])
const activeCategoryId = ref<number>(0) // 0 representará "Todos"

// Búsqueda
const searchQuery = ref('')

// Productos reales de la API
const allProducts = ref<Producto[]>([])

// ── FETCH DATOS REALES ─────────────────────────────────
const fetchCategorias = async () => {
  try {
    const res = await fetch(`${API_URL}/api/tienda/categorias/mostrar`)
    const data = await res.json()
    const cats = data.status === 'ok' ? (data.datos || []).map((c: any) => ({
      id_categoria: c.id_categoria || c.id,
      nombre: c.nombre_categoria || c.nombre || c.categoria || 'Sin nombre'
    })) : []
    
    // Agregamos "Todos" al inicio de la lista
    categorias.value = [{ id_categoria: 0, nombre: 'Todos' }, ...cats]
  } catch (error) { console.error("Error categorías:", error) }
}

const fetchProductos = async () => {
  try {
    const res = await fetch(`${API_URL}/api/productos/mostrar`, {
      headers: authStore.authHeaders()
    })
    const data = await res.json()
    allProducts.value = data.status === 'ok' ? (data.datos || []).map((p: any) => ({
      id_producto: p.id_producto || p.id,
      nombre_producto: p.nombre_producto || p.nombre || 'Producto',
      precio_base: Number(p.precio_base || p.precio || 0),
      id_categoria: p.id_categoria || 0,
      url_imagen: p.url_imagen || ''
    })) : []
  } catch (error) { console.warn("Error productos:", error) }
}

onMounted(() => {
  fetchCategorias()
  fetchProductos()
})

// ── COMPUTADOS (Filtro Funcional) ──────────────────────
const filteredProducts = computed(() => {
  return allProducts.value.filter(p => {
    // Coincidir categoría (0 = Todos)
    const matchCat = activeCategoryId.value === 0 || p.id_categoria === activeCategoryId.value
    // Coincidir búsqueda
    const matchSearch = p.nombre_producto.toLowerCase().includes(searchQuery.value.toLowerCase())
    
    return matchCat && matchSearch
  })
})

// Método de pago
const paymentMethods = ['Efectivo', 'Tarjeta']
const selectedPayment = ref('Efectivo')
const showPaymentMenu = ref(false)

const selectPayment = (method: string) => {
  selectedPayment.value = method
  showPaymentMenu.value = false
}

// ── CÁLCULOS ────────────────────────────────────────────
const IVA_RATE = 0.16

const subtotal = computed(() =>
  cart.value.reduce((acc, item) => acc + item.qty * item.unitPrice, 0)
)
const discount = computed(() => 0) // placeholder para descuentos
const taxBase  = computed(() => subtotal.value - discount.value)
const iva      = computed(() => Math.round(taxBase.value * IVA_RATE))
const total    = computed(() => taxBase.value + iva.value)

// ── ACCIONES DEL CARRITO ────────────────────────────────
const addToCart = (product: Producto) => {
  const existing = cart.value.find(i => i.id === product.id_producto)
  if (existing) {
    existing.qty++
  } else {
    cart.value.push({ 
      id: product.id_producto, 
      name: product.nombre_producto, 
      qty: 1, 
      unitPrice: product.precio_base 
    })
  }
}

const removeItem = (id: number) => {
  cart.value = cart.value.filter(i => i.id !== id)
}

const editItem = (id: number) => {
  // TODO: abrir modal de edición cuando exista la API
  console.log('Editar item', id)
}

// ── BOTONES PRINCIPALES ─────────────────────────────────
const clearCart  = () => { cart.value = [] }
const assignRFID = () => { /* TODO: leer tarjeta RFID */ }
const saveOrder  = () => { /* TODO: POST /ordenes */ }
const cancelSale = () => router.push({ name: 'dashboard' })
const processPay = () => { /* TODO: POST /pagos */ }
</script>

<template>
  <div class="venta-layout">
    <Sidebar />

    <div class="venta-main">

      <section class="panel panel--cart">
        <div class="panel-header">
          <span class="panel-title">Ticket</span>
          <span class="ticket-badge"># —</span>
        </div>

        <div class="cart-items">
          <div v-if="cart.length === 0" class="cart-empty">
            <svg viewBox="0 0 24 24" fill="none"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/><line x1="3" y1="6" x2="21" y2="6" stroke="currentColor" stroke-width="1.5"/><path d="M16 10a4 4 0 01-8 0" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <p>Sin productos</p>
          </div>

          <div
            v-for="item in cart"
            :key="item.id"
            class="cart-item"
          >
            <span class="item-name">{{ item.name }}</span>
            <span class="item-qty">{{ item.qty }}</span>
            <span class="item-unit">${{ item.unitPrice }}</span>
            <button class="item-btn item-btn--edit" @click="editItem(item.id)" title="Editar">
              <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
            </button>
            <span class="item-total">${{ item.qty * item.unitPrice }}</span>
            <button class="item-btn item-btn--delete" @click="removeItem(item.id)" title="Eliminar">
              <svg viewBox="0 0 24 24" fill="none"><polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M10 11v6M14 11v6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/></svg>
            </button>
          </div>
        </div>

        <div class="cart-totals">
          <div class="totals-breakdown">
            <div class="totals-row">
              <span>Subtotal</span>
              <span>${{ subtotal }}</span>
            </div>
            <div class="totals-row">
              <span>Descuento</span>
              <span class="totals-discount">-${{ discount }}</span>
            </div>
            <div class="totals-row">
              <span>IVA (16%)</span>
              <span>${{ iva }}</span>
            </div>
          </div>
          <div class="totals-total">
            <span>Total</span>
            <span class="totals-amount">${{ total }}</span>
          </div>
        </div>

        <div class="cart-actions">
          <div class="actions-row actions-row--top">
            <button class="btn btn--ghost" @click="clearCart">
              <svg viewBox="0 0 24 24" fill="none"><polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
              Borrar
            </button>
            <button class="btn btn--ghost" @click="assignRFID">
              <svg viewBox="0 0 24 24" fill="none"><rect x="2" y="5" width="20" height="14" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M2 10h20" stroke="currentColor" stroke-width="1.5"/></svg>
              Cliente
              <span class="btn-sub">RFID</span>
            </button>
            <button class="btn btn--ghost" @click="saveOrder">
              <svg viewBox="0 0 24 24" fill="none"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/><polyline points="17,21 17,13 7,13 7,21" stroke="currentColor" stroke-width="1.5"/><polyline points="7,3 7,8 15,8" stroke="currentColor" stroke-width="1.5"/></svg>
              Guardar
            </button>
          </div>

          <div class="actions-row actions-row--bottom">
            <button class="btn btn--cancel" @click="cancelSale">
              <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
              Cancelar
            </button>

            <div class="payment-group">
              <button class="btn btn--payment" @click="processPay">
                <svg viewBox="0 0 24 24" fill="none"><rect x="2" y="5" width="20" height="14" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M2 10h20" stroke="currentColor" stroke-width="1.5"/></svg>
                <div class="payment-label">
                  <span class="payment-main">PAGO</span>
                  <span class="payment-method">{{ selectedPayment }}</span>
                </div>
              </button>
              <div class="payment-dropdown-wrap">
                <button
                  class="btn btn--payment-toggle"
                  @click="showPaymentMenu = !showPaymentMenu"
                  title="Cambiar método de pago"
                >
                  <svg viewBox="0 0 24 24" fill="none"><path d="M6 9l6 6 6-6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
                <Transition name="dropdown">
                  <div v-if="showPaymentMenu" class="payment-menu">
                    <button
                      v-for="method in paymentMethods"
                      :key="method"
                      class="payment-menu-item"
                      :class="{ active: selectedPayment === method }"
                      @click="selectPayment(method)"
                    >
                      {{ method }}
                    </button>
                  </div>
                </Transition>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="panel panel--products">
        <div class="products-top">
          <div class="search-bar">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/><path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Buscar producto..."
              class="search-input"
            />
          </div>
          <h2 class="venta-title">Venta</h2>
        </div>

        <div class="categories-bar">
          <div class="categories-scroll">
            <button
              v-for="cat in categorias"
              :key="cat.id_categoria"
              class="cat-chip"
              :class="{ active: activeCategoryId === cat.id_categoria }"
              @click="activeCategoryId = cat.id_categoria"
            >
              {{ cat.nombre }}
            </button>
          </div>
          <button class="cat-add" title="Agregar categoría">
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          </button>
        </div>

        <div class="product-grid">
          <button
            v-for="product in filteredProducts"
            :key="product.id_producto"
            class="product-card"
            @click="addToCart(product)"
          >
            <img v-if="product.url_imagen" :src="product.url_imagen" class="product-img" />
            <span v-else class="product-emoji">🍽️</span>
            
            <span class="product-name">{{ product.nombre_producto }}</span>
            <span class="product-price">${{ product.precio_base.toFixed(2) }}</span>
          </button>

          <div v-if="filteredProducts.length === 0" class="product-empty">
            Sin resultados
          </div>
        </div>
      </section>

    </div>
  </div>
</template>

<style scoped>
/* ── LAYOUT RAÍZ ── */
.venta-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
}

.venta-main {
  flex: 1;
  display: flex;
  gap: var(--espacio-4, 16px);
  padding: var(--espacio-5, 20px);
  overflow: hidden;
  min-height: 0;
}

/* ── PANELES ── */
.panel {
  background: color-mix(in srgb, var(--tenant-fondo) 95%, black 5%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.panel--cart {
  width: 360px;
  flex-shrink: 0;
  gap: 0;
}

.panel--products {
  flex: 1;
  gap: var(--espacio-4, 16px);
  padding: var(--espacio-5, 20px);
  overflow: hidden;
}

/* ── CABECERA PANEL CART ── */
.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--espacio-4, 16px) var(--espacio-5, 20px);
  border-bottom: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
}

.panel-title {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

.ticket-badge {
  font-size: var(--font-size-xs, 11px);
  background: color-mix(in srgb, var(--tenant-texto) 6%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent);
  border-radius: 20px;
  padding: 2px 10px;
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

/* ── ITEMS DEL CARRITO ── */
.cart-items {
  flex: 1;
  overflow-y: auto;
  padding: var(--espacio-3, 12px) var(--espacio-5, 20px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-2, 8px);
  min-height: 0;
}

.cart-empty {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-3, 12px);
  color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
  padding: var(--espacio-8, 32px) 0;
}

.cart-empty svg {
  width: 40px;
  height: 40px;
}

.cart-empty p {
  margin: 0;
  font-size: var(--font-size-sm, 13px);
}

.cart-item {
  display: grid;
  grid-template-columns: 1fr auto auto auto auto auto;
  align-items: center;
  gap: var(--espacio-2, 8px);
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 10px;
  transition: border-color 0.15s;
}

.cart-item:hover {
  border-color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
}

.item-name {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.item-qty {
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  border-radius: 4px;
  padding: 1px 6px;
}

.item-unit {
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

.item-btn {
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 6px;
  transition: background 0.15s, color 0.15s;
  padding: 0;
}

.item-btn svg {
  width: 13px;
  height: 13px;
}

.item-btn--edit {
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}
.item-btn--edit:hover {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  color: var(--tenant-primario);
}

.item-btn--delete {
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}
.item-btn--delete:hover {
  background: color-mix(in srgb, var(--color-error, #dc2626) 10%, transparent);
  color: var(--color-error, #dc2626);
}

.item-total {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
  min-width: 36px;
  text-align: right;
}

/* ── TOTALES ── */
.cart-totals {
  border-top: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  padding: var(--espacio-4, 16px) var(--espacio-5, 20px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
}

.totals-breakdown {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-1, 4px);
}

.totals-row {
  display: flex;
  justify-content: space-between;
  font-size: var(--font-size-sm, 13px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

.totals-discount {
  color: var(--color-exitoso, #16a34a);
}

.totals-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 12px;
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
}

.totals-total span:first-child {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.totals-amount {
  font-size: var(--font-size-xl, 24px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
}

/* ── BOTONES DE ACCIÓN ── */
.cart-actions {
  border-top: 1px solid color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  padding: var(--espacio-4, 16px) var(--espacio-5, 20px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-2, 8px);
}

.actions-row {
  display: flex;
  gap: var(--espacio-2, 8px);
}

.btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-2, 8px);
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  border-radius: 10px;
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  cursor: pointer;
  border: 1px solid transparent;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
  white-space: nowrap;
}

.btn svg {
  width: 15px;
  height: 15px;
  flex-shrink: 0;
}

.btn--ghost {
  flex: 1;
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border-color: color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  color: var(--tenant-texto);
  flex-direction: column;
  gap: 2px;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
}

.btn--ghost:hover {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  border-color: color-mix(in srgb, var(--tenant-texto) 15%, transparent);
}

.btn-sub {
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  line-height: 1;
}

.btn--cancel {
  flex: 1;
  background: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 6%, transparent);
  border-color: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 15%, transparent);
  color: var(--color-cancelar, #fd8d8d);
}

.btn--cancel:hover {
  background: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 12%, transparent);
  border-color: color-mix(in srgb, var(--color-cancelar, #fd8d8d) 30%, transparent);
}

/* ── PAGO ── */
.payment-group {
  flex: 2;
  display: flex;
  gap: 2px;
}

.btn--payment {
  flex: 1;
  background: var(--tenant-primario);
  color: #fff;
  border-color: transparent;
  border-radius: 10px 0 0 10px;
  gap: var(--espacio-2, 8px);
}

.btn--payment:hover {
  background: color-mix(in srgb, var(--tenant-primario) 80%, black 20%);
}

.payment-label {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 1px;
}

.payment-main {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  line-height: 1;
}

.payment-method {
  font-size: var(--font-size-xs, 11px);
  opacity: 0.75;
  line-height: 1;
}

.payment-dropdown-wrap {
  position: relative;
}

.btn--payment-toggle {
  height: 100%;
  background: color-mix(in srgb, var(--tenant-primario) 80%, black 20%);
  border: none;
  border-radius: 0 10px 10px 0;
  padding: 0 var(--espacio-2, 8px);
  cursor: pointer;
  color: #fff;
  display: flex;
  align-items: center;
  transition: background 0.15s;
}

.btn--payment-toggle:hover {
  background: color-mix(in srgb, var(--tenant-primario) 60%, black 40%);
}

.btn--payment-toggle svg {
  width: 16px;
  height: 16px;
}

.payment-menu {
  position: absolute;
  bottom: calc(100% + 6px);
  right: 0;
  background: color-mix(in srgb, var(--tenant-fondo) 90%, black 10%);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 15%, transparent);
  border-radius: 10px;
  overflow: hidden;
  min-width: 120px;
  z-index: 50;
  box-shadow: 0 8px 24px rgba(0,0,0,0.6);
}

.payment-menu-item {
  display: block;
  width: 100%;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  text-align: left;
  background: none;
  border: none;
  cursor: pointer;
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto);
  transition: background 0.15s;
}

.payment-menu-item:hover {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
}

.payment-menu-item.active {
  color: var(--tenant-primario);
  background: color-mix(in srgb, var(--tenant-primario) 8%, transparent);
}

/* ── PANEL PRODUCTOS: TOP ── */
.products-top {
  display: flex;
  align-items: center;
  gap: var(--espacio-4, 16px);
}

.search-bar {
  flex: 1;
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 50px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  transition: border-color 0.2s;
}

.search-bar:focus-within {
  border-color: var(--tenant-primario);
}

.search-icon {
  width: 16px;
  height: 16px;
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  flex-shrink: 0;
}

.search-input {
  background: none;
  border: none;
  outline: none;
  color: var(--tenant-texto);
  font-size: var(--font-size-sm, 13px);
  font-family: var(--tenant-fuente, sans-serif);
  width: 100%;
}

.search-input::placeholder {
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

.venta-title {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto);
  white-space: nowrap;
}

/* ── CATEGORÍAS ── */
.categories-bar {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
}

.categories-scroll {
  display: flex;
  gap: var(--espacio-2, 8px);
  overflow-x: auto;
  flex: 1;
  scrollbar-width: none;
}

.categories-scroll::-webkit-scrollbar {
  display: none;
}

.cat-chip {
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  border-radius: 50px;
  padding: var(--espacio-1, 4px) var(--espacio-4, 16px);
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  cursor: pointer;
  white-space: nowrap;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
  font-family: var(--tenant-fuente, sans-serif);
}

.cat-chip:hover {
  border-color: color-mix(in srgb, var(--tenant-texto) 20%, transparent);
  color: var(--tenant-texto);
}

.cat-chip.active {
  background: var(--tenant-primario);
  border-color: var(--tenant-primario);
  color: #fff;
}

.cat-add {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  flex-shrink: 0;
  transition: background 0.15s, color 0.15s;
}

.cat-add:hover {
  background: color-mix(in srgb, var(--tenant-texto) 8%, transparent);
  color: var(--tenant-texto);
}

.cat-add svg {
  width: 16px;
  height: 16px;
}

/* ── GRID DE PRODUCTOS ── */
.product-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: minmax(100px, 1fr);
  gap: var(--espacio-3, 12px);
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: color-mix(in srgb, var(--tenant-texto) 10%, transparent) transparent;
  min-height: 0;
}

.product-card {
  background: color-mix(in srgb, var(--tenant-texto) 4%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  border-radius: 14px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-1, 4px);
  cursor: pointer;
  transition: transform 0.15s, border-color 0.15s, background 0.15s;
  padding: var(--espacio-3, 12px);
  font-family: var(--tenant-fuente, sans-serif);
}

.product-card:hover {
  transform: translateY(-2px);
  border-color: var(--tenant-primario);
  background: color-mix(in srgb, var(--tenant-primario) 8%, transparent);
}

.product-card:active {
  transform: scale(0.97);
}

.product-emoji {
  font-size: 1.8rem;
  line-height: 1;
}

.product-img {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 4px;
}

.product-name {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto);
  text-align: center;
  line-height: 1.2;
}

.product-price {
  font-size: var(--font-size-xs, 11px);
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
}

.product-empty {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  font-size: var(--font-size-sm, 13px);
}

/* ── TRANSICIONES ── */
.dropdown-enter-active,
.dropdown-leave-active {
  transition: opacity 0.15s, transform 0.15s;
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(4px);
}
</style>