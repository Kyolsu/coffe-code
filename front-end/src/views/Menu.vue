<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ──────────────────────────────────────────────
interface Product {
  id: number
  name: string
  price: number
  category: string
  emoji: string
}

interface Promo {
  id: number
  name: string
  discount: string
}

interface Package {
  id: number
  name: string
  price: number
}

// ── ESTADO ─────────────────────────────────────────────

// Productos mock — TODO: GET /productos
const products = ref<Product[]>([
  { id: 1,  name: 'Chilaquiles',      price: 40,  category: 'Platillos', emoji: '🍳' },
  { id: 2,  name: 'Enchiladas',       price: 55,  category: 'Platillos', emoji: '🌮' },
  { id: 3,  name: 'Huevos rancheros', price: 45,  category: 'Platillos', emoji: '🍳' },
  { id: 4,  name: 'Plato de fruta',   price: 20,  category: 'Platillos', emoji: '🍓' },
  { id: 5,  name: 'Molletes',         price: 35,  category: 'Platillos', emoji: '🍞' },
  { id: 6,  name: 'Quesadillas',      price: 30,  category: 'Platillos', emoji: '🫓' },
  { id: 7,  name: 'Café americano',   price: 30,  category: 'Bebidas',   emoji: '☕' },
  { id: 8,  name: 'Cappuccino',       price: 38,  category: 'Bebidas',   emoji: '☕' },
  { id: 9,  name: 'Jugo de naranja',  price: 25,  category: 'Bebidas',   emoji: '🍊' },
  { id: 10, name: 'Agua mineral',     price: 18,  category: 'Bebidas',   emoji: '💧' },
  { id: 11, name: 'Extra queso',      price: 10,  category: 'Extras',    emoji: '🧀' },
  { id: 12, name: 'Extra crema',      price: 8,   category: 'Extras',    emoji: '🥛' },
])

// Promociones mock — TODO: GET /promociones
const promos = ref<Promo[]>([
  { id: 1, name: '2x1 Café lunes',   discount: '50%' },
  { id: 2, name: 'Combo desayuno',   discount: '$20' },
  { id: 3, name: 'Happy hour 3-5pm', discount: '30%' },
  { id: 4, name: 'Cumpleaños',       discount: '15%' },
])

// Paquetes mock — TODO: GET /paquetes
const packages = ref<Package[]>([
  { id: 1, name: 'Desayuno completo', price: 90 },
  { id: 2, name: 'Café y pan',        price: 45 },
  { id: 3, name: 'Brunch ejecutivo',  price: 120 },
])

// Búsqueda
const searchQuery = ref('')

const filteredProducts = computed(() => {
  const q = searchQuery.value.toLowerCase()
  return q
    ? products.value.filter(p => p.name.toLowerCase().includes(q))
    : products.value
})

// ── ACCIONES ────────────────────────────────────────────
// TODO: abrir modal de creación/edición conectado a la API

const addProduct    = () => { /* TODO: abrir modal nuevo producto */ }
const editProduct   = (id: number) => { /* TODO: abrir modal editar producto */ console.log('edit product', id) }
const deleteProduct = (id: number) => { /* TODO: DELETE /productos/:id */ products.value = products.value.filter(p => p.id !== id) }

const addPromo    = () => { /* TODO: abrir modal nueva promo */ }
const editPromo   = (id: number) => { /* TODO: abrir modal editar promo */ console.log('edit promo', id) }
const deletePromo = (id: number) => { /* TODO: DELETE /promociones/:id */ promos.value = promos.value.filter(p => p.id !== id) }

const addPackage    = () => { /* TODO: abrir modal nuevo paquete */ }
const editPackage   = (id: number) => { /* TODO: abrir modal editar paquete */ console.log('edit package', id) }
const deletePackage = (id: number) => { /* TODO: DELETE /paquetes/:id */ packages.value = packages.value.filter(p => p.id !== id) }
</script>

