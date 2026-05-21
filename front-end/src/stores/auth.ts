// stores/auth.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { API_URL } from '../config/api'

const ROL_MAP: Record<number, string> = {
  1: 'admin',
  2: 'caja',
  3: 'cocina',
  4: 'bebidas',
  6: 'seguridad',
}

export const useAuthStore = defineStore('auth', () => {

  // ── ESTADO ──────────────────────────────────────────────────────────────────
  const token  = ref<string | null>(localStorage.getItem('coffe_token'))
  const rolNum = ref<number | null>(Number(localStorage.getItem('coffe_role')) || null)
  const nombre = ref<string | null>(localStorage.getItem('coffe_nombre'))

  // ── PERMISOS DINÁMICOS (cargados desde BD) ─────────────────────────────────
  const permisosRaw = ref<Record<number, number[]>>({}) // { rolId: [permisoId, ...] }
  const permisosLoaded = ref(false)

  async function cargarPermisos() {
    if (permisosLoaded.value) return
    try {
      const res = await fetch(`${API_URL}/api/usuarios/permisos/roles/mostrar`, {
        headers: { 'auth-token': token.value ?? '' }
      })
      const data = await res.json()
      if (data.status === 'ok' && data.datos) {
        const grouped: Record<number, number[]> = {}
        for (const row of data.datos) {
          if (!grouped[row.id_rol]) grouped[row.id_rol] = []
          grouped[row.id_rol]!.push(row.id_permiso)
        }
        permisosRaw.value = grouped
      }
    } catch {
      console.error('Error cargando permisos')
    }
    permisosLoaded.value = true
  }

  // ── GETTERS ─────────────────────────────────────────────────────────────────
  const isAuthenticated = computed(() => token.value !== null)
  const rol             = computed(() => rolNum.value ? ROL_MAP[rolNum.value] ?? null : null)
  const nombreUsuario   = computed(() => nombre.value)

  const permisosDelRol = computed(() => {
    if (!rolNum.value) return []
    return window.__permisosPorRol?.[rolNum.value] ?? []
  })

  function tienePermiso(idPermiso: number): boolean {
    return permisosDelRol.value.includes(idPermiso)
  }

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

      permisosLoaded.value = false
      await cargarPermisos()

      return { ok: true, mensaje: data.mensaje }
    } catch {
      return { ok: false, mensaje: 'No se pudo conectar con el servidor' }
    }
  }

  // ── PERFIL ──────────────────────────────────────────────────────────────────
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
    permisosRaw.value = {}
    permisosLoaded.value = false
  }

  return { 
    token, rol, rolNum, permisosDelRol, nombreUsuario, isAuthenticated, 
    authHeaders, tienePermiso, login, logout, fetchPerfil, cargarPermisos 
  }
})