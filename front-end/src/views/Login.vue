<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router    = useRouter()
const authStore = useAuthStore()

const usuario  = ref('')
const contra   = ref('')
const loading  = ref(false)
const error    = ref('')
const mostrarContra = ref(false)

const handleLogin = async () => {
  error.value = ''

  if (!usuario.value || !contra.value) {
    error.value = 'Completa todos los campos'
    return
  }

  loading.value = true

  const { ok, mensaje } = await authStore.login(usuario.value, contra.value)

  loading.value = false

  if (ok) {
    router.push({ name: 'dashboard' })
  } else {
    error.value = mensaje
  }
}
</script>

<template>
  <div class="login-layout">

    <div class="login-card">

      <!-- Logo -->
      <div class="login-logo">
        <div class="logo-circle">Logo</div>
      </div>

      <!-- Título -->
      <div class="login-header">
        <h1 class="login-title">Bienvenido</h1>
        <p class="login-subtitle">Inicia sesión para continuar</p>
      </div>

      <!-- Formulario -->
      <div class="login-form">

        <div class="field">
          <label class="field-label">Usuario</label>
          <div class="field-input-wrap">
            <svg class="field-icon" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.5"/>
              <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
            <input
              v-model="usuario"
              type="text"
              class="field-input"
              placeholder="Nombre de usuario"
              autocomplete="username"
              @keyup.enter="handleLogin"
            />
          </div>
        </div>

        <div class="field">
          <label class="field-label">Contraseña</label>
          <div class="field-input-wrap">
            <svg class="field-icon" viewBox="0 0 24 24" fill="none">
              <rect x="3" y="11" width="18" height="11" rx="2" stroke="currentColor" stroke-width="1.5"/>
              <path d="M7 11V7a5 5 0 0110 0v4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
            <input
              v-model="contra"
              :type="mostrarContra ? 'text' : 'password'"
              class="field-input"
              placeholder="Contraseña"
              autocomplete="current-password"
              @keyup.enter="handleLogin"
            />
            <button
              class="toggle-pass"
              type="button"
              @click="mostrarContra = !mostrarContra"
              :title="mostrarContra ? 'Ocultar' : 'Mostrar'"
            >
              <!-- Ojo abierto -->
              <svg v-if="!mostrarContra" viewBox="0 0 24 24" fill="none">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" stroke="currentColor" stroke-width="1.5"/>
                <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>
              </svg>
              <!-- Ojo cerrado -->
              <svg v-else viewBox="0 0 24 24" fill="none">
                <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19M1 1l22 22" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Error -->
        <Transition name="error-fade">
          <div v-if="error" class="error-msg">
            <svg viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
              <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
            {{ error }}
          </div>
        </Transition>

        <!-- Botón -->
        <button
          class="login-btn"
          :class="{ loading }"
          :disabled="loading"
          @click="handleLogin"
        >
          <span v-if="!loading">Iniciar sesión</span>
          <span v-else class="spinner"></span>
        </button>

      </div>

      <!-- Watermark -->
      <div class="login-watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </div>

  </div>
</template>

<style scoped>
.login-layout {
  min-height: 100vh;
  background-color: var(--tenant-fondo, #000);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--espacio-6, 24px);
}

/* ── CARD ── */
.login-card {
  width: 100%;
  max-width: 380px;
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  border-radius: 24px;
  padding: var(--espacio-8, 32px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-6, 24px);
}

/* ── LOGO ── */
.login-logo {
  display: flex;
  justify-content: center;
}

.logo-circle {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  border: 1.5px solid #2a2a2a;
  background: #111;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
  font-weight: var(--font-weight-medium, 500);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* ── HEADER ── */
.login-header {
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: var(--espacio-1, 4px);
}

.login-title {
  margin: 0;
  font-size: var(--font-size-xl, 24px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #fff);
}

.login-subtitle {
  margin: 0;
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto-muted, #78716c);
}

/* ── FORM ── */
.login-form {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-4, 16px);
}

.field {
  display: flex;
  flex-direction: column;
  gap: var(--espacio-2, 8px);
}

.field-label {
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto-muted, #78716c);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.field-input-wrap {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  background: #111;
  border: 1px solid #1e1e1e;
  border-radius: 12px;
  padding: var(--espacio-3, 12px) var(--espacio-4, 16px);
  transition: border-color 0.2s;
}

.field-input-wrap:focus-within {
  border-color: var(--tenant-primario, #3f99ff);
}

.field-icon {
  width: 16px;
  height: 16px;
  color: var(--tenant-texto-muted, #78716c);
  flex-shrink: 0;
}

.field-input {
  flex: 1;
  background: none;
  border: none;
  outline: none;
  color: var(--tenant-texto, #fff);
  font-size: var(--font-size-base, 15px);
  font-family: var(--tenant-fuente, sans-serif);
}

.field-input::placeholder {
  color: #333;
}

.toggle-pass {
  background: none;
  border: none;
  cursor: pointer;
  color: var(--tenant-texto-muted, #78716c);
  display: flex;
  align-items: center;
  padding: 0;
  transition: color 0.15s;
  flex-shrink: 0;
}

.toggle-pass:hover {
  color: var(--tenant-texto, #fff);
}

.toggle-pass svg {
  width: 16px;
  height: 16px;
}

/* ── ERROR ── */
.error-msg {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  background: rgba(220, 38, 38, 0.08);
  border: 1px solid rgba(220, 38, 38, 0.2);
  border-radius: 10px;
  padding: var(--espacio-2, 8px) var(--espacio-3, 12px);
  font-size: var(--font-size-sm, 13px);
  color: var(--color-error, #dc2626);
}

.error-msg svg {
  width: 15px;
  height: 15px;
  flex-shrink: 0;
}

/* ── BOTÓN ── */
.login-btn {
  width: 100%;
  padding: var(--espacio-3, 12px);
  background: var(--tenant-primario, #3f99ff);
  color: #fff;
  border: none;
  border-radius: 12px;
  font-size: var(--font-size-base, 15px);
  font-weight: var(--font-weight-bold, 600);
  font-family: var(--tenant-fuente, sans-serif);
  cursor: pointer;
  transition: background 0.15s, opacity 0.15s;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 46px;
}

.login-btn:hover:not(:disabled) {
  background: #2d87eb;
}

.login-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Spinner */
.spinner {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ── WATERMARK ── */
.login-watermark {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--espacio-2, 8px);
  font-size: var(--font-size-xs, 11px);
  color: var(--tenant-texto-muted, #78716c);
}

.login-watermark strong {
  color: var(--tenant-primario, #3f99ff);
  font-weight: var(--font-weight-bold, 600);
}

/* ── TRANSICIONES ── */
.error-fade-enter-active,
.error-fade-leave-active {
  transition: opacity 0.2s, transform 0.2s;
}

.error-fade-enter-from,
.error-fade-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}
</style>