<template>
  <div class="menu-layout">
    <Sidebar />

    <main class="menu-main">

      <h1 class="page-title">Menú y productos</h1>

      <div class="menu-body">

        <!-- ── COLUMNA IZQUIERDA: Productos ── -->
        <section class="col col--products">

          <!-- Barra de búsqueda + agregar -->
          <div class="section-bar">
            <div class="search-bar">
              <svg class="search-icon" viewBox="0 0 24 24" fill="none">
                <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/>
                <path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Buscar producto..."
                class="search-input"
              />
            </div>
            <button class="add-btn" @click="addProduct" title="Agregar producto">
              <svg viewBox="0 0 24 24" fill="none">
                <path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
            </button>
          </div>

          <!-- Grid de productos -->
          <div class="product-grid">
            <div
              v-for="product in filteredProducts"
              :key="product.id"
              class="product-card"
            >
              <span class="product-emoji">{{ product.emoji }}</span>
              <span class="product-name">{{ product.name }}</span>
              <span class="product-price">${{ product.price }}</span>
              <div class="card-actions">
                <button class="card-btn card-btn--edit" @click="editProduct(product.id)" title="Editar">
                  <svg viewBox="0 0 24 24" fill="none">
                    <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                    <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
                <button class="card-btn card-btn--delete" @click="deleteProduct(product.id)" title="Eliminar">
                  <svg viewBox="0 0 24 24" fill="none">
                    <polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                    <path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                    <path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/>
                  </svg>
                </button>
              </div>
            </div>

            <div v-if="filteredProducts.length === 0" class="grid-empty">
              Sin resultados
            </div>
          </div>
        </section>

        <!-- ── COLUMNA DERECHA: Promos + Paquetes ── -->
        <section class="col col--right">

          <!-- Promociones -->
          <div class="right-section">
            <div class="section-bar">
              <span class="section-label">Promociones</span>
              <button class="add-btn" @click="addPromo" title="Agregar promoción">
                <svg viewBox="0 0 24 24" fill="none">
                  <path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                </svg>
              </button>
            </div>
            <div class="mini-grid">
              <div
                v-for="promo in promos"
                :key="promo.id"
                class="mini-card"
              >
                <div class="mini-card-top">
                  <span class="mini-card-badge">{{ promo.discount }}</span>
                </div>
                <span class="mini-card-name">{{ promo.name }}</span>
                <div class="card-actions">
                  <button class="card-btn card-btn--edit" @click="editPromo(promo.id)" title="Editar">
                    <svg viewBox="0 0 24 24" fill="none">
                      <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                      <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                  </button>
                  <button class="card-btn card-btn--delete" @click="deletePromo(promo.id)" title="Eliminar">
                    <svg viewBox="0 0 24 24" fill="none">
                      <polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                      <path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                      <path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Paquetes -->
          <div class="right-section">
            <div class="section-bar">
              <span class="section-label">Paquetes</span>
              <button class="add-btn" @click="addPackage" title="Agregar paquete">
                <svg viewBox="0 0 24 24" fill="none">
                  <path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                </svg>
              </button>
            </div>
            <div class="mini-grid">
              <div
                v-for="pkg in packages"
                :key="pkg.id"
                class="mini-card"
              >
                <div class="mini-card-top">
                  <span class="mini-card-price">${{ pkg.price }}</span>
                </div>
                <span class="mini-card-name">{{ pkg.name }}</span>
                <div class="card-actions">
                  <button class="card-btn card-btn--edit" @click="editPackage(pkg.id)" title="Editar">
                    <svg viewBox="0 0 24 24" fill="none">
                      <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                      <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                  </button>
                  <button class="card-btn card-btn--delete" @click="deletePackage(pkg.id)" title="Eliminar">
                    <svg viewBox="0 0 24 24" fill="none">
                      <polyline points="3,6 5,6 21,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                      <path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                      <path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>

        </section>
      </div>

      <!-- Watermark -->
      <div class="watermark">
        <span class="watermark-label">Software por</span>
        <strong class="watermark-brand">CoffeeCode</strong>
      </div>
    </main>
  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
.menu-layout {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo, #000);
}

.menu-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: var(--espacio-5, 20px) var(--espacio-6, 24px);
  gap: var(--espacio-4, 16px);
  overflow: hidden;
  position: relative;
}

