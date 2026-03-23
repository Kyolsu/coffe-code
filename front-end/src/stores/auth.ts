// stores/auth.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

// ── MAPEO DE ROL ─────────────────────────────────────────────────────────────
// Confirmar con el equipo de backend qué número corresponde a cada rol
const ROL_MAP: Record<number, string> = {
  1: 'admin',
  2: 'gerente',
  3: 'cajero',
  4: 'cocinero',
}

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

export const useAuthStore = defineStore('auth', () => {

  // ── ESTADO ──────────────────────────────────────────────────────────────────
  const token  = ref<string | null>(localStorage.getItem('coffe_token'))
  const rolNum = ref<number | null>(Number(localStorage.getItem('coffe_role')) || null)
  const nombre = ref<string | null>(localStorage.getItem('coffe_nombre'))

  // ── GETTERS ─────────────────────────────────────────────────────────────────
  const isAuthenticated = computed(() => token.value !== null)
  const rol             = computed(() => rolNum.value ? ROL_MAP[rolNum.value] ?? null : null)
  const nombreUsuario   = computed(() => nombre.value)

  /**
   * Headers para cualquier petición autenticada.
   * ⚠️  El backend usa "auth-token" como llave, NO "Authorization: Bearer".
   *
   * Uso:
   *   const res = await fetch(url, { headers: authStore.authHeaders() })
   *   const res = await fetch(url, { method:'POST', headers: authStore.authHeaders(), body: JSON.stringify(data) })
   */
  const authHeaders = (): Record<string, string> => ({
    'Content-Type': 'application/json',
    'auth-token': token.value ?? '',
  })

  // ── LOGIN ───────────────────────────────────────────────────────────────────
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

      localStorage.setItem('coffe_token',  data.token)
      localStorage.setItem('coffe_role',   String(data.usuario.rol))
      localStorage.setItem('coffe_nombre', data.usuario.nombre)

      token.value  = data.token
      rolNum.value = data.usuario.rol
      nombre.value = data.usuario.nombre

      return { ok: true, mensaje: data.mensaje }
    } catch {
      return { ok: false, mensaje: 'No se pudo conectar con el servidor' }
    }
  }

  // ── PERFIL ──────────────────────────────────────────────────────────────────
  // GET /api/usuarios/perfil — requiere auth-token
  async function fetchPerfil(): Promise<{ id: number; nombre: string; rol: number } | null> {
    try {
      const res  = await fetch(`${API_URL}/api/usuarios/perfil`, { headers: authHeaders() })
      const data = await res.json()
      if (data.status === 'ok') return data.datos
      return null
    } catch {
      return null
    }
  }

  // ── LOGOUT ──────────────────────────────────────────────────────────────────
  function logout() {
    localStorage.removeItem('coffe_token')
    localStorage.removeItem('coffe_role')
    localStorage.removeItem('coffe_nombre')
    token.value  = null
    rolNum.value = null
    nombre.value = null
  }

  return { token, rol, nombreUsuario, isAuthenticated, authHeaders, login, logout, fetchPerfil }
})