<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'

const router = useRouter()

// ── TIPOS ──────────────────────────────────────────────
interface CartItem {
  id: number
  name: string
  qty: number
  unitPrice: number
}

interface Product {
  id: number
  name: string
  price: number
  category: string
  emoji: string
}

// ── ESTADO ─────────────────────────────────────────────

// Carrito
const cart = ref<CartItem[]>([
  // Mock inicial — reemplazar con datos de API
  { id: 1, name: 'Chilaquiles',    qty: 1, unitPrice: 40 },
  { id: 2, name: 'Plato de fruta', qty: 3, unitPrice: 20 },
])

// Categorías de productos
const categories = ref(['Platillos', 'Bebidas', 'Extras', 'Paquetes'])
const activeCategory = ref('Platillos')

// Búsqueda
const searchQuery = ref('')

// Productos mock — reemplazar con fetch a API
const allProducts = ref<Product[]>([
  { id: 1,  name: 'Chilaquiles',    price: 40,  category: 'Platillos', emoji: '🍳' },
  { id: 2,  name: 'Enchiladas',     price: 55,  category: 'Platillos', emoji: '🌮' },
  { id: 3,  name: 'Huevos rancheros', price: 45, category: 'Platillos', emoji: '🍳' },
  { id: 4,  name: 'Plato de fruta', price: 20,  category: 'Platillos', emoji: '🍓' },
  { id: 5,  name: 'Café americano', price: 30,  category: 'Bebidas',   emoji: '☕' },
  { id: 6,  name: 'Cappuccino',     price: 38,  category: 'Bebidas',   emoji: '☕' },
  { id: 7,  name: 'Jugo de naranja',price: 25,  category: 'Bebidas',   emoji: '🍊' },
  { id: 8,  name: 'Agua mineral',   price: 18,  category: 'Bebidas',   emoji: '💧' },
  { id: 9,  name: 'Extra queso',    price: 10,  category: 'Extras',    emoji: '🧀' },
  { id: 10, name: 'Extra crema',    price: 8,   category: 'Extras',    emoji: '🥛' },
  { id: 11, name: 'Paquete desayuno', price: 90, category: 'Paquetes', emoji: '🍽️' },
])

