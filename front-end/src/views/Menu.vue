<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

// ── TIPOS ──────────────────────────────────────────────
interface Producto {
  id_producto:    number
  nombre_producto: string
  descripcion_pro: string
  precio_base:    number
  id_zona:        number
  nombre_zona:    string
  id_categoria:   number
  nombre_cat:     string
  disponibilidad: boolean
  url_imagen:     string | null
}

interface RelProductoIng {
  id_producto_ingrediente: number
  id_producto:    number
  nombre_producto: string
  id_ingrediente: number
  nombre_ingrediente: string
  tipo_ingrediente: string
  es_obligatorio: boolean
  precio_modificador: number
  activo: boolean
}

interface Ingrediente {
  id_ingrediente:   number
  nombre_ingrediente: string
  tipo_ingrediente: string
  precio_adicional: number
  activo: boolean
}

interface Zona       { id_zona: number;     nombre_zona: string }
interface Categoria  { id_categoria: number; nombre_cat: string }

interface Menu {
  id_menu:     number
  nombre_menu: string
  descripcion: string
  hora_inicio: string
  hora_fin:    string
  dias_semana: string
  activo:      boolean
  fecha_inicio: string | null
  fecha_fin:    string | null
}

interface MenuProducto {
  id_producto:     number
  nombre_producto: string
  precio_base:     number
  nombre_menu:     string
}

type SeccionPrincipal = 'productos' | 'menus' | 'paquetes'

// ── SECCIÓN ACTIVA ─────────────────────────────────────
const seccion = ref<SeccionPrincipal>('productos')

// ── TOAST ──────────────────────────────────────────────
const toast = ref<{ tipo: 'ok' | 'error'; mensaje: string } | null>(null)
let toastTimer: ReturnType<typeof setTimeout>

const mostrarToast = (tipo: 'ok' | 'error', mensaje: string) => {
  clearTimeout(toastTimer)
  toast.value = { tipo, mensaje }
  toastTimer = setTimeout(() => { toast.value = null }, 3500)
}

// ══════════════════════════════════════════════════════
//  CATÁLOGOS (Zonas + Categorías + Ingredientes)
// ══════════════════════════════════════════════════════
const zonas       = ref<Zona[]>([])
const categorias  = ref<Categoria[]>([])
const ingredientes = ref<Ingrediente[]>([])

const fetchCatalogos = async () => {
  const [rZ, rC, rI] = await Promise.all([
    fetch(`${API_URL}/api/tienda/zonas/mostrar`),
    fetch(`${API_URL}/api/tienda/categorias/mostrar`),
    fetch(`${API_URL}/api/productos/ingredientes/mostrar`),
  ])
  const [dZ, dC, dI] = await Promise.all([rZ.json(), rC.json(), rI.json()])
  zonas.value       = dZ.status === 'ok' ? dZ.datos : []
  categorias.value  = dC.status === 'ok' ? dC.datos : []
  ingredientes.value = dI.status === 'ok' ? dI.datos : []
}

// ══════════════════════════════════════════════════════
//  PRODUCTOS
// ══════════════════════════════════════════════════════
const productos     = ref<Producto[]>([])
const cargandoP     = ref(false)
const busquedaP     = ref('')
const filtroCat     = ref(0)   // 0 = todas
const tabProd       = ref<'activos' | 'inactivos'>('activos')

// Producto expandido para ver sus ingredientes
const productoExpandido = ref<Producto | null>(null)
const ingsDelProducto   = ref<RelProductoIng[]>([])
const cargandoIngs      = ref(false)

const productosFiltrados = computed(() => {
  const q = busquedaP.value.toLowerCase()
  return productos.value.filter(p => {
    const matchQ   = !q || p.nombre_producto.toLowerCase().includes(q)
    const matchCat = !filtroCat.value || p.id_categoria === filtroCat.value
    return matchQ && matchCat
  })
})

// GET /api/productos/mostrar y /mostrar-inactivo
const fetchProductos = async () => {
  cargandoP.value = true
  try {
    const url  = tabProd.value === 'activos'
      ? `${API_URL}/api/productos/mostrar`
      : `${API_URL}/api/productos/mostrar-inactivo`
    const res  = await fetch(url)
    const data = await res.json()
    productos.value = data.status === 'ok' ? data.datos : []
  } catch { productos.value = [] }
  finally   { cargandoP.value = false }
}

// GET /api/productos/producto-ingrediente/mostrar-especifico/:id  (requiere auth)
const expandirProducto = async (p: Producto) => {
  if (productoExpandido.value?.id_producto === p.id_producto) {
    productoExpandido.value = null
    ingsDelProducto.value   = []
    return
  }
  productoExpandido.value = p
  cargandoIngs.value      = true
  try {
    const res  = await fetch(
      `${API_URL}/api/productos/producto-ingrediente/mostrar-especifico/${p.id_producto}`,
      { headers: authStore.authHeaders() }
    )
    const data = await res.json()
    ingsDelProducto.value = data.status === 'ok' ? data.datos : []
  } catch { ingsDelProducto.value = [] }
  finally   { cargandoIngs.value = false }
}

// ── MODAL PRODUCTO ─────────────────────────────────────
const modalProd    = ref(false)
const editandoProd = ref(false)
const guardandoProd = ref(false)
const errorProd    = ref('')

const formProd = ref({
  id_producto:  0,
  nombre:       '',
  descripcion:  '',
  precio:       0,
  id_zona:      0,
  id_categoria: 0,
  url_imagen:   '',
  disponibilidad: true,
})

const abrirCrearProd = () => {
  formProd.value = { id_producto: 0, nombre: '', descripcion: '', precio: 0, id_zona: 0, id_categoria: 0, url_imagen: '', disponibilidad: true }
  editandoProd.value = false; errorProd.value = ''; modalProd.value = true
}

const abrirEditarProd = (p: Producto) => {
  formProd.value = {
    id_producto:   p.id_producto,
    nombre:        p.nombre_producto,
    descripcion:   p.descripcion_pro,
    precio:        p.precio_base,
    id_zona:       p.id_zona,
    id_categoria:  p.id_categoria,
    url_imagen:    p.url_imagen ?? '',
    disponibilidad: (p.disponibilidad as unknown) !== false && (p.disponibilidad as unknown) !== 'false',
  }
  editandoProd.value = true; errorProd.value = ''; modalProd.value = true
}

const cerrarModalProd = () => { modalProd.value = false; errorProd.value = '' }

const guardarProducto = async () => {
  guardandoProd.value = true; errorProd.value = ''
  try {
    const url    = editandoProd.value
      ? `${API_URL}/api/productos/modificar/${formProd.value.id_producto}`
      : `${API_URL}/api/productos/agregar`
    const method = editandoProd.value ? 'PUT' : 'POST'
    const body   = {
      nombre:        formProd.value.nombre,
      descripcion:   formProd.value.descripcion || undefined,
      precio:        formProd.value.precio,
      id_zona:       formProd.value.id_zona,
      id_categoria:  formProd.value.id_categoria,
      url_imagen:    formProd.value.url_imagen || undefined,
      disponibilidad: formProd.value.disponibilidad,
    }
    const res  = await fetch(url, { method, headers: authStore.authHeaders(), body: JSON.stringify(body) })
    const data = await res.json()
    if (data.status === 'ok') {
      await fetchProductos()
      mostrarToast('ok', editandoProd.value ? 'Producto actualizado' : 'Producto creado')
      cerrarModalProd()
    } else {
      errorProd.value = data.mensaje
    }
  } catch { errorProd.value = 'Error al conectar con el servidor' }
  finally   { guardandoProd.value = false }
}

