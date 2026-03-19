import { createRouter, createWebHistory } from 'vue-router'

// ── VISTAS ──────────────────────────────────────────────────────────────────
import LoginView           from '../views/Login.vue'
import DashboardView       from '../views/Dashboard.vue'
import VentaView           from '../views/Venta.vue'
import KitchenDisplayView  from '../views/KitchenDisplay.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [

    // ── PÚBLICA ─────────────────────────────────────────────────────────────
    {
      path: '/login',
      name: 'login',
      component: LoginView,
    },
    {
      // Vista pública del menú para los clientes — sin autenticación
      path: '/menu-publico',
      name: 'vista-publica',
      component: () => import('../views/VistaPublica.vue'), // lazy load
    },

    // ── PROTEGIDAS ───────────────────────────────────────────────────────────
    {
      path: '/',
      redirect: { name: 'dashboard' },
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: DashboardView,
      meta: { requiresAuth: true, roles: ['admin', 'gerente', 'cajero'] },
    },
    {
      path: '/venta',
      name: 'venta',
      component: VentaView,
      meta: { requiresAuth: true, roles: ['admin', 'gerente', 'cajero'] },
    },
    {
      path: '/cocina',
      name: 'cocina',
      component: KitchenDisplayView,
      meta: { requiresAuth: true, roles: ['admin', 'gerente', 'cocinero'] },
    },
    {
      path: '/menu',
      name: 'menu',
      component: () => import('../views/Menu.vue'),
      meta: { requiresAuth: true, roles: ['admin', 'gerente'] },
    },
    {
      path: '/ordenes',
      name: 'ordenes',
      component: () => import('../views/Ordenes.vue'),
      meta: { requiresAuth: true, roles: ['admin', 'gerente', 'cajero'] },
    },
    {
      path: '/clientes',
      name: 'clientes',
      component: () => import('../views/Clientes.vue'),
      meta: { requiresAuth: true, roles: ['admin', 'gerente', 'cajero'] },
    },
    {
      path: '/estadisticas',
      name: 'estadisticas',
      component: () => import('../views/Estadisticas.vue'),
      meta: { requiresAuth: true, roles: ['admin', 'gerente'] },
    },
    {
      path: '/usuarios',
      name: 'usuarios',
      component: () => import('../views/Usuarios.vue'),
      meta: { requiresAuth: true, roles: ['admin'] },
    },
    {
      path: '/personalizacion',
      name: 'personalizacion',
      component: () => import('../views/Personalizacion.vue'),
      meta: { requiresAuth: true, roles: ['admin'] },
    },

    // ── CATCH-ALL ────────────────────────────────────────────────────────────
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'dashboard' },
    },
  ],
})

// ── GUARDIA DE NAVEGACIÓN ────────────────────────────────────────────────────
router.beforeEach((to, _from, next) => {
  const token = localStorage.getItem('coffe_token')
  const isAuthenticated = token !== null

  // TODO: cuando exista la API, decodificar el JWT para obtener el rol real
  // Por ahora se lee de localStorage como mock
  const userRole = localStorage.getItem('coffe_role') as string | null

  // 1. Ruta pública (login, vista-publica) con sesión activa → al dashboard
  if (to.name === 'login' && isAuthenticated) {
    return next({ name: 'dashboard' })
  }

  // 2. Ruta protegida sin sesión → al login
  if (to.meta.requiresAuth && !isAuthenticated) {
    return next({ name: 'login' })
  }

  // 3. Ruta con restricción de rol → verificar acceso
  const allowedRoles = to.meta.roles as string[] | undefined
  if (allowedRoles && userRole && !allowedRoles.includes(userRole)) {
    // El rol no tiene permiso — redirigir según su perfil
    if (userRole === 'cocinero') return next({ name: 'cocina' })
    return next({ name: 'dashboard' })
  }

  // 4. Todo OK
  next()
})

export default router