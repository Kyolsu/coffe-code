<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useTenantStore } from '../stores/tenant'

const store = useTenantStore()

const colorPrimario     = ref('')
const colorSecundario   = ref('')
const colorFondo        = ref('')
const colorTexto        = ref('')
const colorTextoMuted   = ref('')
const colorOscuroFondo  = ref('')
const colorOscuroTexto  = ref('')
const logoUrl           = ref('')

const guardando    = ref(false)
const restableciendo = ref(false)
const mensaje      = ref('')
const error        = ref('')

onMounted(() => {
  colorPrimario.value    = store.colorPrimario
  colorSecundario.value  = store.colorSecundario
  colorFondo.value       = store.colorFondo
  colorTexto.value       = store.colorTexto
  colorTextoMuted.value  = store.colorTextoMuted
  colorOscuroFondo.value = store.colorOscuroFondo
  colorOscuroTexto.value = store.colorOscuroTexto
  logoUrl.value          = store.logoUrl
})

async function handleGuardar() {
  guardando.value = true
  mensaje.value = ''
  error.value = ''

  const result = await store.guardarConfig({
    colorPrimario: colorPrimario.value,
    colorSecundario: colorSecundario.value,
    colorFondo: colorFondo.value,
    colorTexto: colorTexto.value,
    colorTextoMuted: colorTextoMuted.value,
    colorOscuroFondo: colorOscuroFondo.value,
    colorOscuroTexto: colorOscuroTexto.value,
    logoUrl: logoUrl.value,
  })

  if (result.ok) {
    mensaje.value = result.mensaje
    setTimeout(() => { mensaje.value = '' }, 3000)
  } else {
    error.value = result.mensaje
  }

  guardando.value = false
}

async function handleRestablecer() {
  if (!confirm('¿Restablecer todos los valores a los predeterminados?')) return

  restableciendo.value = true
  mensaje.value = ''
  error.value = ''

  const result = await store.restablecer()

  if (result.ok) {
    colorPrimario.value    = store.colorPrimario
    colorSecundario.value  = store.colorSecundario
    colorFondo.value       = store.colorFondo
    colorTexto.value       = store.colorTexto
    colorTextoMuted.value  = store.colorTextoMuted
    colorOscuroFondo.value = store.colorOscuroFondo
    colorOscuroTexto.value = store.colorOscuroTexto
    logoUrl.value          = store.logoUrl

    mensaje.value = result.mensaje
    setTimeout(() => { mensaje.value = '' }, 3000)
  } else {
    error.value = result.mensaje
  }

  restableciendo.value = false
}

function previewLogo() {
  return logoUrl.value || undefined
}
</script>

<template>
  <div class="layout-principal">
    <main class="contenido-principal">
      <div class="form-wrapper">
        <div class="encabezado">
          <h2>Personalización del Negocio</h2>
          <p>Colores, logo y apariencia general</p>
        </div>

        <Transition name="toast">
          <div v-if="mensaje" class="alerta alerta-exito">{{ mensaje }}</div>
        </Transition>
        <Transition name="toast">
          <div v-if="error" class="alerta alerta-error">{{ error }}</div>
        </Transition>

        <div class="seccion">
          <h3 class="seccion-titulo">Colores principales</h3>

          <div class="form-grid">
            <div class="campo">
              <label for="color-primario">Color principal</label>
              <div class="input-color-wrapper">
                <input id="color-primario" v-model="colorPrimario" type="color" class="input-color" />
                <input v-model="colorPrimario" type="text" class="input-texto-color" placeholder="#002D72" maxlength="7" />
              </div>
            </div>

            <div class="campo">
              <label for="color-secundario">Color secundario</label>
              <div class="input-color-wrapper">
                <input id="color-secundario" v-model="colorSecundario" type="color" class="input-color" />
                <input v-model="colorSecundario" type="text" class="input-texto-color" placeholder="#5C2D6D" maxlength="7" />
              </div>
            </div>

            <div class="campo">
              <label for="color-fondo">Color de fondo</label>
              <div class="input-color-wrapper">
                <input id="color-fondo" v-model="colorFondo" type="color" class="input-color" />
                <input v-model="colorFondo" type="text" class="input-texto-color" placeholder="#f9fafb" maxlength="7" />
              </div>
            </div>

            <div class="campo">
              <label for="color-texto">Color de texto</label>
              <div class="input-color-wrapper">
                <input id="color-texto" v-model="colorTexto" type="color" class="input-color" />
                <input v-model="colorTexto" type="text" class="input-texto-color" placeholder="#111827" maxlength="7" />
              </div>
            </div>

            <div class="campo">
              <label for="color-texto-muted">Color de texto secundario</label>
              <div class="input-color-wrapper">
                <input id="color-texto-muted" v-model="colorTextoMuted" type="color" class="input-color" />
                <input v-model="colorTextoMuted" type="text" class="input-texto-color" placeholder="#6b7280" maxlength="7" />
              </div>
            </div>
          </div>
        </div>

        <div class="seccion">
          <h3 class="seccion-titulo">Barra lateral (Sidebar)</h3>

          <div class="form-grid">
            <div class="campo">
              <label for="color-oscuro-fondo">Fondo de la sidebar</label>
              <div class="input-color-wrapper">
                <input id="color-oscuro-fondo" v-model="colorOscuroFondo" type="color" class="input-color" />
                <input v-model="colorOscuroFondo" type="text" class="input-texto-color" placeholder="#001a45" maxlength="7" />
              </div>
            </div>

            <div class="campo">
              <label for="color-oscuro-texto">Texto de la sidebar</label>
              <div class="input-color-wrapper">
                <input id="color-oscuro-texto" v-model="colorOscuroTexto" type="color" class="input-color" />
                <input v-model="colorOscuroTexto" type="text" class="input-texto-color" placeholder="#f3f4f6" maxlength="7" />
              </div>
              <span class="campo-ayuda">Los bordes, inputs y textos atenuados se derivan automáticamente</span>
            </div>
          </div>
        </div>

        <div class="seccion">
          <h3 class="seccion-titulo">Logo</h3>

          <div class="form-grid">
            <div class="campo campo-logo">
              <label for="logo-url">URL del logo</label>
              <input id="logo-url" v-model="logoUrl" type="text" class="input-largo" placeholder="https://ejemplo.com/logo.png" />
              <div v-if="previewLogo()" class="logo-preview">
                <img :src="previewLogo()" alt="Vista previa del logo" />
              </div>
            </div>
          </div>
        </div>

        <div class="acciones">
          <button
            class="btn-restablecer"
            :disabled="restableciendo || guardando"
            @click="handleRestablecer"
          >
            {{ restableciendo ? 'Restableciendo...' : 'Restablecer predeterminados' }}
          </button>
          <button
            class="btn-guardar"
            :disabled="guardando || restableciendo"
            @click="handleGuardar"
          >
            {{ guardando ? 'Guardando...' : 'Guardar cambios' }}
          </button>
        </div>

        <div class="config-card logo-section">
          <label class="config-label">URL del Logo</label>
          <input type="text" v-model="logoUrl" placeholder="https://ejemplo.com/logo.png" class="logo-input" />
          <div class="logo-preview">
            <img v-if="logoUrl" :src="logoUrl" alt="Logo preview" class="logo-img" @error="logoUrl = ''" />
            <span v-else class="logo-placeholder">Sin logo</span>
          </div>
        </div>

        <button class="btn-guardar" @click="guardarCambios">Guardar cambios</button>

      </div>
    </main>
  </div>