.page-title {
  margin: 0;
  font-size: var(--font-size-2xl, 30px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
  text-align: right;
}

/* ── BODY: DOS COLUMNAS ── */
.menu-body {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 340px;
  gap: var(--espacio-4, 16px);
  overflow: hidden;
  min-height: 0;
}

/* ── COLUMNAS ── */
.col {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
  overflow: hidden;
}

.col--right {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-4, 16px);
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: #1e1e1e transparent;
}

/* ── BARRA DE SECCIÓN ── */
.section-bar {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
}

.section-label {
  flex: 1;
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  border-radius: 50px;
  padding: var(--espacio-2, 8px) var(--espacio-5, 20px);
  text-align: center;
}

/* ── BÚSQUEDA ── */
.search-bar {
  flex: 1;
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
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

/* ── BOTÓN AGREGAR ── */
.add-btn {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--tenant-texto-muted, #78716c);
  flex-shrink: 0;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
}

.add-btn:hover {
  background: rgba(63, 153, 255, 0.08);
  border-color: var(--tenant-primario, #3f99ff);
  color: var(--tenant-primario, #3f99ff);
}

.add-btn svg {
  width: 16px;
  height: 16px;
}

/* ── GRID PRINCIPAL DE PRODUCTOS ── */
.product-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: minmax(110px, auto);
  gap: var(--espacio-3, 12px);
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: #1e1e1e transparent;
  align-content: start;
  min-height: 0;
}

.product-card {
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  border-radius: 14px;
  padding: var(--espacio-3, 12px);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 3px;
  transition: border-color 0.15s;
  position: relative;
}

.product-card:hover {
  border-color: #2a2a2a;
}

.product-emoji {
  font-size: 1.6rem;
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
  margin-bottom: var(--espacio-1, 4px);
}

/* ── ACCIONES (editar / borrar) ── */
.card-actions {
  display: flex;
  gap: var(--espacio-2, 8px);
  margin-top: auto;
}

.card-btn {
  width: 28px;
  height: 28px;
  border-radius: 7px;
  border: 1px solid #1e1e1e;
  background: #111;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
  padding: 0;
}

.card-btn svg {
  width: 13px;
  height: 13px;
}

.card-btn--edit {
  color: var(--tenant-texto-muted, #78716c);
}

.card-btn--edit:hover {
  background: rgba(63, 153, 255, 0.1);
  border-color: rgba(63, 153, 255, 0.25);
  color: var(--tenant-primario, #3f99ff);
}

.card-btn--delete {
  color: var(--tenant-texto-muted, #78716c);
}

.card-btn--delete:hover {
  background: rgba(220, 38, 38, 0.1);
  border-color: rgba(220, 38, 38, 0.25);
  color: var(--color-error, #dc2626);
}

.grid-empty {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--tenant-texto-muted, #78716c);
  font-size: var(--font-size-sm, 13px);
  padding: var(--espacio-8, 32px) 0;
}

/* ── SECCIONES DE COLUMNA DERECHA ── */
.right-section {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3, 12px);
}

/* ── MINI GRID (promos / paquetes) ── */
.mini-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--espacio-3, 12px);
}

.mini-card {
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  border-radius: 14px;
  padding: var(--espacio-3, 12px) var(--espacio-2, 8px);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  transition: border-color 0.15s;
}

.mini-card:hover {
  border-color: #2a2a2a;
}

.mini-card-top {
  height: 20px;
  display: flex;
  align-items: center;
}

.mini-card-badge {
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-bold, 600);
  background: rgba(22, 163, 74, 0.1);
  color: var(--color-exitoso, #16a34a);
  border: 1px solid rgba(22, 163, 74, 0.2);
  border-radius: 20px;
  padding: 1px 8px;
}

.mini-card-price {
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-primario, #3f99ff);
}

.mini-card-name {
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto, #fff);
  text-align: center;
  line-height: 1.2;
  flex: 1;
  display: flex;
  align-items: center;
}

/* ── WATERMARK ── */
.watermark {
  position: absolute;
  bottom: var(--espacio-5, 20px);
  right: var(--espacio-6, 24px);
  text-align: right;
  display: flex;
  flex-direction: column;
  gap: 1px;
  pointer-events: none;
}

.watermark-label {
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.watermark-brand {
  font-size: var(--font-size-md, 17px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-primario, #3f99ff);
  letter-spacing: -0.02em;
}
</style>