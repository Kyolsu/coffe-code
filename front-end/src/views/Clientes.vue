<script setup lang="ts">
import { ref, computed } from 'vue'
import Sidebar from '../components/Sidebar.vue' // Mantenemos tu componente

// ── INTERFAZ DE DATOS ─────────────────────────────────
interface AlumnoBecado {
  id: number
  expediente: string
  nombre: string
}

// ── ESTADO ─────────────────────────────────────────────
const alumnos = ref<AlumnoBecado[]>([
  { id: 1, expediente: '2024001', nombre: 'Carlos Ruiz' } // Datos de ejemplo
])

const searchQuery = ref('')
const editandoId = ref<number | null>(null)

// Formulario reactivo
const form = ref({
  expediente: '',
  nombre: ''
})

// ── LÓGICA DE NEGOCIO ──────────────────────────────────

// Buscador: Filtra por nombre o expediente
const alumnosFiltrados = computed(() => {
  const q = searchQuery.value.toLowerCase()
  return alumnos.value.filter(a => 
    a.nombre.toLowerCase().includes(q) || 
    a.expediente.toLowerCase().includes(q)
  )
})

const guardarAlumno = () => {
  if (!form.value.expediente || !form.value.nombre) return

  if (editandoId.value !== null) {
    // Modo Edición
    const index = alumnos.value.findIndex(a => a.id === editandoId.value)
    if (index !== -1) {
      alumnos.value[index] = { ...form.value, id: editandoId.value }
    }
    editandoId.value = null
  } else {
    // Modo Nuevo
    alumnos.value.push({
      ...form.value,
      id: Date.now()
    })
  }
  
  // Limpiar formulario
  form.value = { expediente: '', nombre: '' }
}

const seleccionarParaEditar = (alumno: AlumnoBecado) => {
  editandoId.value = alumno.id
  form.value = { expediente: alumno.expediente, nombre: alumno.nombre }
}

const cancelarEdicion = () => {
  editandoId.value = null
  form.value = { expediente: '', nombre: '' }
}
</script>

<template>
  <div class="venta-layout">
    <Sidebar />

    <div class="venta-main">
      
      <section class="panel panel--cart">
        <div class="panel-header">
          <span class="panel-title">{{ editandoId ? 'Editando Alumno' : 'Nuevo Registro' }}</span>
        </div>

        <div class="cart-items" style="padding: 20px; display: flex; flex-direction: column; gap: 15px;">
          <div class="input-group">
            <label>NÚMERO DE EXPEDIENTE</label>
            <input v-model="form.expediente" type="text" placeholder="Ej: 2024-001" class="pos-input" />
          </div>

          <div class="input-group">
            <label>NOMBRE COMPLETO</label>
            <input v-model="form.nombre" type="text" placeholder="Nombre del alumno" class="pos-input" />
          </div>
        </div>

        <div class="cart-actions">
          <button @click="guardarAlumno" class="btn btn--payment" style="width: 100%; border-radius: 10px;">
            <div class="payment-label">
              <span class="payment-main">{{ editandoId ? 'GUARDAR CAMBIOS' : 'AGREGAR ALUMNO' }}</span>
            </div>
          </button>
          
          <button v-if="editandoId" @click="cancelarEdicion" class="btn btn--cancel" style="margin-top: 10px; width: 100%;">
            Cancelar
          </button>
        </div>
      </section>

      <section class="panel panel--products">
        <div class="products-top">
          <div class="search-bar">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="1.5"/><path d="M21 21l-4.35-4.35" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            <input v-model="searchQuery" type="text" placeholder="Buscar por nombre o expediente..." class="search-input" />
          </div>
          <h2 class="venta-title">Alumnos Becados</h2>
        </div>

        <div class="product-grid">
          <div 
            v-for="alumno in alumnosFiltrados" 
            :key="alumno.id" 
            class="product-card"
            @click="seleccionarParaEditar(alumno)"
            :class="{ 'is-editing': editandoId === alumno.id }"
          >
            <span class="product-emoji">🎓</span>
            <span class="product-name">{{ alumno.nombre }}</span>
            <span class="product-price">Exp: {{ alumno.expediente }}</span>
            <div class="edit-badge">Click para editar</div>
          </div>
        </div>
      </section>

    </div>
  </div>
</template>

<style scoped>
/* Reutilizamos tus variables y estilos de layout */
.input-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.input-group label {
  font-size: 11px;
  color: #78716c;
  font-weight: bold;
}

.pos-input {
  background: #111;
  border: 1px solid #1c1c1c;
  padding: 12px;
  border-radius: 8px;
  color: white;
  outline: none;
}

.pos-input:focus {
  border-color: var(--tenant-primario, #3f99ff);
}

.is-editing {
  border-color: var(--tenant-primario, #3f99ff) !important;
  background: rgba(63, 153, 255, 0.05) !important;
}

.edit-badge {
  font-size: 9px;
  color: #3f99ff;
  margin-top: 5px;
  text-transform: uppercase;
  letter-spacing: 1px;
}
</style>