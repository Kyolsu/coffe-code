import { defineStore } from 'pinia'
import { ref } from 'vue'
import { API_URL } from '../config/api'
import { useAuthStore } from './auth'

function adjustHex(hex: string, amount: number): string {
  const clean = hex.replace('#', '')
  const num = parseInt(clean, 16)
  const r = Math.max(0, Math.min(255, (num >> 16) + amount))
  const g = Math.max(0, Math.min(255, ((num >> 8) & 0x00ff) + amount))
  const b = Math.max(0, Math.min(255, (num & 0x0000ff) + amount))
  return `#${((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)}`
}

export const useTenantStore = defineStore('tenant', () => {
  const colorPrimario     = ref('#002D72')
  const colorSecundario   = ref('#5C2D6D')
  const colorFondo        = ref('#f9fafb')
  const colorTexto        = ref('#111827')
  const colorTextoMuted   = ref('#6b7280')
  const colorOscuroFondo  = ref('#001a45')
  const colorOscuroTexto  = ref('#f3f4f6')
  const logoUrl           = ref('')

  const cargando = ref(false)

  function aplicarTema() {
    const root = document.documentElement

    root.style.setProperty('--tenant-primario', colorPrimario.value)
    root.style.setProperty('--tenant-secundario', colorSecundario.value)
    root.style.setProperty('--tenant-fondo', colorFondo.value)
    root.style.setProperty('--tenant-texto', colorTexto.value)
    root.style.setProperty('--tenant-texto-muted', colorTextoMuted.value)
    root.style.setProperty('--tenant-logo-url', logoUrl.value ? `url(${logoUrl.value})` : 'none')

    root.style.setProperty('--color-oscuro-fondo', colorOscuroFondo.value)
    root.style.setProperty('--color-oscuro-texto', colorOscuroTexto.value)
    root.style.setProperty('--color-oscuro-borde', adjustHex(colorOscuroFondo.value, 15))
    root.style.setProperty('--color-oscuro-input', adjustHex(colorOscuroFondo.value, 8))
    root.style.setProperty('--color-oscuro-texto-muted', adjustHex(colorOscuroTexto.value, -40))
    root.style.setProperty('--color-oscuro-placeholder', adjustHex(colorOscuroTexto.value, -60))
  }

  async function cargarConfig() {
    try {
      cargando.value = true
      const res = await fetch(`${API_URL}/api/personalizacion/mostrar`)
      const data = await res.json()

      if (data.status === 'ok' && data.datos) {
        colorPrimario.value    = data.datos.colorPrimario    ?? colorPrimario.value
        colorSecundario.value  = data.datos.colorSecundario  ?? colorSecundario.value
        colorFondo.value       = data.datos.colorFondo       ?? colorFondo.value
        colorTexto.value       = data.datos.colorTexto       ?? colorTexto.value
        colorTextoMuted.value  = data.datos.colorTextoMuted  ?? colorTextoMuted.value
        colorOscuroFondo.value = data.datos.colorOscuroFondo ?? colorOscuroFondo.value
        colorOscuroTexto.value = data.datos.colorOscuroTexto ?? colorOscuroTexto.value
        logoUrl.value          = data.datos.logoUrl          ?? logoUrl.value
        aplicarTema()
      }
    } catch {
      console.warn('No se pudo cargar la configuración del negocio')
    } finally {
      cargando.value = false
    }
  }

  async function guardarConfig(data: {
    colorPrimario?: string
    colorSecundario?: string
    colorFondo?: string
    colorTexto?: string
    colorTextoMuted?: string
    colorOscuroFondo?: string
    colorOscuroTexto?: string
    logoUrl?: string
  }): Promise<{ ok: boolean; mensaje: string }> {
    try {
      const authStore = useAuthStore()
      const res = await fetch(`${API_URL}/api/personalizacion/guardar`, {
        method: 'PUT',
        headers: authStore.authHeaders(),
        body: JSON.stringify(data),
      })
      const json = await res.json()

      if (json.status === 'ok') {
        if (json.datos) {
          colorPrimario.value    = json.datos.colorPrimario    ?? colorPrimario.value
          colorSecundario.value  = json.datos.colorSecundario  ?? colorSecundario.value
          colorFondo.value       = json.datos.colorFondo       ?? colorFondo.value
          colorTexto.value       = json.datos.colorTexto       ?? colorTexto.value
          colorTextoMuted.value  = json.datos.colorTextoMuted  ?? colorTextoMuted.value
          colorOscuroFondo.value = json.datos.colorOscuroFondo ?? colorOscuroFondo.value
          colorOscuroTexto.value = json.datos.colorOscuroTexto ?? colorOscuroTexto.value
          logoUrl.value          = json.datos.logoUrl          ?? logoUrl.value
        }
        aplicarTema()
        return { ok: true, mensaje: json.mensaje ?? 'Configuración guardada' }
      }

      return { ok: false, mensaje: json.mensaje ?? 'Error al guardar' }

    } catch {
      return { ok: false, mensaje: 'No se pudo conectar con el servidor' }
    }
  }

  async function restablecer(): Promise<{ ok: boolean; mensaje: string }> {
    try {
      const authStore = useAuthStore()
      const res = await fetch(`${API_URL}/api/personalizacion/restablecer`, {
        method: 'PUT',
        headers: authStore.authHeaders(),
      })
      const json = await res.json()

      if (json.status === 'ok') {
        if (json.datos) {
          colorPrimario.value    = json.datos.colorPrimario
          colorSecundario.value  = json.datos.colorSecundario
          colorFondo.value       = json.datos.colorFondo
          colorTexto.value       = json.datos.colorTexto
          colorTextoMuted.value  = json.datos.colorTextoMuted
          colorOscuroFondo.value = json.datos.colorOscuroFondo
          colorOscuroTexto.value = json.datos.colorOscuroTexto
          logoUrl.value          = json.datos.logoUrl ?? ''
        }
        aplicarTema()
        return { ok: true, mensaje: json.mensaje ?? 'Valores restablecidos' }
      }

      return { ok: false, mensaje: json.mensaje ?? 'Error al restablecer' }

    } catch {
      return { ok: false, mensaje: 'No se pudo conectar con el servidor' }
    }
  }

  return {
    colorPrimario, colorSecundario, colorFondo, colorTexto, colorTextoMuted,
    colorOscuroFondo, colorOscuroTexto, logoUrl,
    cargando, cargarConfig, guardarConfig, restablecer, aplicarTema,
  }
})
