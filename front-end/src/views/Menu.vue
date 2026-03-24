<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Sidebar from '@/components/Sidebar.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
// Validamos el rol convirtiéndolo a número
const esAdmin = Number(authStore.rol) === 1
const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// Sistema de Pestañas
const pestanaActual = ref('Menús')
const pestanas = ['Menús', 'Paquetes', 'Productos', 'Zonas', 'Ingredientes']

// Variables reactivas
const menus = ref<any[]>([])
const paquetes = ref<any[]>([])
const productos = ref<any[]>([])
const zonas = ref<any[]>([])
const ingredientes = ref<any[]>([])

// ══════════════════════════════════════════════════════
//  PETICIONES AL BACKEND
// ══════════════════════════════════════════════════════

const fetchMenus = async () => {
  try {
    const res = await fetch(`${API_URL}/api/menu/mostrar-activo`, {
      headers: authStore.authHeaders()
    })
    const data = await res.json()
    menus.value = data.status === 'ok' ? data.datos : []
  } catch (error) { console.error("Error menús:", error) }
}

const fetchProductos = async () => {
  try {
    // ⚠️ Ajusta la ruta si tu backend tiene otro nombre
    const res = await fetch(`${API_URL}/api/productos/mostrar`, {
      headers: authStore.authHeaders()
    })
    const data = await res.json()
    productos.value = data.status === 'ok' ? data.datos : []
  } catch (error) { console.error("Error productos:", error) }
}

const fetchZonas = async () => {
  try {
    const res = await fetch(`${API_URL}/api/tienda/zonas/mostrar`)
    const data = await res.json()
    zonas.value = data.status === 'ok' ? data.datos : []
  } catch (error) { console.error("Error zonas:", error) }
}

const fetchIngredientes = async () => {
  try {
    const res = await fetch(`${API_URL}/api/productos/ingredientes/mostrar`)
    const data = await res.json()
    ingredientes.value = data.status === 'ok' ? data.datos : []
  } catch (error) { console.error("Error ingredientes:", error) }
}

const fetchPaquetes = async () => {
  try {
    // ⚠️ Ajusta esta ruta a tu endpoint real de paquetes
    const res = await fetch(`${API_URL}/api/paquetes/mostrar`, {
      headers: authStore.authHeaders()
    })
    const data = await res.json()
    paquetes.value = data.status === 'ok' ? data.datos : []
  } catch (error) { console.error("Error paquetes:", error) }
}

// Cargar todo al iniciar
onMounted(() => {
  fetchMenus()
  fetchProductos()
  fetchZonas()
  fetchIngredientes()
  fetchPaquetes()
})
</script>

<template>
  <div class="layout-principal">
    <Sidebar />

    <main class="contenido-principal">
      <div class="menu-admin-wrapper">
        
        <nav class="tabs-nav">
          <button 
            v-for="p in pestanas" 
            :key="p" 
            :class="{ 'tab-activa': pestanaActual === p }"
            @click="pestanaActual = p"
          >
            {{ p }}
          </button>
        </nav>

        <div class="tab-content">
          <section v-if="pestanaActual === 'Menús'" class="grid-vista">
            <div class="header-seccion">
              <h2>Menús Disponibles</h2>
              <button v-if="esAdmin" class="btn-primario">+ Nuevo Menú</button>
            </div>
            <div class="tarjetas-grid">
              <div class="tarjeta-item" v-for="m in menus" :key="m.id_menu">
                <h3>{{ m.nombre_menu }}</h3>
                <p>Horario: {{ m.hora_inicio }} - {{ m.hora_fin }}</p>
                <span class="badge" :class="m.activo ? 'activo' : 'inactivo'">
                  {{ m.activo ? 'Activo' : 'Inactivo' }}
                </span>
                <div class="acciones" v-if="esAdmin">
                  <button class="btn-icon">✏️</button>
                  <button class="btn-icon">🗑️</button>
                </div>
              </div>
            </div>
          </section>

          <section v-if="pestanaActual === 'Paquetes'" class="grid-vista">
  <div class="header-seccion">
    <h2>Gestión de Paquetes</h2>
    <button v-if="esAdmin" class="btn-primario">+ Nuevo Paquete</button>
  </div>
  <div class="tarjetas-grid">
    <div class="tarjeta-item" v-for="pq in paquetes" :key="pq.id_paquete">
      <img :src="pq.url_imagen || '/placeholder.png'" class="img-producto" />
      <h3>{{ pq.nombre_paquete }}</h3>
      <p class="precio">${{ pq.precio_paquete }}</p>
      <p class="desc">{{ pq.descripcion }}</p>
      <span class="badge" :class="pq.activo ? 'activo' : 'inactivo'">
        {{ pq.activo ? 'Activo' : 'Inactivo' }}
      </span>
    </div>
  </div>
