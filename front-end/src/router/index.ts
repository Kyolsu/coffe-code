import { createRouter, createWebHistory } from 'vue-router'

// ── VISTAS Y LAYOUTS ────────────────────────────────────────────────────────
import MainLayout          from '../layouts/MainLayout.vue' // <-- Importa tu nuevo layout
import LoginView           from '../views/Login.vue'
import DashboardView       from '../views/Dashboard.vue'
import VentaView           from '../views/Venta.vue'
import KitchenDisplayView  from '../views/KitchenDisplay.vue'

// ── ROLES ───────────────────────────────────────────────────────────────────
// Roles disponibles: 'admin' | 'gerente' | 'cajero' | 'cocinero'

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
      component: MainLayout, // <-- El layout actúa como envoltura
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
          meta: { roles: ['admin', 'caja', 'cocina', 'bebidas'] },
        },
        {
          path: 'venta',
          name: 'venta',
          component: VentaView,
          meta: { roles: ['admin', 'caja', 'cocina', 'bebidas'] },
        },
        {
          path: 'cocina',
          name: 'cocina',
          component: KitchenDisplayView,
          meta: { roles: ['admin', 'caja', 'cocina', 'bebidas'] },
        },
        {
          path: 'menu',
          name: 'menu',
          component: () => import('../views/Menu.vue'),
          meta: { roles: ['admin', 'caja'] },
        },
        {
          path: 'ordenes',
          name: 'ordenes',
          component: () => import('../views/Ordenes.vue'),
          meta: { roles: ['admin', 'caja', 'cocina', 'bebidas'] },
        },
        {
          path: 'clientes',
          name: 'clientes',
          component: () => import('../views/Clientes.vue'),
          meta: { roles: ['admin', 'caja', 'cocina', 'bebidas'] },
        },
        {
          path: 'estadisticas',
          name: 'estadisticas',
          component: () => import('../views/Estadisticas.vue'),
          meta: { roles: ['admin', 'caja'] },
        },
        {
          path: 'usuarios',
          name: 'usuarios',
          component: () => import('../views/Usuarios.vue'),
          meta: { roles: ['admin'], requiresAdmin: true },
        },
        {
          path: 'personalizacion',
          name: 'personalizacion',
          component: () => import('../views/Personalizacion.vue'),
          meta: { roles: ['admin'], requiresAdmin: true },
        },
        {
          path: 'perfil',
          name: 'perfil',
          component: () => import('../views/Perfil.vue'),
          meta: { roles: ['admin', 'caja', 'cocina', 'bebidas'] },
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

// ── MAPEO DE ROL ─────────────────────────────────────────────────────────────
const ROL_MAP: Record<string, string> = {
  '1': 'admin',
  '2': 'caja',
  '3': 'cocina',
  '4': 'bebidas',
  '6': 'seguridad',
}

// ── RUTAS PÚBLICAS (sin validación de token) ───────────────────────────────
const RUTAS_PUBLICAS = ['login', 'vista-publica', 'menu-publico']

// ── VERIFICACIÓN DE TOKEN CON BACKEND ───────────────────────────────────────
let tokenValidationPromise: Promise<boolean> | null = null

async function validarTokenConBackend(): Promise<boolean> {
  const token = localStorage.getItem('coffe_token')
  if (!token) return false

  try {
    const res = await fetch(`${import.meta.env.RENDER_API_URL || 'https://coffe-code-s7t9.onrender.com'}/api/usuarios/perfil`, {
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

// ── GUARDIA DE NAVEGACIÓN ────────────────────────────────────────────────────
router.beforeEach(async (to, _from) => {
  const token           = localStorage.getItem('coffe_token')
  const isAuthenticated = token !== null

  const rolId    = localStorage.getItem('coffe_role') ?? ''
  const userRole = ROL_MAP[rolId] ?? null

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
    tokenValidationPromise = null // Reset para próxima navegación

    if (!tokenValido) {
      limpiarSesion()
      return { name: 'login', query: { expired: 'true' } }
    }
  }

  // 3. Ruta con restricción de rol → verificar acceso
  const allowedRoles = to.meta.roles as string[] | undefined
  if (allowedRoles && userRole && !allowedRoles.includes(userRole)) {
    if (userRole === 'cocina' || userRole === 'bebidas') return { name: 'cocina' }
    return { name: 'dashboard' }
  }

  // 4. Todo OK
  return true
})

export default router