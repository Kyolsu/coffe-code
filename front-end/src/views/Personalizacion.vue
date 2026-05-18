<script setup lang="ts">
</script>

<template>
  <div class="layout-principal">
    <main class="contenido-principal">
      <div class="construccion-wrapper">
        <div class="mensaje-caja">
          <span class="icono-construccion">🚧</span>
          <h2>Sección en Construcción</h2>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
/* Estructura Principal */
.layout-principal {
  display: flex;
  min-height: 100vh;
  background-color: var(--tenant-fondo);
  color: var(--tenant-texto);
}

/* Centrado del contenido para la pantalla de construcción */
.contenido-principal {
  flex: 1;
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.construccion-wrapper {
  max-width: 500px;
  width: 100%;
  text-align: center;
}

/* Caja de mensaje usando tus variables */
.mensaje-caja {
  background: color-mix(in srgb, var(--tenant-navbar) 80%, transparent);
  border: 1px solid color-mix(in srgb, var(--tenant-primario) 30%, transparent);
  padding: 40px 30px;
  border-radius: 16px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
}

.icono-construccion {
  font-size: 4rem;
  display: block;
  margin-bottom: 20px;
  animation: flotar 3s ease-in-out infinite;
}

h2 {
  color: var(--tenant-primario);
  margin-bottom: 12px;
  font-size: 1.8rem;
}

p {
  color: var(--tenant-texto);
  font-size: 1.1rem;
  line-height: 1.5;
}

.nota {
  font-size: 0.9rem;
  color: color-mix(in srgb, var(--tenant-texto) 60%, transparent);
  margin-top: 24px;
  font-style: italic;
}

/* Animación sutil para el icono */
@keyframes flotar {
  0% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
  100% { transform: translateY(0); }
}
</style>