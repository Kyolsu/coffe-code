<script setup lang="ts">
import { RouterView } from 'vue-router'
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