</section>

          <section v-if="pestanaActual === 'Productos'" class="grid-vista">
            <div class="header-seccion">
              <h2>Catálogo de Productos</h2>
            </div>
            <div class="tarjetas-grid">
              <div class="tarjeta-item" v-for="p in productos" :key="p.id_producto">
                <img :src="p.url_imagen || '/placeholder.png'" class="img-producto" />
                <h3>{{ p.nombre_producto }}</h3>
                <p class="precio">${{ p.precio_base }}</p>
                <p class="desc">{{ p.descripcion_pro }}</p>
                <button class="btn-secundario">Ingredientes del Platillo</button>
              </div>
            </div>
          </section>

          <section v-if="pestanaActual === 'Zonas'" class="grid-vista">
  <div class="header-seccion">
    <h2>Zonas del Restaurante</h2>
    <button v-if="esAdmin" class="btn-primario">+ Nueva Zona</button>
  </div>
  <div class="tarjetas-grid">
    <div class="tarjeta-item" v-for="z in zonas" :key="z.id_zona">
      <h3>{{ z.nombre_zona || z.nombre }}</h3>
      <p class="desc">{{ z.descripcion_zona || z.descripcion }}</p>
      <span class="badge" :class="z.activo ? 'activo' : 'inactivo'">
        {{ z.activo ? 'Activa' : 'Inactiva' }}
      </span>
      <div class="acciones" v-if="esAdmin">
        <button class="btn-icon">✏️</button>
      </div>
    </div>
  </div>
</section>

          <section v-if="pestanaActual === 'Ingredientes'" class="grid-vista">
            <div class="header-seccion">
              <h2>Catálogo Global de Ingredientes</h2>
            </div>
            <div class="tarjetas-grid">
              <div class="tarjeta-item" v-for="ing in ingredientes" :key="ing.id_ingrediente">
                <h3>{{ ing.nombre_ingrediente }}</h3>
                <p>Tipo: <span class="tipo-pill">{{ ing.tipo_ingrediente }}</span></p>
                <p v-if="ing.precio_adicional > 0">+${{ ing.precio_adicional }}</p>
                
                <div class="acciones" v-if="ing.tipo_ingrediente === 'extra'">
                  <button class="btn-secundario">✏️ Modificar Extra</button>
                </div>
                <p v-else class="nota">Se modifica desde Productos</p>
              </div>
            </div>
          </section>

        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
/* ── ESTRUCTURA PRINCIPAL (Para alinear el Sidebar) ── */
.layout-principal {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
  color: var(--tenant-texto);
}

.contenido-principal {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

/* ── ESTILOS DE LA VISTA MENÚ ── */
.menu-admin-wrapper { 
  display: flex; 
  flex-direction: column; 
  gap: 20px; 
}

/* Navegación de Pestañas */
.tabs-nav {
  display: flex; gap: 10px; border-bottom: 2px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  padding-bottom: 10px;
}
.tabs-nav button {
  background: transparent; border: none; color: var(--tenant-texto);
  font-size: 16px; padding: 10px 20px; cursor: pointer; border-radius: 8px;
  transition: all 0.3s ease;
}
.tabs-nav button.tab-activa {
  background: var(--tenant-primario); color: var(--tenant-texto); font-weight: bold;
}
.tabs-nav button:hover:not(.tab-activa) {
  background: color-mix(in srgb, var(--tenant-primario) 20%, transparent);
}

/* Layout de Tarjetas */
.header-seccion { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.tarjetas-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
.tarjeta-item {
  background: color-mix(in srgb, var(--tenant-fondo) 80%, white 5%);
  padding: 15px; border-radius: 12px;
  border: 1px solid color-mix(in srgb, var(--tenant-texto) 10%, transparent);
  display: flex; flex-direction: column; gap: 8px;
}
.img-producto { width: 100%; height: 150px; object-fit: cover; border-radius: 8px; }

/* Botones y Badges */
.btn-primario {
  background: var(--tenant-primario); color: #fff; border: none; padding: 10px 15px; border-radius: 8px; cursor: pointer;
}
.btn-secundario {
  background: transparent; border: 1px solid var(--tenant-primario); color: var(--tenant-primario); padding: 8px; border-radius: 6px; width: 100%; cursor: pointer; margin-top: auto;
}
.btn-icon {
  background: transparent; border: none; cursor: pointer; font-size: 1.2rem;
}
.acciones {
  display: flex; gap: 10px; margin-top: 10px;
}
.badge { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; align-self: flex-start; }
.badge.activo { background: color-mix(in srgb, #28a745 20%, transparent); color: #28a745; }
.badge.inactivo { background: color-mix(in srgb, #dc3545 20%, transparent); color: #dc3545; }

/* Detalles tipográficos */
.precio { font-size: 1.2rem; font-weight: bold; color: var(--tenant-primario); }
.desc { font-size: 0.9rem; color: color-mix(in srgb, var(--tenant-texto) 70%, transparent); }
.nota { font-size: 12px; color: gray; font-style: italic; margin-top: auto; }
.tipo-pill {
  font-size: var(--font-size-xs, 12px); font-weight: bold;
  background: color-mix(in srgb, var(--tenant-primario) 15%, transparent); 
  color: var(--tenant-primario);
  border-radius: 20px; padding: 2px 8px; text-transform: capitalize;
}
</style>