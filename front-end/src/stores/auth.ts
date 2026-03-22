// stores/auth.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

// ── MAPEO DE ROL ─────────────────────────────────────────────────────────────
// El backend devuelve id_rol como número — confirmar con el equipo de backend
// que estos valores coinciden con la tabla de roles en la BD
const ROL_MAP: Record<number, string> = {
  1: 'admin',
  2: 'gerente',
  3: 'cajero',
  4: 'cocinero',
}

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

export const useAuthStore = defineStore('auth', () => {

  // ── ESTADO ──────────────────────────────────────────────────────────────────
  const token    = ref<string | null>(localStorage.getItem('coffe_token'))
  const rolNum   = ref<number | null>(Number(localStorage.getItem('coffe_role')) || null)
  const nombre   = ref<string | null>(localStorage.getItem('coffe_nombre'))

  // ── GETTERS ─────────────────────────────────────────────────────────────────
  const isAuthenticated = computed(() => token.value !== null)
  const rol             = computed(() => rolNum.value ? ROL_MAP[rolNum.value] ?? null : null)
  const nombreUsuario   = computed(() => nombre.value)

  // ── ACTIONS ─────────────────────────────────────────────────────────────────

  /**
   * Llama a POST /api/usuarios/login
   * Guarda token y rol en localStorage
   * Devuelve { ok, mensaje } para que el componente maneje el error en UI
   */
  async function login(usuario: string, contra: string): Promise<{ ok: boolean; mensaje: string }> {
    try {
      const res = await fetch(`${API_URL}/api/usuarios/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ usuario, contra }),
      })

      const data = await res.json()

      if (!res.ok || data.status !== 'ok') {
        return { ok: false, mensaje: data.mensaje ?? 'Error al iniciar sesión' }
      }

      // Persistir en localStorage — mismo key que ya usa el router guard
      localStorage.setItem('coffe_token',  data.token)
      localStorage.setItem('coffe_role',   String(data.usuario.rol))
      localStorage.setItem('coffe_nombre', data.usuario.nombre)

      // Actualizar estado reactivo
      token.value  = data.token
      rolNum.value = data.usuario.rol
      nombre.value = data.usuario.nombre

      return { ok: true, mensaje: data.mensaje }

    } catch {
      return { ok: false, mensaje: 'No se pudo conectar con el servidor' }
    }
  }

  function logout() {
    localStorage.removeItem('coffe_token')
    localStorage.removeItem('coffe_role')
    localStorage.removeItem('coffe_nombre')
    token.value  = null
    rolNum.value = null
    nombre.value = null
  }

  return { token, rol, nombreUsuario, isAuthenticated, login, logout }
})