// DELETE /api/productos/desactivar/:id
const desactivarProducto = async (p: Producto) => {
  try {
    const res  = await fetch(`${API_URL}/api/productos/desactivar/${p.id_producto}`, {
      method: 'DELETE', headers: authStore.authHeaders(),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      await fetchProductos()
      if (productoExpandido.value?.id_producto === p.id_producto) productoExpandido.value = null
      mostrarToast('ok', `"${p.nombre_producto}" desactivado`)
    } else { mostrarToast('error', data.mensaje) }
  } catch { mostrarToast('error', 'Error al desactivar producto') }
}

// ── MODAL INGREDIENTE DEL PRODUCTO ────────────────────
// Vincular: POST /api/productos/producto-ingrediente/vincular
// Modificar: PUT /api/productos/producto-ingrediente/modificar/:id
// Desvincular: DELETE /api/productos/producto-ingrediente/desvincular/:id

const modalIng      = ref(false)
const editandoIng   = ref(false)
const guardandoIng  = ref(false)
const errorIng      = ref('')

const formIng = ref({
  id_producto_ingrediente: 0,
  id_ingrediente:          0,
  es_obligatorio:          false,
  precio:                  0,
  activo:                  true,
})

const abrirVincular = () => {
  formIng.value = { id_producto_ingrediente: 0, id_ingrediente: 0, es_obligatorio: false, precio: 0, activo: true }
  editandoIng.value = false; errorIng.value = ''; modalIng.value = true
}

const abrirModificarIng = (rel: RelProductoIng) => {
  formIng.value = {
    id_producto_ingrediente: rel.id_producto_ingrediente,
    id_ingrediente:          rel.id_ingrediente,
    es_obligatorio:          (rel.es_obligatorio as unknown) !== false && (rel.es_obligatorio as unknown) !== 'false',
    precio:                  rel.precio_modificador,
    activo:                  (rel.activo as unknown) !== false && (rel.activo as unknown) !== 'false',
  }
  editandoIng.value = true; errorIng.value = ''; modalIng.value = true
}

const cerrarModalIng = () => { modalIng.value = false; errorIng.value = '' }

const guardarIngredienteProducto = async () => {
  guardandoIng.value = true; errorIng.value = ''
  try {
    let res, data
    if (editandoIng.value) {
      // PUT modificar relación
      res  = await fetch(`${API_URL}/api/productos/producto-ingrediente/modificar/${formIng.value.id_producto_ingrediente}`, {
        method: 'PUT', headers: authStore.authHeaders(),
        body: JSON.stringify({
          es_obligatorio: formIng.value.es_obligatorio,
          precio:         formIng.value.precio,
          activo:         formIng.value.activo,
        }),
      })
    } else {
      // POST vincular
      res  = await fetch(`${API_URL}/api/productos/producto-ingrediente/vincular`, {
        method: 'POST', headers: authStore.authHeaders(),
        body: JSON.stringify({
          id_producto:    productoExpandido.value!.id_producto,
          id_ingrediente: formIng.value.id_ingrediente,
          es_obligatorio: formIng.value.es_obligatorio,
          precio:         formIng.value.precio,
        }),
      })
    }
    data = await res.json()
    if (data.status === 'ok') {
      await expandirProducto(productoExpandido.value!)
      mostrarToast('ok', editandoIng.value ? 'Ingrediente actualizado' : 'Ingrediente vinculado')
      cerrarModalIng()
    } else { errorIng.value = data.mensaje }
  } catch { errorIng.value = 'Error al conectar con el servidor' }
  finally   { guardandoIng.value = false }
}

const desvincularIngrediente = async (rel: RelProductoIng) => {
  try {
    const res  = await fetch(`${API_URL}/api/productos/producto-ingrediente/desvincular/${rel.id_producto_ingrediente}`, {
      method: 'DELETE', headers: authStore.authHeaders(),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      await expandirProducto(productoExpandido.value!)
      mostrarToast('ok', `"${rel.nombre_ingrediente}" desvinculado`)
    } else { mostrarToast('error', data.mensaje) }
  } catch { mostrarToast('error', 'Error al desvincular ingrediente') }
}

// ══════════════════════════════════════════════════════
//  MENÚS
// ══════════════════════════════════════════════════════
const menus        = ref<Menu[]>([])
const cargandoM    = ref(false)
const tabMenus     = ref<'activos' | 'inactivos'>('activos')
const menuExpandido = ref<Menu | null>(null)
const prodDelMenu  = ref<MenuProducto[]>([])
const cargandoPM   = ref(false)

const fetchMenus = async () => {
  cargandoM.value = true
  try {
    const url  = tabMenus.value === 'activos'
      ? `${API_URL}/api/menu/mostrar-activo`
      : `${API_URL}/api/menu/mostrar-inactivo`
    const res  = await fetch(url)
    const data = await res.json()
    menus.value = data.status === 'ok' ? data.datos : []
  } catch { menus.value = [] }
  finally   { cargandoM.value = false }
}

// GET /api/menu/mostrar-menu/:id
const expandirMenu = async (m: Menu) => {
  if (menuExpandido.value?.id_menu === m.id_menu) {
    menuExpandido.value = null; prodDelMenu.value = []; return
  }
  menuExpandido.value = m; cargandoPM.value = true
  try {
    const res  = await fetch(`${API_URL}/api/menu/mostrar-menu/${m.id_menu}`)
    const data = await res.json()
    prodDelMenu.value = data.status === 'ok' ? data.datos : []
  } catch { prodDelMenu.value = [] }
  finally   { cargandoPM.value = false }
}

// ── MODAL MENÚ ─────────────────────────────────────────
const modalMenu    = ref(false)
const editandoMenu = ref(false)
const guardandoMenu = ref(false)
const errorMenu    = ref('')

const formMenu = ref({
  id_menu:      0,
  nombre:       '',
  descripcion:  '',
  hora_inicio:  '',
  hora_fin:     '',
  dias_semana:  '',
  fecha_inicio: '',
  fecha_fin:    '',
  activo:       true,
})

const abrirCrearMenu = () => {
  formMenu.value = { id_menu: 0, nombre: '', descripcion: '', hora_inicio: '', hora_fin: '', dias_semana: '', fecha_inicio: '', fecha_fin: '', activo: true }
  editandoMenu.value = false; errorMenu.value = ''; modalMenu.value = true
}

const abrirEditarMenu = (m: Menu) => {
  formMenu.value = {
    id_menu:      m.id_menu,
    nombre:       m.nombre_menu,
    descripcion:  m.descripcion,
    hora_inicio:  m.hora_inicio,
    hora_fin:     m.hora_fin,
    dias_semana:  m.dias_semana,
    fecha_inicio: m.fecha_inicio ?? '',
    fecha_fin:    m.fecha_fin ?? '',
    activo:       (m.activo as unknown) !== false && (m.activo as unknown) !== 'false',
  }
  editandoMenu.value = true; errorMenu.value = ''; modalMenu.value = true
}

const cerrarModalMenu = () => { modalMenu.value = false; errorMenu.value = '' }

const guardarMenu = async () => {
  guardandoMenu.value = true; errorMenu.value = ''
  try {
    const url    = editandoMenu.value
      ? `${API_URL}/api/menu/modificar/${formMenu.value.id_menu}`
      : `${API_URL}/api/menu/agregar`
    const method = editandoMenu.value ? 'PUT' : 'POST'
    const body: Record<string, unknown> = {
      nombre:       formMenu.value.nombre,
      descripcion:  formMenu.value.descripcion || undefined,
      hora_inicio:  formMenu.value.hora_inicio,
      hora_fin:     formMenu.value.hora_fin,
      dias_semana:  formMenu.value.dias_semana,
      fecha_inicio: formMenu.value.fecha_inicio || undefined,
      fecha_fin:    formMenu.value.fecha_fin    || undefined,
    }
    if (editandoMenu.value) body.activo = formMenu.value.activo
    const res  = await fetch(url, { method, headers: authStore.authHeaders(), body: JSON.stringify(body) })
    const data = await res.json()
    if (data.status === 'ok') {
      await fetchMenus()
      mostrarToast('ok', editandoMenu.value ? 'Menú actualizado' : 'Menú creado')
      cerrarModalMenu()
    } else { errorMenu.value = data.mensaje }
  } catch { errorMenu.value = 'Error al conectar con el servidor' }
  finally   { guardandoMenu.value = false }
}

const desactivarMenu = async (m: Menu) => {
  try {
    const res  = await fetch(`${API_URL}/api/menu/desactivar/${m.id_menu}`, {
      method: 'DELETE', headers: authStore.authHeaders(),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      if (menuExpandido.value?.id_menu === m.id_menu) menuExpandido.value = null
      await fetchMenus()
      mostrarToast('ok', `"${m.nombre_menu}" desactivado`)
    } else { mostrarToast('error', data.mensaje) }
  } catch { mostrarToast('error', 'Error al desactivar menú') }
}

// ── AGREGAR / RETIRAR PRODUCTO DEL MENÚ ───────────────
const modalMenuProd      = ref(false)
const guardandoMenuProd  = ref(false)
const errorMenuProd      = ref('')
const selProductoMenu    = ref(0)

const abrirAgregarMenuProd = () => {
  selProductoMenu.value = 0; errorMenuProd.value = ''; modalMenuProd.value = true
}

const agregarProductoAlMenu = async () => {
  guardandoMenuProd.value = true; errorMenuProd.value = ''
  try {
    const res  = await fetch(`${API_URL}/api/menu/menu-producto/agregar`, {
      method: 'POST', headers: authStore.authHeaders(),
      body: JSON.stringify({ id_menu: menuExpandido.value!.id_menu, id_producto: selProductoMenu.value }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      await expandirMenu(menuExpandido.value!)
      mostrarToast('ok', 'Producto agregado al menú')
      modalMenuProd.value = false
    } else { errorMenuProd.value = data.mensaje }
  } catch { errorMenuProd.value = 'Error al conectar con el servidor' }
  finally   { guardandoMenuProd.value = false }
}

// DELETE /api/menu/menu-producto/retirar?id_menu=X&id_producto=Y
const retirarProductoDelMenu = async (mp: MenuProducto) => {
  try {
    const res  = await fetch(
      `${API_URL}/api/menu/menu-producto/retirar?id_menu=${menuExpandido.value!.id_menu}&id_producto=${mp.id_producto}`,
      { method: 'DELETE', headers: authStore.authHeaders() }
    )
    const data = await res.json()
    if (data.status === 'ok') {
      await expandirMenu(menuExpandido.value!)
      mostrarToast('ok', `"${mp.nombre_producto}" retirado del menú`)
    } else { mostrarToast('error', data.mensaje) }
  } catch { mostrarToast('error', 'Error al retirar producto') }
}

// ── INIT ───────────────────────────────────────────────
onMounted(async () => {
  await fetchCatalogos()
  fetchProductos()
})
</script>

<template>
  <div class="page-layout">
    <Sidebar />

    <main class="page-main">

      <!-- HEADER -->
      <header class="page-header">
        <div>
          <p class="header-label">Administración</p>
          <h1 class="page-title">Menú y Productos</h1>
        </div>
      </header>

      <!-- SELECTOR DE SECCIÓN -->
      <div class="seccion-tabs">
        <button class="sec-tab" :class="{ active: seccion === 'productos' }" @click="seccion = 'productos'; fetchProductos()">
          <svg viewBox="0 0 24 24" fill="none"><rect x="3" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/><rect x="14" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/><rect x="3" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/><rect x="14" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5"/></svg>
          Productos
        </button>
        <button class="sec-tab" :class="{ active: seccion === 'menus' }" @click="seccion = 'menus'; fetchMenus()">
          <svg viewBox="0 0 24 24" fill="none"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          Menús
        </button>
        <button class="sec-tab" :class="{ active: seccion === 'paquetes' }" @click="seccion = 'paquetes'">
          <svg viewBox="0 0 24 24" fill="none"><path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/></svg>
          Paquetes & Promociones
        </button>
      </div>

      <!-- ════════════════ PRODUCTOS ════════════════ -->
      <div v-if="seccion === 'productos'" class="section">

        <!-- Toolbar -->
        <div class="toolbar">
          <div class="search-bar">
            <svg viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/><path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <input v-model="busquedaP" placeholder="Buscar producto..." />
          </div>
          <select class="select-filter" v-model="filtroCat">
            <option :value="0">Todas las categorías</option>
            <option v-for="c in categorias" :key="c.id_categoria" :value="c.id_categoria">{{ c.nombre_cat }}</option>
          </select>
          <div class="mini-tabs">
            <button class="mini-tab" :class="{ active: tabProd === 'activos' }"   @click="tabProd = 'activos';   fetchProductos()">Activos</button>
            <button class="mini-tab" :class="{ active: tabProd === 'inactivos' }" @click="tabProd = 'inactivos'; fetchProductos()">Inactivos</button>
          </div>
          <button class="btn-add" @click="abrirCrearProd">
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            Nuevo producto
          </button>
        </div>

        <div v-if="cargandoP" class="state-msg">Cargando productos...</div>

        <!-- Grid de productos -->
        <div class="prod-grid">
          <div
            v-for="p in productosFiltrados" :key="p.id_producto"
            class="prod-card"
            :class="{ 'prod-card--inactivo': !(p.disponibilidad), 'prod-card--expanded': productoExpandido?.id_producto === p.id_producto }"
          >
            <!-- Cabecera del card -->
            <div class="prod-card-header" @click="expandirProducto(p)">
              <div class="prod-avatar">
                <svg viewBox="0 0 24 24" fill="none"><path d="M18 8h1a4 4 0 010 8h-1M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8zM6 2v3M10 2v3M14 2v3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </div>
              <div class="prod-info">
                <strong class="prod-nombre">{{ p.nombre_producto }}</strong>
                <div class="prod-meta">
                  <span class="prod-precio">${{ p.precio_base }}</span>
                  <span class="prod-cat">{{ p.nombre_cat }}</span>
                  <span class="prod-zona">{{ p.nombre_zona }}</span>
                </div>
              </div>
              <span class="status-dot" :class="p.disponibilidad ? 'status-dot--on' : 'status-dot--off'"></span>
              <div class="prod-actions" @click.stop>
                <button class="icon-btn icon-btn--edit"   @click="abrirEditarProd(p)" title="Editar">
                  <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
                <button class="icon-btn icon-btn--delete" @click="desactivarProducto(p)" title="Desactivar">
                  <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                </button>
                <button class="icon-btn icon-btn--expand" :class="{ rotated: productoExpandido?.id_producto === p.id_producto }" @click="expandirProducto(p)" title="Ver ingredientes">
                  <svg viewBox="0 0 24 24" fill="none"><path d="M6 9l6 6 6-6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
              </div>
            </div>

            <!-- Panel de ingredientes (expandible) -->
            <Transition name="slide-down">
              <div v-if="productoExpandido?.id_producto === p.id_producto" class="ing-panel">
                <div class="ing-panel-header">
                  <span class="ing-panel-title">Ingredientes y modificadores</span>
                  <button class="btn-add-sm" @click="abrirVincular">
                    <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                    Vincular ingrediente
                  </button>
                </div>

                <div v-if="cargandoIngs" class="state-msg">Cargando ingredientes...</div>

                <div v-else-if="ingsDelProducto.length === 0" class="ing-empty">
                  Sin ingredientes vinculados
                </div>

                <div v-else class="ing-groups">
                  <!-- Obligatorios (como Verde/Rojo de chilaquiles) -->
                  <div v-if="ingsDelProducto.filter(r => r.es_obligatorio).length > 0" class="ing-group">
                    <p class="ing-group-label">
                      <svg viewBox="0 0 24 24" fill="none"><path d="M9 11l3 3L22 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                      Obligatorios
                    </p>
                    <div class="ing-list">
                      <div v-for="rel in ingsDelProducto.filter(r => r.es_obligatorio)" :key="rel.id_producto_ingrediente" class="ing-row" :class="{ 'ing-row--inactivo': !(rel.activo) }">
                        <span class="ing-tipo-dot ing-tipo-dot--obl"></span>
                        <span class="ing-nombre">{{ rel.nombre_ingrediente }}</span>
                        <span class="ing-tipo-tag">{{ rel.tipo_ingrediente }}</span>
                        <span class="ing-precio" v-if="rel.precio_modificador > 0">+${{ rel.precio_modificador }}</span>
                        <div class="ing-row-actions">
                          <button class="icon-btn icon-btn--edit icon-btn--sm" @click="abrirModificarIng(rel)" title="Modificar">
                            <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                          </button>
                          <button class="icon-btn icon-btn--delete icon-btn--sm" @click="desvincularIngrediente(rel)" title="Desvincular">
                            <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Extras (como Pollo, Bolillo extra) -->
                  <div v-if="ingsDelProducto.filter(r => !r.es_obligatorio).length > 0" class="ing-group">
                    <p class="ing-group-label ing-group-label--extra">
                      <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                      Extras opcionales
                    </p>
                    <div class="ing-list">
                      <div v-for="rel in ingsDelProducto.filter(r => !r.es_obligatorio)" :key="rel.id_producto_ingrediente" class="ing-row" :class="{ 'ing-row--inactivo': !(rel.activo) }">
                        <span class="ing-tipo-dot ing-tipo-dot--ext"></span>
                        <span class="ing-nombre">{{ rel.nombre_ingrediente }}</span>
                        <span class="ing-tipo-tag">{{ rel.tipo_ingrediente }}</span>
                        <span class="ing-precio" v-if="rel.precio_modificador > 0">+${{ rel.precio_modificador }}</span>
                        <div class="ing-row-actions">
                          <button class="icon-btn icon-btn--edit icon-btn--sm" @click="abrirModificarIng(rel)" title="Modificar">
                            <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                          </button>
                          <button class="icon-btn icon-btn--delete icon-btn--sm" @click="desvincularIngrediente(rel)" title="Desvincular">
                            <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </Transition>
          </div>

          <div v-if="!cargandoP && productosFiltrados.length === 0" class="empty-state">
            <svg viewBox="0 0 24 24" fill="none"><path d="M18 8h1a4 4 0 010 8h-1M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8z" stroke="currentColor" stroke-width="1.5"/></svg>
            <p>Sin productos</p>
          </div>
        </div>
      </div>

      <!-- ════════════════ MENÚS ════════════════ -->
      <div v-if="seccion === 'menus'" class="section">

        <div class="toolbar">
          <div class="mini-tabs">
            <button class="mini-tab" :class="{ active: tabMenus === 'activos' }"   @click="tabMenus = 'activos';   fetchMenus()">Activos</button>
            <button class="mini-tab" :class="{ active: tabMenus === 'inactivos' }" @click="tabMenus = 'inactivos'; fetchMenus()">Inactivos</button>
          </div>
          <button class="btn-add" @click="abrirCrearMenu">
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            Nuevo menú
          </button>
        </div>

        <div v-if="cargandoM" class="state-msg">Cargando menús...</div>

        <div class="menus-list">
          <div v-for="m in menus" :key="m.id_menu" class="menu-card" :class="{ 'menu-card--inactivo': !(m.activo) }">

            <!-- Cabecera del menú -->
            <div class="menu-card-header" @click="expandirMenu(m)">
              <div class="menu-icon">
                <svg viewBox="0 0 24 24" fill="none"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
              </div>
              <div class="menu-info">
                <strong class="menu-nombre">{{ m.nombre_menu }}</strong>
                <div class="menu-meta">
                  <span class="menu-tag">{{ m.hora_inicio }} – {{ m.hora_fin }}</span>
                  <span class="menu-tag">{{ m.dias_semana }}</span>
                  <span v-if="m.fecha_inicio" class="menu-tag">{{ m.fecha_inicio }}</span>
                </div>
              </div>
              <span class="status-dot" :class="m.activo ? 'status-dot--on' : 'status-dot--off'"></span>
              <div class="prod-actions" @click.stop>
                <button class="icon-btn icon-btn--edit"   @click="abrirEditarMenu(m)" title="Editar menú">
                  <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
                <button class="icon-btn icon-btn--delete" @click="desactivarMenu(m)" title="Desactivar menú">
                  <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                </button>
                <button class="icon-btn icon-btn--expand" :class="{ rotated: menuExpandido?.id_menu === m.id_menu }" @click="expandirMenu(m)">
                  <svg viewBox="0 0 24 24" fill="none"><path d="M6 9l6 6 6-6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
              </div>
            </div>

            <!-- Productos del menú (expandible) -->
            <Transition name="slide-down">
              <div v-if="menuExpandido?.id_menu === m.id_menu" class="ing-panel">
                <div class="ing-panel-header">
                  <span class="ing-panel-title">Productos en este menú</span>
                  <button class="btn-add-sm" @click="abrirAgregarMenuProd">
                    <svg viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                    Agregar producto
                  </button>
                </div>

                <div v-if="cargandoPM" class="state-msg">Cargando productos...</div>
                <div v-else-if="prodDelMenu.length === 0" class="ing-empty">Sin productos en este menú</div>

                <div v-else class="ing-list">
                  <div v-for="mp in prodDelMenu" :key="mp.id_producto" class="ing-row">
                    <span class="ing-tipo-dot ing-tipo-dot--menu"></span>
                    <span class="ing-nombre">{{ mp.nombre_producto }}</span>
                    <span class="ing-precio">${{ mp.precio_base }}</span>
                    <div class="ing-row-actions">
                      <button class="icon-btn icon-btn--delete icon-btn--sm" @click="retirarProductoDelMenu(mp)" title="Retirar del menú">
                        <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </Transition>
          </div>

          <div v-if="!cargandoM && menus.length === 0" class="empty-state">
            <svg viewBox="0 0 24 24" fill="none"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <p>Sin menús</p>
          </div>
        </div>
      </div>

      <!-- ════════════════ PAQUETES (en construcción) ════════════════ -->
      <div v-if="seccion === 'paquetes'" class="section">
        <div class="construction-card">
          <svg viewBox="0 0 24 24" fill="none"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
          <h2>Paquetes & Promociones</h2>
          <p>Esta sección está en construcción.</p>
        </div>
      </div>

      <div class="watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </main>

    <!-- ── TOAST ── -->
    <Transition name="toast">
      <div v-if="toast" class="toast" :class="`toast--${toast.tipo}`">
        <svg v-if="toast.tipo === 'ok'" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M8 12l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        <svg v-else viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/><path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
        {{ toast.mensaje }}
      </div>
    </Transition>

    <!-- ══ MODAL PRODUCTO ══ -->
    <Transition name="modal">
      <div v-if="modalProd" class="modal-overlay" @click.self="cerrarModalProd">
        <div class="modal modal--wide">
          <div class="modal-header">
            <h2>{{ editandoProd ? 'Editar producto' : 'Nuevo producto' }}</h2>
            <button class="modal-close" @click="cerrarModalProd"><svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg></button>
          </div>
          <div class="modal-body modal-body--grid">
            <div class="field"><label>Nombre *</label><input v-model="formProd.nombre" placeholder="Ej: Chilaquiles verdes" /></div>
            <div class="field"><label>Precio base * ($)</label><input v-model.number="formProd.precio" type="number" min="0" step="0.5" /></div>
            <div class="field"><label>Categoría *</label>
              <select v-model.number="formProd.id_categoria">
                <option :value="0" disabled>Seleccionar...</option>
                <option v-for="c in categorias" :key="c.id_categoria" :value="c.id_categoria">{{ c.nombre_cat }}</option>
              </select>
            </div>
            <div class="field"><label>Zona *</label>
              <select v-model.number="formProd.id_zona">
                <option :value="0" disabled>Seleccionar...</option>
                <option v-for="z in zonas" :key="z.id_zona" :value="z.id_zona">{{ z.nombre_zona }}</option>
              </select>
            </div>
            <div class="field field--full"><label>Descripción</label><input v-model="formProd.descripcion" placeholder="Descripción breve (opcional)" /></div>
            <div class="field field--full"><label>URL de imagen</label><input v-model="formProd.url_imagen" placeholder="https://..." /></div>
            <div v-if="editandoProd" class="field field--row field--full">
              <label>Disponibilidad</label>
              <label class="toggle">
                <input type="checkbox" :checked="formProd.disponibilidad === true" @change="formProd.disponibilidad = ($event.target as HTMLInputElement).checked" />
                <span class="toggle-slider"></span>
                <span :class="formProd.disponibilidad ? 'toggle-text--on' : 'toggle-text--off'">{{ formProd.disponibilidad ? 'Disponible' : 'No disponible' }}</span>
              </label>
            </div>
            <div v-if="errorProd" class="error-msg field--full">{{ errorProd }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalProd">Cancelar</button>
            <button class="btn-primary" :disabled="guardandoProd" @click="guardarProducto">
              <span v-if="!guardandoProd">{{ editandoProd ? 'Guardar' : 'Crear' }}</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- ══ MODAL INGREDIENTE-PRODUCTO ══ -->
    <Transition name="modal">
      <div v-if="modalIng" class="modal-overlay" @click.self="cerrarModalIng">
        <div class="modal">
          <div class="modal-header">
            <h2>{{ editandoIng ? 'Modificar ingrediente' : 'Vincular ingrediente' }}</h2>
            <button class="modal-close" @click="cerrarModalIng"><svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg></button>
          </div>
          <div class="modal-body">
            <div v-if="!editandoIng" class="field">
              <label>Ingrediente</label>
              <select v-model.number="formIng.id_ingrediente">
                <option :value="0" disabled>Seleccionar ingrediente...</option>
                <option v-for="i in ingredientes" :key="i.id_ingrediente" :value="i.id_ingrediente">{{ i.nombre_ingrediente }} ({{ i.tipo_ingrediente }})</option>
              </select>
            </div>
            <div class="field">
              <label>Precio adicional ($)</label>
              <input v-model.number="formIng.precio" type="number" min="0" step="0.5" placeholder="0" />
            </div>
            <div class="field field--row">
              <label>¿Es obligatorio?</label>
              <label class="toggle">
                <input type="checkbox" :checked="formIng.es_obligatorio === true" @change="formIng.es_obligatorio = ($event.target as HTMLInputElement).checked" />
                <span class="toggle-slider"></span>
                <span :class="formIng.es_obligatorio ? 'toggle-text--on' : 'toggle-text--off'">{{ formIng.es_obligatorio ? 'Sí (obligatorio)' : 'No (extra opcional)' }}</span>
              </label>
            </div>
            <div v-if="editandoIng" class="field field--row">
              <label>Estado</label>
              <label class="toggle">
                <input type="checkbox" :checked="formIng.activo === true" @change="formIng.activo = ($event.target as HTMLInputElement).checked" />
                <span class="toggle-slider"></span>
                <span :class="formIng.activo ? 'toggle-text--on' : 'toggle-text--off'">{{ formIng.activo ? 'Activo' : 'Inactivo' }}</span>
              </label>
            </div>
            <div v-if="errorIng" class="error-msg">{{ errorIng }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalIng">Cancelar</button>
            <button class="btn-primary" :disabled="guardandoIng" @click="guardarIngredienteProducto">
              <span v-if="!guardandoIng">{{ editandoIng ? 'Guardar' : 'Vincular' }}</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- ══ MODAL MENÚ ══ -->
    <Transition name="modal">
      <div v-if="modalMenu" class="modal-overlay" @click.self="cerrarModalMenu">
        <div class="modal modal--wide">
          <div class="modal-header">
            <h2>{{ editandoMenu ? 'Editar menú' : 'Nuevo menú' }}</h2>
            <button class="modal-close" @click="cerrarModalMenu"><svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg></button>
          </div>
          <div class="modal-body modal-body--grid">
            <div class="field field--full"><label>Nombre *</label><input v-model="formMenu.nombre" placeholder="Ej: Menú Desayuno" /></div>
            <div class="field"><label>Hora inicio *</label><input v-model="formMenu.hora_inicio" type="time" /></div>
            <div class="field"><label>Hora fin *</label><input v-model="formMenu.hora_fin" type="time" /></div>
            <div class="field field--full"><label>Días de la semana *</label><input v-model="formMenu.dias_semana" placeholder="Ej: Lunes-Viernes" /></div>
            <div class="field"><label>Fecha inicio (opcional)</label><input v-model="formMenu.fecha_inicio" type="date" /></div>
            <div class="field"><label>Fecha fin (opcional)</label><input v-model="formMenu.fecha_fin" type="date" /></div>
            <div class="field field--full"><label>Descripción</label><input v-model="formMenu.descripcion" placeholder="Descripción breve (opcional)" /></div>
            <div v-if="editandoMenu" class="field field--row field--full">
              <label>Estado</label>
              <label class="toggle">
                <input type="checkbox" :checked="formMenu.activo === true" @change="formMenu.activo = ($event.target as HTMLInputElement).checked" />
                <span class="toggle-slider"></span>
                <span :class="formMenu.activo ? 'toggle-text--on' : 'toggle-text--off'">{{ formMenu.activo ? 'Activo' : 'Inactivo' }}</span>
              </label>
            </div>
            <div v-if="errorMenu" class="error-msg field--full">{{ errorMenu }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalMenu">Cancelar</button>
            <button class="btn-primary" :disabled="guardandoMenu" @click="guardarMenu">
              <span v-if="!guardandoMenu">{{ editandoMenu ? 'Guardar' : 'Crear' }}</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- ══ MODAL AGREGAR PRODUCTO AL MENÚ ══ -->
    <Transition name="modal">
      <div v-if="modalMenuProd" class="modal-overlay" @click.self="modalMenuProd = false">
        <div class="modal">
          <div class="modal-header">
            <h2>Agregar producto a "{{ menuExpandido?.nombre_menu }}"</h2>
            <button class="modal-close" @click="modalMenuProd = false"><svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg></button>
          </div>
          <div class="modal-body">
            <div class="field">
              <label>Producto</label>
              <select v-model.number="selProductoMenu">
                <option :value="0" disabled>Seleccionar producto...</option>
                <option v-for="p in productos" :key="p.id_producto" :value="p.id_producto">{{ p.nombre_producto }} — ${{ p.precio_base }}</option>
              </select>
            </div>
            <div v-if="errorMenuProd" class="error-msg">{{ errorMenuProd }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="modalMenuProd = false">Cancelar</button>
            <button class="btn-primary" :disabled="guardandoMenuProd || !selProductoMenu" @click="agregarProductoAlMenu">
              <span v-if="!guardandoMenuProd">Agregar</span><span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
.page-layout { display: flex; min-height: 100vh; background: var(--tenant-fondo); }

.page-main {
  flex: 1;
  padding: var(--espacio-8) var(--espacio-8) var(--espacio-6);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-5);
  position: relative;
  overflow-y: auto;
}

/* ── HEADER ── */
.page-header { display: flex; align-items: flex-end; justify-content: space-between; }
.header-label { margin: 0; font-size: var(--font-size-xs); text-transform: uppercase; letter-spacing: 0.1em; color: var(--tenant-texto-muted); font-weight: var(--font-weight-medium); }
.page-title   { margin: 0; font-size: var(--font-size-2xl); font-weight: var(--font-weight-bold); color: var(--tenant-texto); }

/* ── SELECTOR PRINCIPAL ── */
.seccion-tabs {
  display: flex;
  gap: 4px;
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 14px;
  padding: 4px;
  width: fit-content;
}

.sec-tab {
  display: flex; align-items: center; gap: var(--espacio-2);
  padding: var(--espacio-2) var(--espacio-5);
  border-radius: 10px; border: none; background: transparent;
  font-size: var(--font-size-sm); font-weight: var(--font-weight-medium);
  color: var(--tenant-texto-muted); cursor: pointer;
  font-family: var(--tenant-fuente); transition: background 0.15s, color 0.15s;
  white-space: nowrap;
}
.sec-tab svg { width: 15px; height: 15px; }
.sec-tab.active { background: var(--tenant-primario); color: #fff; }
.sec-tab:not(.active):hover { background: var(--color-hover); color: var(--tenant-texto); }

/* ── SECTION ── */
.section { display: flex; flex-direction: column; gap: var(--espacio-4); }

/* ── TOOLBAR ── */
.toolbar { display: flex; align-items: center; gap: var(--espacio-3); flex-wrap: wrap; }

.search-bar {
  display: flex; align-items: center; gap: var(--espacio-3);
  background: var(--color-superficie); border: 1px solid var(--color-borde);
  border-radius: 50px; padding: var(--espacio-2) var(--espacio-4);
  flex: 1; max-width: 320px; transition: border-color 0.2s;
}
.search-bar:focus-within { border-color: var(--tenant-primario); }
.search-bar svg   { width: 15px; height: 15px; color: var(--tenant-texto-muted); flex-shrink: 0; }
.search-bar input { background: none; border: none; outline: none; font-size: var(--font-size-sm); color: var(--tenant-texto); font-family: var(--tenant-fuente); width: 100%; }
.search-bar input::placeholder { color: var(--tenant-texto-muted); }

.select-filter {
  background: var(--color-superficie); border: 1px solid var(--color-borde);
  border-radius: 50px; padding: var(--espacio-2) var(--espacio-4);
  font-size: var(--font-size-sm); color: var(--tenant-texto);
  font-family: var(--tenant-fuente); outline: none; cursor: pointer;
  transition: border-color 0.2s;
}
.select-filter:focus { border-color: var(--tenant-primario); }

.mini-tabs { display: flex; gap: 2px; background: var(--color-superficie); border: 1px solid var(--color-borde); border-radius: 50px; padding: 3px; }
.mini-tab { padding: 4px 14px; border-radius: 50px; border: none; background: transparent; font-size: var(--font-size-xs); font-weight: var(--font-weight-medium); color: var(--tenant-texto-muted); cursor: pointer; font-family: var(--tenant-fuente); transition: background 0.15s, color 0.15s; white-space: nowrap; }
.mini-tab.active { background: var(--tenant-primario); color: #fff; }
.mini-tab:not(.active):hover { background: var(--color-hover); color: var(--tenant-texto); }

.btn-add { display: flex; align-items: center; gap: var(--espacio-2); background: var(--tenant-primario); color: #fff; border: none; border-radius: 10px; padding: var(--espacio-2) var(--espacio-4); font-size: var(--font-size-sm); font-weight: var(--font-weight-bold); cursor: pointer; font-family: var(--tenant-fuente); transition: filter 0.15s; white-space: nowrap; }
.btn-add svg { width: 15px; height: 15px; }
.btn-add:hover { filter: brightness(0.9); }

.btn-add-sm { display: flex; align-items: center; gap: var(--espacio-1); background: rgba(194,96,10,0.08); color: var(--tenant-primario); border: 1px solid rgba(194,96,10,0.2); border-radius: 8px; padding: 4px 12px; font-size: var(--font-size-xs); font-weight: var(--font-weight-medium); cursor: pointer; font-family: var(--tenant-fuente); transition: background 0.15s; white-space: nowrap; }
.btn-add-sm svg { width: 13px; height: 13px; }
.btn-add-sm:hover { background: rgba(194,96,10,0.14); }

.state-msg { font-size: var(--font-size-sm); color: var(--tenant-texto-muted); }

/* ── PROD GRID ── */
.prod-grid { display: flex; flex-direction: column; gap: var(--espacio-3); }

/* ── PROD CARD ── */
.prod-card {
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 16px;
  overflow: hidden;
  transition: border-color 0.15s, box-shadow 0.15s;
}
.prod-card:hover { border-color: var(--tenant-primario); box-shadow: 0 4px 16px rgba(0,0,0,0.05); }
.prod-card--inactivo { opacity: 0.6; border-style: dashed; }
.prod-card--expanded { border-color: var(--tenant-primario); }

.prod-card-header {
  display: flex; align-items: center; gap: var(--espacio-3);
  padding: var(--espacio-4); cursor: pointer;
}

.prod-avatar {
  width: 40px; height: 40px; border-radius: 10px; flex-shrink: 0;
  background: rgba(194,96,10,0.08); color: var(--tenant-primario);
  display: flex; align-items: center; justify-content: center;
}
.prod-avatar svg { width: 20px; height: 20px; }

.prod-info { flex: 1; min-width: 0; }
.prod-nombre { font-size: var(--font-size-base); font-weight: var(--font-weight-bold); color: var(--tenant-texto); display: block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.prod-meta { display: flex; gap: var(--espacio-2); flex-wrap: wrap; margin-top: 3px; }
.prod-precio { font-size: var(--font-size-sm); font-weight: var(--font-weight-bold); color: var(--color-exitoso); }
.prod-cat, .prod-zona { font-size: var(--font-size-xs); color: var(--tenant-texto-muted); background: var(--tenant-fondo); border-radius: 20px; padding: 1px 8px; }

.prod-actions { display: flex; gap: var(--espacio-1); flex-shrink: 0; }

/* ── MENU CARD ── */
.menus-list { display: flex; flex-direction: column; gap: var(--espacio-3); }

.menu-card {
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 16px; overflow: hidden;
  transition: border-color 0.15s;
}
.menu-card:hover { border-color: var(--tenant-primario); }
.menu-card--inactivo { opacity: 0.6; border-style: dashed; }

.menu-card-header { display: flex; align-items: center; gap: var(--espacio-3); padding: var(--espacio-4); cursor: pointer; }

.menu-icon { width: 40px; height: 40px; border-radius: 10px; background: rgba(37,99,235,0.08); color: var(--color-info); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.menu-icon svg { width: 20px; height: 20px; }

.menu-info { flex: 1; min-width: 0; }
.menu-nombre { font-size: var(--font-size-base); font-weight: var(--font-weight-bold); color: var(--tenant-texto); display: block; }
.menu-meta { display: flex; gap: var(--espacio-2); flex-wrap: wrap; margin-top: 3px; }
.menu-tag { font-size: var(--font-size-xs); color: var(--tenant-texto-muted); background: var(--tenant-fondo); border-radius: 20px; padding: 1px 8px; }

/* ── ING PANEL (dentro de prod-card y menu-card) ── */
.ing-panel {
  border-top: 1px solid var(--color-borde);
  padding: var(--espacio-4);
  background: var(--tenant-fondo);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-3);
}

.ing-panel-header { display: flex; align-items: center; justify-content: space-between; gap: var(--espacio-3); }
.ing-panel-title { font-size: var(--font-size-sm); font-weight: var(--font-weight-bold); color: var(--tenant-texto); text-transform: uppercase; letter-spacing: 0.06em; }

.ing-empty { font-size: var(--font-size-sm); color: var(--tenant-texto-muted); text-align: center; padding: var(--espacio-4) 0; }

.ing-groups { display: flex; flex-direction: column; gap: var(--espacio-3); }

.ing-group { display: flex; flex-direction: column; gap: var(--espacio-2); }

.ing-group-label {
  display: flex; align-items: center; gap: var(--espacio-2);
  font-size: var(--font-size-xs); font-weight: var(--font-weight-bold);
  text-transform: uppercase; letter-spacing: 0.08em;
  color: var(--color-exitoso); margin: 0;
}
.ing-group-label--extra { color: var(--tenant-primario); }
.ing-group-label svg { width: 12px; height: 12px; }

.ing-list { display: flex; flex-direction: column; gap: 4px; }

.ing-row {
  display: flex; align-items: center; gap: var(--espacio-2);
  background: var(--color-superficie); border: 1px solid var(--color-borde);
  border-radius: 8px; padding: 6px var(--espacio-3);
  transition: border-color 0.15s;
}
.ing-row:hover { border-color: var(--color-borde); }
.ing-row--inactivo { opacity: 0.5; }

.ing-tipo-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.ing-tipo-dot--obl  { background: var(--color-exitoso); }
.ing-tipo-dot--ext  { background: var(--tenant-primario); }
.ing-tipo-dot--menu { background: var(--color-info); }

.ing-nombre { font-size: var(--font-size-sm); font-weight: var(--font-weight-medium); color: var(--tenant-texto); flex: 1; }
.ing-tipo-tag { font-size: var(--font-size-xs); color: var(--tenant-texto-muted); background: var(--tenant-fondo); border-radius: 20px; padding: 1px 8px; text-transform: capitalize; }
.ing-precio { font-size: var(--font-size-xs); font-weight: var(--font-weight-bold); color: var(--color-exitoso); white-space: nowrap; }

.ing-row-actions { display: flex; gap: 4px; margin-left: auto; flex-shrink: 0; }

/* ── ICON BUTTONS ── */
.icon-btn { width: 30px; height: 30px; border-radius: 8px; border: 1px solid var(--color-borde); background: transparent; cursor: pointer; display: flex; align-items: center; justify-content: center; padding: 0; color: var(--tenant-texto-muted); transition: background 0.15s, border-color 0.15s, color 0.15s, transform 0.2s; }
.icon-btn svg { width: 14px; height: 14px; }
.icon-btn--sm { width: 24px; height: 24px; border-radius: 6px; }
.icon-btn--sm svg { width: 12px; height: 12px; }
.icon-btn--edit:hover   { background: rgba(194,96,10,0.08); border-color: rgba(194,96,10,0.25); color: var(--tenant-primario); }
.icon-btn--delete:hover { background: rgba(220,38,38,0.08); border-color: rgba(220,38,38,0.2);  color: var(--color-error); }
.icon-btn--expand { transition: transform 0.2s; }
.icon-btn--expand.rotated { transform: rotate(180deg); }

/* ── STATUS DOT ── */
.status-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.status-dot--on  { background: var(--color-exitoso); }
.status-dot--off { background: var(--tenant-texto-muted); }

/* ── EMPTY ── */
.empty-state { display: flex; flex-direction: column; align-items: center; gap: var(--espacio-4); padding: var(--espacio-12) 0; }
.empty-state svg { width: 40px; height: 40px; color: var(--color-borde); }
.empty-state p   { margin: 0; font-size: var(--font-size-base); color: var(--tenant-texto-muted); }

/* ── EN CONSTRUCCIÓN ── */
.construction-card {
  background: var(--color-superficie); border: 2px dashed var(--color-borde);
  border-radius: 20px; padding: var(--espacio-12);
  display: flex; flex-direction: column; align-items: center; gap: var(--espacio-4);
  text-align: center; max-width: 500px; margin: var(--espacio-8) auto;
}
.construction-card svg { width: 48px; height: 48px; color: var(--tenant-texto-muted); }
.construction-card h2  { margin: 0; font-size: var(--font-size-xl); font-weight: var(--font-weight-bold); color: var(--tenant-texto); }
.construction-card p   { margin: 0; font-size: var(--font-size-sm); color: var(--tenant-texto-muted); line-height: 1.5; }

/* ── MODAL ── */
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.35); display: flex; align-items: center; justify-content: center; z-index: 100; padding: var(--espacio-6); backdrop-filter: blur(2px); }
.modal { background: var(--color-superficie); border: 1px solid var(--color-borde); border-radius: 20px; width: 100%; max-width: 420px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 24px 60px rgba(0,0,0,0.15); }
.modal--wide { max-width: 560px; }
.modal-header { display: flex; align-items: center; justify-content: space-between; padding: var(--espacio-5) var(--espacio-6); border-bottom: 1px solid var(--color-borde); }
.modal-header h2 { margin: 0; font-size: var(--font-size-md); font-weight: var(--font-weight-bold); color: var(--tenant-texto); }
.modal-close { background: none; border: none; cursor: pointer; color: var(--tenant-texto-muted); display: flex; padding: 4px; border-radius: 6px; transition: background 0.15s; }
.modal-close:hover { background: var(--color-hover); }
.modal-close svg { width: 18px; height: 18px; }
.modal-body { padding: var(--espacio-6); display: flex; flex-direction: column; gap: var(--espacio-4); overflow-y: auto; max-height: 60vh; }
.modal-body--grid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--espacio-4); }
.modal-footer { display: flex; gap: var(--espacio-3); justify-content: flex-end; padding: var(--espacio-4) var(--espacio-6); border-top: 1px solid var(--color-borde); }

/* ── FIELDS ── */
.field       { display: flex; flex-direction: column; gap: var(--espacio-2); }
.field--full { grid-column: 1 / -1; }
.field--row  { flex-direction: row; align-items: center; justify-content: space-between; }
.field label { font-size: var(--font-size-xs); text-transform: uppercase; letter-spacing: .08em; font-weight: var(--font-weight-medium); color: var(--tenant-texto-muted); }
.field input, .field select {
  background: var(--tenant-fondo); border: 1px solid var(--color-borde);
  border-radius: 10px; padding: var(--espacio-3) var(--espacio-4);
  font-size: var(--font-size-base); color: var(--tenant-texto);
  font-family: var(--tenant-fuente); outline: none; transition: border-color .2s;
}
.field input:focus, .field select:focus { border-color: var(--tenant-primario); }

/* ── TOGGLE ── */
.toggle { display: flex; align-items: center; gap: var(--espacio-2); cursor: pointer; font-size: var(--font-size-sm); text-transform: none; letter-spacing: normal; font-weight: var(--font-weight-normal); }
.toggle input { display: none; }
.toggle-slider { width: 36px; height: 20px; background: var(--color-borde); border-radius: 20px; position: relative; transition: background .2s; flex-shrink: 0; }
.toggle-slider::after { content: ''; position: absolute; width: 14px; height: 14px; background: #fff; border-radius: 50%; top: 3px; left: 3px; transition: transform .2s; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
.toggle input:checked + .toggle-slider { background: var(--color-exitoso); }
.toggle input:checked + .toggle-slider::after { transform: translateX(16px); }
.toggle-text--on  { color: var(--color-exitoso); font-weight: var(--font-weight-medium); }
.toggle-text--off { color: var(--tenant-texto-muted); }

/* ── BUTTONS ── */
.btn-primary { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2); background:var(--tenant-primario); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2) var(--espacio-4); font-size:var(--font-size-sm); font-weight:var(--font-weight-bold); cursor:pointer; font-family:var(--tenant-fuente); transition:filter .15s; min-height:38px; }
.btn-primary:hover { filter: brightness(0.9); }
.btn-primary:disabled { opacity:.6; cursor:not-allowed; }
.btn-ghost { background:transparent; border:1px solid var(--color-borde); color:var(--tenant-texto-muted); border-radius:10px; padding:var(--espacio-2) var(--espacio-4); font-size:var(--font-size-sm); font-weight:var(--font-weight-medium); cursor:pointer; font-family:var(--tenant-fuente); transition:background .15s; }
.btn-ghost:hover { background:var(--color-hover); }

/* ── ERROR ── */
.error-msg { background:rgba(220,38,38,.08); border:1px solid rgba(220,38,38,.2); border-radius:10px; padding:var(--espacio-2) var(--espacio-3); font-size:var(--font-size-sm); color:var(--color-error); }

/* ── TOAST ── */
.toast { position:fixed; bottom:var(--espacio-6); left:50%; transform:translateX(-50%); display:flex; align-items:center; gap:var(--espacio-3); padding:var(--espacio-3) var(--espacio-5); border-radius:50px; font-size:var(--font-size-sm); font-weight:var(--font-weight-medium); z-index:200; box-shadow:0 8px 30px rgba(0,0,0,.15); white-space:nowrap; }
.toast svg { width:16px; height:16px; flex-shrink:0; }
.toast--ok    { background:var(--color-exitoso); color:#fff; }
.toast--error { background:var(--color-error);   color:#fff; }

/* ── SPINNER ── */
.spinner { width:16px; height:16px; border:2px solid rgba(255,255,255,.35); border-top-color:#fff; border-radius:50%; animation:spin .7s linear infinite; display:inline-block; }
@keyframes spin { to { transform:rotate(360deg); } }

/* ── WATERMARK ── */
.watermark { position:absolute; bottom:var(--espacio-6); right:var(--espacio-8); display:flex; align-items:center; gap:var(--espacio-2); font-size:var(--font-size-xs); color:var(--tenant-texto-muted); pointer-events:none; }
.watermark strong { color:var(--tenant-primario); font-weight:var(--font-weight-bold); }

/* ── TRANSITIONS ── */
.modal-enter-active, .modal-leave-active { transition:opacity .2s, transform .2s; }
.modal-enter-from, .modal-leave-to { opacity:0; transform:scale(.97); }
.toast-enter-active, .toast-leave-active { transition:opacity .25s, transform .25s; }
.toast-enter-from { opacity:0; transform:translateX(-50%) translateY(12px); }
.toast-leave-to   { opacity:0; transform:translateX(-50%) translateY(12px); }
.slide-down-enter-active, .slide-down-leave-active { transition: max-height 0.25s ease, opacity 0.2s; overflow: hidden; max-height: 800px; }
.slide-down-enter-from, .slide-down-leave-to { max-height: 0; opacity: 0; }
</style>