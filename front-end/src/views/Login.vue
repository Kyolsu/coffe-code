<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

// Inicializamos el enrutador para poder cambiar de página
const router = useRouter()

// Variables reactivas para guardar lo que el usuario escribe
const username = ref('')
const password = ref('')
const errorMessage = ref('')

const handleLogin = () => {
  // Simulación de validación (Mocks temporales para el prototipo)
  if (username.value === 'admin' && password.value === '1234') {
    // 1. Limpiamos cualquier error previo
    errorMessage.value = ''
    
    // 2. Guardamos el token en localStorage para que el router nos deje pasar
    localStorage.setItem('coffe_token', 'token_demo_seguro')
    
    // 3. Redirigimos al Dashboard
    router.push({ name: 'dashboard' })
  } else {
    // Mostramos error si los datos no coinciden
    errorMessage.value = 'Usuario o contraseña incorrectos.'
  }
}
</script>

<template>
  <div class="login-container">
    <div class="login-card">
      <h1 class="brand-title">CoffeCode</h1>
      <p class="subtitle">Ingresa a tu punto de venta</p>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="input-group">
          <label for="username">Usuario</label>
          <input 
            id="username" 
            v-model="username" 
            type="text" 
            placeholder="Ej. admin"
            required 
          />
        </div>

        <div class="input-group">
          <label for="password">Contraseña</label>
          <input 
            id="password" 
            v-model="password" 
            type="password" 
            placeholder="••••••••"
            required 
          />
        </div>

        <span v-if="errorMessage" class="error-msg">{{ errorMessage }}</span>

        <button type="submit" class="btn-primary">Iniciar Sesión</button>
        
        <div class="rfid-section">
          <p>¿Tienes tarjeta de acceso?</p>
          <p class="rfid-instruction">Acércala al lector RFID para entrar</p>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
/* El 'scoped' significa que este CSS SOLO afectará a este archivo Login.vue 
  y no va a romper los estilos del resto de tus pantallas.
*/

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: var(--tenant-fondo, #000000);
  font-family: var(--tenant-fuente, sans-serif);
}

.login-card {
  background-color: #1a1a1a; /* Un tono un poco más claro que el fondo negro */
  padding: 3rem 2rem;
  border-radius: 12px;
  width: 100%;
  max-width: 400px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
  text-align: center;
}

.brand-title {
  color: var(--tenant-primario, #3f99ff);
  margin-bottom: 0.5rem;
  font-size: var(--font-size-3xl, 38px);
}

.subtitle {
  color: var(--tenant-texto-muted, #78716c);
  margin-bottom: 2rem;
  font-size: var(--font-size-base, 15px);
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.input-group {
  display: flex;
  flex-direction: column;
  text-align: left;
  gap: 0.5rem;
}

label {
  color: var(--tenant-texto, #ffffff);
  font-size: var(--font-size-sm, 13px);
}

input {
  padding: 0.75rem;
  border-radius: 6px;
  border: 1px solid #333;
  background-color: #222;
  color: var(--tenant-texto, #ffffff);
  font-family: inherit;
  font-size: var(--font-size-base, 15px);
}

input:focus {
  outline: none;
  border-color: var(--tenant-primario, #3f99ff);
  background-color: #2a2a2a;
}

.btn-primary {
  background-color: var(--tenant-primario, #3f99ff);
  color: #ffffff;
  padding: 0.8rem;
  border: none;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
  font-size: var(--font-size-md, 17px);
  transition: opacity 0.2s;
  margin-top: 0.5rem;
}

.btn-primary:hover {
  opacity: 0.85;
}

.error-msg {
  color: var(--color-error, #dc2626);
  font-size: var(--font-size-sm, 13px);
}

.rfid-section {
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid #333;
  color: var(--tenant-texto-muted, #78716c);
  font-size: var(--font-size-sm, 13px);
}

.rfid-instruction {
  color: var(--tenant-primario, #3f99ff);
  font-weight: bold;
  margin-top: 0.25rem;
}
</style>