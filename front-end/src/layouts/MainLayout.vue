<script setup lang="ts">
import Sidebar from '../components/Sidebar.vue' // Ajusta la ruta a donde tengas tu Sidebar
import { RouterView } from 'vue-router'
</script>

<template>
  <div class="layout-wrapper">
    <Sidebar />
    <main class="layout-main">
      <RouterView /> </main>
  </div>
</template>

<style scoped>
.layout-wrapper {
  display: flex;
  height: 100vh;
  width: 100vw;
  overflow: hidden;
  background-color: var(--tenant-fondo, #f9fafb);
}

.layout-main {
  flex: 1;
  overflow-y: auto;
  position: relative;
}
</style>