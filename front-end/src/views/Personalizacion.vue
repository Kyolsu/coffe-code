<script setup lang="ts">
import { ref } from 'vue'

const colorPrincipal = ref('#002D72')
const colorSecundario = ref('#5C2D6D')
const colorFondo = ref('#f9fafb')
const colorTexto = ref('#111827')
const logoUrl = ref('')

const guardarCambios = () => {
  alert('Guardado (simulación)')
}
</script>

<template>
  <div class="layout-principal">
    <main class="contenido-principal">
      <div class="construccion-wrapper">

        <h2 class="titulo">Personalización del sistema</h2>
        <p class="subtitulo">Customiza los colores y la apariencia de tu sistema</p>

        <div class="config-grid">

          <div class="config-card">
            <label class="config-label">Color principal</label>
            <div class="config-row">
              <input type="color" v-model="colorPrincipal" class="color-input" />
              <div class="preview-box" :style="{ background: colorPrincipal }"></div>
              <span class="color-value">{{ colorPrincipal }}</span>
            </div>
          </div>

          <div class="config-card">
            <label class="config-label">Color secundario</label>
            <div class="config-row">
              <input type="color" v-model="colorSecundario" class="color-input" />
              <div class="preview-box" :style="{ background: colorSecundario }"></div>
              <span class="color-value">{{ colorSecundario }}</span>
            </div>
          </div>

          <div class="config-card">
            <label class="config-label">Color de fondo</label>
            <div class="config-row">
              <input type="color" v-model="colorFondo" class="color-input" />
              <div class="preview-box" :style="{ background: colorFondo }"></div>
              <span class="color-value">{{ colorFondo }}</span>
            </div>
          </div>

          <div class="config-card">
            <label class="config-label">Color de texto</label>
            <div class="config-row">
              <input type="color" v-model="colorTexto" class="color-input" />
              <div class="preview-box" :style="{ background: colorTexto }"></div>
              <span class="color-value">{{ colorTexto }}</span>
            </div>
          </div>

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
  padding: 40px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

.construccion-wrapper {
  max-width: 600px;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.titulo {
  color: var(--tenant-primario);
  margin: 0;
  font-size: 2rem;
  font-weight: 600;
}

.subtitulo {
  color: var(--tenant-texto-muted);
  margin: 0;
  font-size: 1rem;
}

.config-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.config-card {
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 12px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.config-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--tenant-texto);
}

.config-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.color-input {
  width: 48px;
  height: 48px;
  border: 2px solid var(--color-borde);
  border-radius: 8px;
  cursor: pointer;
  padding: 2px;
}

.preview-box {
  width: 80px;
  height: 40px;
  border-radius: 8px;
  border: 1px solid var(--color-borde);
  flex-shrink: 0;
}

.color-value {
  font-family: monospace;
  font-size: 0.875rem;
  color: var(--tenant-texto-muted);
}

.logo-section {
  grid-column: 1 / -1;
}

.logo-input {
  width: 100%;
  padding: 12px;
  border: 1px solid var(--color-borde);
  border-radius: 8px;
  font-size: 0.875rem;
  background: var(--color-superficie-alt);
  color: var(--tenant-texto);
  outline: none;
}

.logo-input:focus {
  border-color: var(--tenant-primario);
}

.logo-preview {
  width: 100%;
  height: 120px;
  border: 2px dashed var(--color-borde);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-superficie-alt);
  overflow: hidden;
}

.logo-img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.logo-placeholder {
  color: var(--tenant-texto-muted);
  font-size: 0.875rem;
}

.btn-guardar {
  background: var(--tenant-primario);
  color: white;
  border: none;
  padding: 14px 28px;
  border-radius: 10px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  align-self: center;
  transition: opacity 0.2s;
}

.btn-guardar:hover {
  opacity: 0.9;
}
</style>