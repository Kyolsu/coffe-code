import { createRouter, createWebHistory } from 'vue-router'
import { API_URL } from '../config/api'
import { useAuthStore } from '../stores/auth'

// ── VISTAS Y LAYOUTS ────────────────────────────────────────────────────────
import MainLayout          from '../layouts/MainLayout.vue'
import LoginView           from '../views/Login.vue'
import DashboardView       from '../views/Dashboard.vue'
import VentaView           from '../views/Venta.vue'
import KitchenDisplayView  from '../views/KitchenDisplay.vue'

// ── MAPEO: nombre de ruta → id_permiso en BD ────────────────────────────────
// (Usado en meta.permissionId de cada ruta)

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [

    // ── PÚBLICAS (Sin Sidebar) ──────────────────────────────────────────────
    {
      path: '/login',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/menu-publico',
      name: 'menu-publico',
      component: () => import('../views/VistaPublica.vue'),
    },
    {
      path: '/vista-publica',
      name: 'vista-publica',
      component: () => import('../views/VistaPublica.vue'),
    },

    // ── PROTEGIDAS (Envueltas en MainLayout con Sidebar) ─────────────────────
    {
      path: '/',
      component: MainLayout,
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          redirect: { name: 'dashboard' },
        },
        {
          path: 'dashboard',
          name: 'dashboard',
          component: DashboardView,
          meta: { requiresAuth: true, permissionId: 1 },
        },
        {
          path: 'venta',
          name: 'venta',
          component: VentaView,
          meta: { requiresAuth: true, permissionId: 2 },
        },
        {
          path: 'cocina',
          name: 'cocina',
          component: KitchenDisplayView,
          meta: { requiresAuth: true, permissionId: 5 },
        },
        {
          path: 'menu',
          name: 'menu',
          component: () => import('../views/Menu.vue'),
          meta: { requiresAuth: true, permissionId: 3 },
        },
        {
          path: 'ordenes',
          name: 'ordenes',
          component: () => import('../views/Ordenes.vue'),
          meta: { requiresAuth: true, permissionId: 4 },
        },
        {
          path: 'clientes',
          name: 'clientes',
          component: () => import('../views/Clientes.vue'),
          meta: { requiresAuth: true, permissionId: 6 },
        },
        {
          path: 'estadisticas',
          name: 'estadisticas',
          component: () => import('../views/Estadisticas.vue'),
          meta: { requiresAuth: true, permissionId: 7 },
        },
        {
          path: 'usuarios',
          name: 'usuarios',
          component: () => import('../views/Usuarios.vue'),
          meta: { requiresAuth: true, permissionId: 8 },
        },
        {
          path: 'personalizacion',
          name: 'personalizacion',
          component: () => import('../views/Personalizacion.vue'),
          meta: { requiresAuth: true, permissionId: 9 },
        },
        {
          path: 'perfil',
          name: 'perfil',
          component: () => import('../views/Perfil.vue'),
          meta: { requiresAuth: true },
        },
        {
          path: 'personalizacion',
          name: 'personalizacion',
          component: () => import('../views/Personalizacion.vue'),
          meta: { requiresAuth: true, permissionId: 9 },
        },
      ],
    },

    // ── CATCH-ALL ────────────────────────────────────────────────────────────
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'dashboard' },
    },
  ],
})

// ── RUTAS PÚBLICAS (sin validación de token) ───────────────────────────────
const RUTAS_PUBLICAS = ['login', 'vista-publica', 'menu-publico']

// ── VERIFICACIÓN DE TOKEN CON BACKEND ────────────────────────────────────────
let tokenValidationPromise: Promise<boolean> | null = null

async function validarTokenConBackend(): Promise<boolean> {
  const token = localStorage.getItem('coffe_token')
  if (!token) return false

  try {
    const res = await fetch(`${API_URL}/api/usuarios/perfil`, {
      headers: { 'auth-token': token }
    })
    return res.ok
  } catch {
    return false
  }
}

function limpiarSesion() {
  localStorage.removeItem('coffe_token')
  localStorage.removeItem('coffe_role')
  localStorage.removeItem('coffe_nombre')
}

// ── CARGAR PERMISOS EN LOGIN ────────────────────────────────────────────────
async function cargarPermisos(): Promise<void> {
  const token = localStorage.getItem('coffe_token')
  if (!token) return

  try {
    const res = await fetch(`${API_URL}/api/usuarios/permisos/roles/mostrar`, {
      headers: { 'auth-token': token }
    })
    const data = await res.json()
    if (data.status === 'ok' && data.datos) {
      const grouped: Record<number, number[]> = {}
      for (const row of data.datos) {
        if (!grouped[row.id_rol]) grouped[row.id_rol] = []
        grouped[row.id_rol]!.push(row.id_permiso)
      }
      window.__permisosPorRol = grouped
    }
  } catch {
    console.error('Error cargando permisos')
  }
}

declare global {
  interface Window {
    __permisosPorRol: Record<number, number[]>
  }
}

function tienePermiso(permissionId: number): boolean {
  const rolId = Number(localStorage.getItem('coffe_role')) || 0
  const permisos = window.__permisosPorRol?.[rolId] ?? []
  return permisos.includes(permissionId)
}

// ── GUARDIA DE NAVEGACIÓN ────────────────────────────────────────────────────
router.beforeEach(async (to, _from) => {
  const token           = localStorage.getItem('coffe_token')
  const isAuthenticated = token !== null

  // 0. Rutas públicas sin validación de token
  if (RUTAS_PUBLICAS.includes(to.name as string)) {
    return true
  }

  // 1. Ruta pública con sesión activa → al dashboard
  if (to.name === 'login' && isAuthenticated) {
    return { name: 'dashboard' }
  }

  // 2. Ruta protegida → verificar que tenga token Y que sea válido con el backend
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!token) {
      return { name: 'login' }
    }

    // Validar token con el backend (solo una vez por navegación)
    if (!tokenValidationPromise) {
      tokenValidationPromise = validarTokenConBackend()
    }

    const tokenValido = await tokenValidationPromise
    tokenValidationPromise = null

    if (!tokenValido) {
      limpiarSesion()
      return { name: 'login', query: { expired: 'true' } }
    }

    // Cargar permisos si no están cargados
    if (!window.__permisosPorRol) {
      const authStore = useAuthStore()
      await authStore.cargarPermisos()
    }
  }

  // 3. Verificar permiso específico de la ruta
  const permissionId = to.meta.permissionId as number | undefined
  if (permissionId !== undefined) {
    if (!tienePermiso(permissionId)) {
      const rolId = Number(localStorage.getItem('coffe_role')) || 0
      if (rolId === 3 || rolId === 4) return { name: 'cocina' }
      return { name: 'dashboard' }
    }
  }

  // 4. Todo OK
  return true
})

export default router