import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/Login.vue'
import DashboardView from '../views/Dashboard.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: DashboardView,
      meta: { requiresAuth: true }, // Etiqueta para proteger esta ruta
    },
    // ... aquí irán las demás rutas protegidas (/venta, /menu, etc.) agregando el requiresAuth
  ],
})

// GUARDIA DE NAVEGACIÓN (Se ejecuta antes de cada cambio de página)
router.beforeEach((to, from, next) => {
  // Simulamos buscar un token en el navegador
  const isAuthenticated = localStorage.getItem('coffe_token') !== null

  if (to.meta.requiresAuth && !isAuthenticated) {
    // Si la ruta requiere auth y no hay token, lo pateamos al login
    next({ name: 'login' })
  } else if (to.name === 'login' && isAuthenticated) {
    // Si ya está logeado e intenta ir al login, lo mandamos al dashboard
    next({ name: 'dashboard' })
  } else {
    // En cualquier otro caso, lo dejamos pasar
    next()
  }
})

export default router