</template>

<style scoped>
.layout-principal {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
  color: var(--tenant-texto);
}

.contenido-principal {
  flex: 1;
  padding: 32px;
  display: flex;
  justify-content: center;
}

.form-wrapper {
  max-width: 640px;
  width: 100%;
}

.encabezado {
  margin-bottom: 28px;
}

.encabezado h2 {
  margin: 0 0 6px;
  font-size: 1.6rem;
  color: var(--tenant-primario);
}

.encabezado p {
  margin: 0;
  color: var(--tenant-texto-muted);
  font-size: 0.95rem;
}

.seccion {
  margin-bottom: 32px;
}

.seccion-titulo {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--tenant-texto-muted);
  margin: 0 0 16px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--color-borde);
}

.alerta {
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 20px;
  font-size: 0.9rem;
  font-weight: 500;
}

.alerta-exito {
  background: color-mix(in srgb, var(--color-exitoso) 15%, transparent);
  color: var(--color-exitoso);
  border: 1px solid color-mix(in srgb, var(--color-exitoso) 30%, transparent);
}

.alerta-error {
  background: color-mix(in srgb, var(--color-error) 15%, transparent);
  color: var(--color-error);
  border: 1px solid color-mix(in srgb, var(--color-error) 30%, transparent);
}

.form-grid {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.campo {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.campo label {
  font-size: 0.85rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: var(--tenant-texto-muted);
}

.campo-ayuda {
  font-size: 0.78rem;
  color: var(--tenant-texto-muted);
  font-style: italic;
}

.input-color-wrapper {
  display: flex;
  align-items: center;
  gap: 10px;
}

.input-color {
  width: 48px;
  height: 48px;
  padding: 2px;
  border: 1px solid var(--color-borde);
  border-radius: 8px;
  cursor: pointer;
  background: none;
}

.input-texto-color {
  flex: 1;
  padding: 10px 14px;
  border: 1px solid var(--color-borde);
  border-radius: 8px;
  font-size: 0.95rem;
  font-family: 'DM Mono', monospace, sans-serif;
  background: var(--color-superficie);
  color: var(--tenant-texto);
  outline: none;
  transition: border-color 0.15s;
}

.input-texto-color:focus {
  border-color: var(--tenant-primario);
}

.input-largo {
  padding: 10px 14px;
  border: 1px solid var(--color-borde);
  border-radius: 8px;
  font-size: 0.95rem;
  background: var(--color-superficie);
  color: var(--tenant-texto);
  outline: none;
  transition: border-color 0.15s;
}

.input-largo:focus {
  border-color: var(--tenant-primario);
}

.logo-preview {
  margin-top: 10px;
  padding: 16px;
  border: 1px dashed var(--color-borde);
  border-radius: 8px;
  display: flex;
  justify-content: center;
  align-items: center;
  background: var(--color-superficie-alt);
  min-height: 80px;
}

.logo-preview img {
  max-height: 64px;
  max-width: 100%;
  object-fit: contain;
}

.acciones {
  margin-top: 32px;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.btn-restablecer {
  padding: 12px 24px;
  background: transparent;
  color: var(--color-error);
  border: 1px solid var(--color-error);
  border-radius: 10px;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.15s, opacity 0.15s;
}

.btn-restablecer:hover:not(:disabled) {
  background: color-mix(in srgb, var(--color-error) 10%, transparent);
}

.btn-restablecer:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-guardar {
  padding: 12px 32px;
  background: var(--tenant-primario);
  color: #fff;
  border: none;
  border-radius: 10px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.15s, transform 0.1s;
}

.btn-guardar:hover:not(:disabled) {
  opacity: 0.9;
}

.btn-guardar:active:not(:disabled) {
  transform: scale(0.97);
}

.btn-guardar:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.toast-enter-active,
.toast-leave-active {
  transition: opacity 0.25s ease;
}
.toast-enter-from,
.toast-leave-to {
  opacity: 0;
}
</style>
