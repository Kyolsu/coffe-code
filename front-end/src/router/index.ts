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
          meta: { roles: ['admin', 'gerente', 'cajero'] },
        },
        {
          path: 'venta',
          name: 'venta',
          component: VentaView,
          meta: { roles: ['admin', 'gerente', 'cajero'] },
        },
        {
          path: 'cocina',
          name: 'cocina',
          component: KitchenDisplayView,
          meta: { roles: ['admin', 'gerente', 'cocinero'] },
        },
        {
          path: 'menu',
          name: 'menu',
          component: () => import('../views/Menu.vue'),
          meta: { roles: ['admin', 'gerente'] },
        },
        {
          path: 'ordenes',
          name: 'ordenes',
          component: () => import('../views/Ordenes.vue'),
          meta: { roles: ['admin', 'gerente', 'cajero'] },
        },
        {
          path: 'clientes',
          name: 'clientes',
          component: () => import('../views/Clientes.vue'),
          meta: { roles: ['admin', 'gerente', 'cajero'] },
        },
        {
          path: 'estadisticas',
          name: 'estadisticas',
          component: () => import('../views/Estadisticas.vue'),
          meta: { roles: ['admin', 'gerente'] },
        },
        {
          path: 'usuarios',
          name: 'usuarios',
          component: () => import('../views/Usuarios.vue'),
          meta: { roles: ['admin'] },
        },
        {
          path: 'personalizacion',
          name: 'personalizacion',
          component: () => import('../views/Personalizacion.vue'),
          meta: { roles: ['admin'] },
        },
        {
          path: 'perfil',
          name: 'perfil',
          component: () => import('../views/Perfil.vue'),
          meta: { roles: ['admin', 'gerente', 'cajero', 'cocinero'] },
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
  '2': 'gerente',
  '3': 'cajero',
  '4': 'cocinero',
}

// ── GUARDIA DE NAVEGACIÓN ────────────────────────────────────────────────────
router.beforeEach((to, _from) => {
  const token           = localStorage.getItem('coffe_token')
  const isAuthenticated = token !== null

  const rolId    = localStorage.getItem('coffe_role') ?? ''
  const userRole = ROL_MAP[rolId] ?? null

  // 1. Ruta pública con sesión activa → al dashboard
  if (to.name === 'login' && isAuthenticated) {
    return { name: 'dashboard' }
  }

  // 2. Ruta protegida sin sesión → al login
  // Al poner to.matched.some podemos verificar si el padre (Layout) requiere Auth
  if (to.matched.some(record => record.meta.requiresAuth) && !isAuthenticated) {
    return { name: 'login' }
  }

  // 3. Ruta con restricción de rol → verificar acceso
  const allowedRoles = to.meta.roles as string[] | undefined
  if (allowedRoles && userRole && !allowedRoles.includes(userRole)) {
    if (userRole === 'cocinero') return { name: 'cocina' }
    return { name: 'dashboard' }
  }

  // 4. Todo OK
  return true
})

export default router