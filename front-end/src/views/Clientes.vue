<template>
  <div id="app" class="container">
    <h1>Gestión de Estudiantes con Beca</h1>

    <div class="card">
      <h3>{{ editando ? 'Modificar Estudiante' : 'Agregar Nuevo Estudiante' }}</h3>
      <input v-model="nuevoEstudiante.expediente" placeholder="Número de Expediente" type="text" />
      <input v-model="nuevoEstudiante.nombre" placeholder="Nombre Completo" type="text" />
      
      <button @click="guardarEstudiante" :class="{ 'btn-edit': editando }">
        {{ editando ? 'Actualizar Datos' : 'Registrar Estudiante' }}
      </button>
      <button v-if="editando" @click="cancelarEdicion" class="btn-cancel">Cancelar</button>
    </div>

    <hr />

    <div class="search-bar">
      <input v-model="busqueda" placeholder="🔍 Buscar por nombre o expediente..." type="text" />
    </div>

    <table>
      <thead>
        <tr>
          <th>Expediente</th>
          <th>Nombre</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="estudiante in estudiantesFiltrados" :key="estudiante.expediente">
          <td>{{ estudiante.expediente }}</td>
          <td>{{ estudiante.nombre }}</td>
          <td>
            <button @click="prepararEdicion(estudiante)" class="btn-action">Modificar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

// Estado de la aplicación
const estudiantes = ref([]);
const busqueda = ref('');
const editando = ref(false);

const nuevoEstudiante = ref({
  expediente: '',
  nombre: ''
});

// Lógica para guardar o actualizar
const guardarEstudiante = () => {
  if (!nuevoEstudiante.value.expediente || !nuevoEstudiante.value.nombre) return;

  if (editando.value) {
    const index = estudiantes.value.findIndex(e => e.expediente === nuevoEstudiante.value.expediente);
    estudiantes.value[index] = { ...nuevoEstudiante.value };
    editando.value = false;
  } else {
    estudiantes.value.push({ ...nuevoEstudiante.value });
  }

  // Limpiar campos
  nuevoEstudiante.value = { expediente: '', nombre: '' };
};

const prepararEdicion = (estudiante) => {
  nuevoEstudiante.value = { ...estudiante };
  editando.value = true;
};

const cancelarEdicion = () => {
  nuevoEstudiante.value = { expediente: '', nombre: '' };
  editando.value = false;
};

// Buscador reactivo
const estudiantesFiltrados = computed(() => {
  return estudiantes.value.filter(e => 
    e.nombre.toLowerCase().includes(busqueda.value.toLowerCase()) ||
    e.expediente.includes(busqueda.value)
  );
});
</script>

<style scoped>
.container { max-width: 600px; margin: auto; font-family: sans-serif; }
.card { background: #f4f4f4; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
input { display: block; width: 100%; margin-bottom: 10px; padding: 8px; box-sizing: border-box; }
button { width: 100%; padding: 10px; background: #42b983; color: white; border: none; cursor: pointer; }
.btn-edit { background: #35495e; }
.btn-cancel { background: #e74c3c; margin-top: 5px; }
.btn-action { background: #3498db; width: auto; padding: 5px 10px; }
table { width: 100%; border-collapse: collapse; }
th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
.search-bar { margin-bottom: 15px; }
</style>