const filteredProducts = computed(() => {
  const q = searchQuery.value.toLowerCase()
  return allProducts.value.filter(p => {
    const matchCat = p.category === activeCategory.value
    const matchSearch = q ? p.name.toLowerCase().includes(q) : true
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
const addToCart = (product: Product) => {
  const existing = cart.value.find(i => i.id === product.id)
  if (existing) {
    existing.qty++
  } else {
    cart.value.push({ id: product.id, name: product.name, qty: 1, unitPrice: product.price })
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

      <!-- ── PANEL IZQUIERDO: Carrito ── -->
      <section class="panel panel--cart">
        <div class="panel-header">
          <span class="panel-title">Ticket</span>
          <span class="ticket-badge"># —</span>
        </div>

        <!-- Items del carrito -->
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

        <!-- Totales -->
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

        <!-- Acciones -->
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

            <!-- Pago con dropdown de método -->
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

      <!-- ── PANEL DERECHO: Productos ── -->
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

        <!-- Categorías -->
        <div class="categories-bar">
          <div class="categories-scroll">
            <button
              v-for="cat in categories"
              :key="cat"
              class="cat-chip"
              :class="{ active: activeCategory === cat }"
              @click="activeCategory = cat"
            >
              {{ cat }}
            </button>
          </div>
          <button class="cat-add" title="Agregar categoría">
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          </button>
        </div>

        <!-- Grid de productos -->
        <div class="product-grid">
          <button
            v-for="product in filteredProducts"
            :key="product.id"
            class="product-card"
            @click="addToCart(product)"
          >
            <span class="product-emoji">{{ product.emoji }}</span>
            <span class="product-name">{{ product.name }}</span>
            <span class="product-price">${{ product.price }}</span>
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
  background-color: var(--tenant-fondo, #000);
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
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
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
  border-bottom: 1px solid #1a1a1a;
}

.panel-title {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--tenant-texto-muted, #78716c);
}

.ticket-badge {
  font-size: var(--font-size-xs, 11px);
  background: #181818;
  border: 1px solid #2a2a2a;
  border-radius: 20px;
  padding: 2px 10px;
  color: var(--tenant-texto-muted, #78716c);
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
  color: #2a2a2a;
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
  background: #111;
  border: 1px solid #1c1c1c;
  border-radius: 10px;
  transition: border-color 0.15s;
}

.cart-item:hover {
  border-color: #2a2a2a;
}

.item-name {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto, #fff);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.item-qty {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  background: #1a1a1a;
  border-radius: 4px;
  padding: 1px 6px;
}

.item-unit {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
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
  color: var(--tenant-texto-muted, #78716c);
}
.item-btn--edit:hover {
  background: #1a1a1a;
  color: var(--tenant-primario, #3f99ff);
}

.item-btn--delete {
  color: var(--tenant-texto-muted, #78716c);
}
.item-btn--delete:hover {
  background: rgba(220, 38, 38, 0.1);
  color: var(--color-error, #dc2626);
}

.item-total {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
  min-width: 36px;
  text-align: right;
}

/* ── TOTALES ── */
.cart-totals {
  border-top: 1px solid #1a1a1a;
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
  color: var(--tenant-texto-muted, #78716c);
}

.totals-discount {
  color: var(--color-exitoso, #16a34a);
}

.totals-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #111;
  border: 1px solid #222;
  border-radius: 12px;
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
}

.totals-total span:first-child {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto-muted, #78716c);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.totals-amount {
  font-size: var(--font-size-xl, 24px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
}

/* ── BOTONES DE ACCIÓN ── */
.cart-actions {
  border-top: 1px solid #1a1a1a;
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
  background: #111;
  border-color: #1e1e1e;
  color: var(--tenant-texto, #fff);
  flex-direction: column;
  gap: 2px;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
}

.btn--ghost:hover {
  background: #1a1a1a;
  border-color: #2a2a2a;
}

.btn-sub {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  line-height: 1;
}

.btn--cancel {
  flex: 1;
  background: rgba(253, 141, 141, 0.06);
  border-color: rgba(253, 141, 141, 0.15);
  color: var(--color-cancelar, #fd8d8d);
}

.btn--cancel:hover {
  background: rgba(253, 141, 141, 0.12);
  border-color: rgba(253, 141, 141, 0.3);
}

/* ── PAGO ── */
.payment-group {
  flex: 2;
  display: flex;
  gap: 2px;
}

.btn--payment {
  flex: 1;
  background: var(--tenant-primario, #3f99ff);
  color: #fff;
  border-color: transparent;
  border-radius: 10px 0 0 10px;
  gap: var(--espacio-2, 8px);
}

.btn--payment:hover {
  background: #2d87eb;
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
  background: #2d87eb;
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
  background: #1a74d8;
}

.btn--payment-toggle svg {
  width: 16px;
  height: 16px;
}

.payment-menu {
  position: absolute;
  bottom: calc(100% + 6px);
  right: 0;
  background: #111;
  border: 1px solid #2a2a2a;
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
  color: var(--tenant-texto, #fff);
  transition: background 0.15s;
}

.payment-menu-item:hover {
  background: #1a1a1a;
}

.payment-menu-item.active {
  color: var(--tenant-primario, #3f99ff);
  background: rgba(63, 153, 255, 0.08);
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
  background: #111;
  border: 1px solid #1e1e1e;
  border-radius: 50px;
  padding: var(--espacio-2, 8px) var(--espacio-4, 16px);
  transition: border-color 0.2s;
}

.search-bar:focus-within {
  border-color: var(--tenant-primario, #3f99ff);
}

.search-icon {
  width: 16px;
  height: 16px;
  color: var(--tenant-texto-muted, #78716c);
  flex-shrink: 0;
}

.search-input {
  background: none;
  border: none;
  outline: none;
  color: var(--tenant-texto, #fff);
  font-size: var(--font-size-sm, 13px);
  font-family: var(--tenant-fuente, sans-serif);
  width: 100%;
}

.search-input::placeholder {
  color: var(--tenant-texto-muted, #78716c);
}

.venta-title {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
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
  background: #111;
  border: 1px solid #1e1e1e;
  color: var(--tenant-texto-muted, #78716c);
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
  border-color: #2a2a2a;
  color: var(--tenant-texto, #fff);
}

.cat-chip.active {
  background: var(--tenant-primario, #3f99ff);
  border-color: var(--tenant-primario, #3f99ff);
  color: #fff;
}

.cat-add {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: #111;
  border: 1px solid #1e1e1e;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--tenant-texto-muted, #78716c);
  flex-shrink: 0;
  transition: background 0.15s, color 0.15s;
}

.cat-add:hover {
  background: #1a1a1a;
  color: var(--tenant-texto, #fff);
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
  scrollbar-color: #1e1e1e transparent;
  min-height: 0;
}

.product-card {
  background: #111;
  border: 1px solid #1c1c1c;
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
  border-color: var(--tenant-primario, #3f99ff);
  background: rgba(63, 153, 255, 0.04);
}

.product-card:active {
  transform: scale(0.97);
}

.product-emoji {
  font-size: 1.8rem;
  line-height: 1;
}

.product-name {
  font-size: var(--font-size-sm, 13px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto, #fff);
  text-align: center;
  line-height: 1.2;
}

.product-price {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
}

.product-empty {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--tenant-texto-muted, #78716c);
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