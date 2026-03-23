import { createRouter, createWebHistory } from 'vue-router'

// ── VISTAS ──────────────────────────────────────────────────────────────────
import LoginView           from '../views/Login.vue'
import DashboardView       from '../views/Dashboard.vue'
import VentaView           from '../views/Venta.vue'
import KitchenDisplayView  from '../views/KitchenDisplay.vue'

// Las siguientes vistas aún no existen — crear el archivo cuando se implementen
// import MenuView         from '../views/Menu.vue'
// import OrdenesView      from '../views/Ordenes.vue'
// import ClientesView     from '../views/Clientes.vue'
// import EstadisticasView from '../views/Estadisticas.vue'
// import UsuariosView     from '../views/Usuarios.vue'
// import PersonalizacionView from '../views/Personalizacion.vue'
// import VistaPublicaView from '../views/VistaPublica.vue'   // Sin auth — ruta pública

// ── ROLES ───────────────────────────────────────────────────────────────────
// Usados en meta.roles para controlar acceso por perfil
// Roles disponibles: 'admin' | 'gerente' | 'cajero' | 'cocinero'

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
    {
      // Perfil propio — accesible para todos los roles autenticados
      path: '/perfil',
      name: 'perfil',
      component: () => import('../views/Perfil.vue'),
      meta: { requiresAuth: true, roles: ['admin', 'gerente', 'cajero', 'cocinero'] },
    },

    // ── CATCH-ALL ────────────────────────────────────────────────────────────
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'dashboard' },
    },
  ],
})

// ── MAPEO DE ROL — debe coincidir con auth.ts ────────────────────────────────
// El backend devuelve id_rol como número — confirmar con equipo de backend
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
  if (to.meta.requiresAuth && !isAuthenticated) {
    return { name: 'login' }
  }

  // 3. Ruta con restricción de rol → verificar acceso
  const allowedRoles = to.meta.roles as string[] | undefined
  if (allowedRoles && userRole && !allowedRoles.includes(userRole)) {
    if (userRole === 'cocinero') return { name: 'cocina' }
    return { name: 'dashboard' }
  }

  // 4. Todo OK — retornar true deja pasar la navegación
  return true
})

export default router