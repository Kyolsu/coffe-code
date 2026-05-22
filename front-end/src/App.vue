<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import { useTenantStore } from './stores/tenant'

onMounted(() => {
  const token = localStorage.getItem('coffe_token')
  if (token) {
    useTenantStore().cargarConfig()
  }
})
</script>

<template>
  <RouterView />
</template>

<style>
/* Estilos globales básicos */
body {
  margin: 0;
  font-family: var(--tenant-fuente, sans-serif);
  background-color: var(--tenant-fondo, #1e1e1e);
  color: var(--tenant-texto, #ffffff);
}
</style>
