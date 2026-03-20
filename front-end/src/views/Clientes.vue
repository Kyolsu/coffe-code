<template>
  <div class="main-container">
    <nav class="sidebar">
      <div class="logo-area">
        <div class="logo-circle">LOGO</div>
      </div>
      <ul class="nav-links">
        <li class="active"><i class="icon-dashboard"></i> Beca Gestión</li>
        <li><i class="icon-group"></i> Estudiantes</li>
        <li><i class="icon-receipt"></i> Reportes</li>
        <li><i class="icon-settings"></i> Config.</li>
      </ul>
      <div class="exit-btn-wrapper">
        <button class="exit-btn"><i class="icon-exit"></i> Salir</button>
      </div>
    </nav>

    <main class="management-panel">
      <header class="panel-header">
        <div class="search-bar">
          <i class="icon-search"></i>
          <input 
            v-model="busqueda" 
            placeholder="🔍 Buscar por nombre o expediente..." 
            type="text" 
          />
        </div>
        <h1 class="page-title">Estudiantes</h1>
        <button @click="prepararNuevo" class="add-circle-btn">+</button>
      </header>

      <div class="student-grid">
        <div 
          v-for="estudiante in estudiantesFiltrados" 
          :key="estudiante.expediente"
          class="student-card"
          @click="prepararEdicion(estudiante)"
        >
          <div class="student-icon">🧑‍🎓</div>
          <h3 class="student-name">{{ estudiante.nombre }}</h3>
          <p class="student-exp">Exp: {{ estudiante.expediente }}</p>
        </div>
      </div>
    </main>

    <aside class="details-panel">
      <div class="ticket-header">
        <h2>DETALLES DE BECA</h2>
        <span class="ticket-num">#{{ nuevoEstudiante.expediente || '--' }}</span>
      </div>

      <div class="form-ticket">
        <div class="form-group">
          <label>NÚMERO DE EXPEDIENTE</label>
          <input 
            v-model="nuevoEstudiante.expediente" 
            placeholder="Introduce el expediente" 
            type="text" 
            :disabled="editando"
          />
        </div>
        <div class="form-group">
          <label>NOMBRE COMPLETO</label>
          <input 
            v-model="nuevoEstudiante.nombre" 
            placeholder="Introduce el nombre" 
            type="text" 
          />
        </div>
      </div>

      <div class="ticket-actions">
        <div class="action-grid">
          <button @click="confirmarLimpieza" class="btn-clear">
            <i class="icon-trash"></i> Borrar Todo
          </button>
          <button class="btn-info">
            <i class="icon-user"></i> Datos Alumno
          </button>
          <button @click="prepararNuevo" class="btn-save">
            <i class="icon-save"></i> Nuevo
          </button>
        </div>
        
        <div class="main-buttons">
          <button v-if="editando" @click="cancelarEdicion" class="btn-cancel">
            <i class="icon-close"></i> Cancelar Edición
          </button>
          <button @click="guardarEstudiante" class="btn-primary">
            <i class="icon-check"></i>
            {{ editando ? 'ACTUALIZAR DATOS' : 'REGISTRAR BECA' }}
          </button>
        </div>
      </div>
    </aside>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

// --- LÓGICA (Mantenemos la misma, es robusta) ---

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
    if (index !== -1) {
      estudiantes.value[index] = { ...nuevoEstudiante.value };
    }
    editando.value = false;
  } else {
    // Evitar expedientes duplicados
    const existe = estudiantes.value.some(e => e.expediente === nuevoEstudiante.value.expediente);
    if (existe) {
      alert('Este expediente ya está registrado.');
      return;
    }
    estudiantes.value.push({ ...nuevoEstudiante.value });
  }

  // Limpiar campos
  nuevoEstudiante.value = { expediente: '', nombre: '' };
};

const prepararNuevo = () => {
    editando.value = false;
    nuevoEstudiante.value = { expediente: '', nombre: '' };
}

const prepararEdicion = (estudiante) => {
  nuevoEstudiante.value = { ...estudiante };
  editando.value = true;
};

const cancelarEdicion = () => {
  nuevoEstudiante.value = { expediente: '', nombre: '' };
  editando.value = false;
};

const confirmarLimpieza = () => {
    if(confirm("¿Estás seguro de que quieres borrar todos los datos ingresados actualmente?")) {
        cancelarEdicion();
    }
}

// Buscador reactivo
const estudiantesFiltrados = computed(() => {
  if (!busqueda.value) return estudiantes.value;
  const search = busqueda.value.toLowerCase();
  return estudiantes.value.filter(e => 
    e.nombre.toLowerCase().includes(search) ||
    e.expediente.toLowerCase().includes(search)
  );
});
</script>

<style scoped>
/* --- ESTILOS CSS BASE --- */
:global(body) {
  margin: 0;
  padding: 0;
  background-color: #0c0d10; /* Color de fondo muy oscuro */
  color: #e0e0e0;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.main-container {
  display: grid;
  grid-template-columns: 240px 1fr 380px; /* Estructura de 3 columnas de la imagen */
  height: 100vh;
  overflow: hidden;
}

/* --- ESTILOS SIDEBAR --- */
.sidebar {
  background-color: #121316;
  border-right: 1px solid #1f2126;
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.logo-area {
  display: flex;
  justify-content: center;
  margin-bottom: 40px;
}

.logo-circle {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background-color: #1f2126;
  color: #555;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

.nav-links {
  list-style: none;
  padding: 0;
  margin: 0;
  flex-grow: 1;
}

.nav-links li {
  padding: 12px 15px;
  margin-bottom: 5px;
  border-radius: 8px;
  cursor: pointer;
  color: #888;
  display: flex;
  align-items: center;
  transition: all 0.2s;
}

.nav-links li.active {
  background-color: #1f2229;
  color: #38bdf8; /* Azul claro para active, como en la imagen */
}

.nav-links li:not(.active):hover {
  background-color: #1a1c21;
  color: white;
}

.exit-btn-wrapper {
  margin-top: auto;
}

.exit-btn {
  width: 100%;
  padding: 12px;
  background-color: #1f2126;
  border: 1px solid #e74c3c;
  color: #e74c3c;
  border-radius: 8px;
  cursor: pointer;
}

/* --- ESTILOS PANEL CENTRAL --- */
.management-panel {
  background-color: #0c0d10;
  padding: 20px 30px;
  overflow-y: auto;
}

.panel-header {
  display: grid;
  grid-template-columns: 1fr auto auto;
  align-items: center;
  gap: 20px;
  margin-bottom: 30px;
}

.page-title {
  margin: 0;
  font-size: 24px;
}

.search-bar {
  background-color: #121316;
  border: 1px solid #1f2126;
  border-radius: 20px;
  padding: 8px 15px;
  display: flex;
  align-items: center;
}

.search-bar input {
  background: none;
  border: none;
  color: white;
  width: 100%;
  margin-left: 10px;
  outline: none;
}

.add-circle-btn {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 1px solid #1f2126;
  background-color: transparent;
  color: #555;
  font-size: 24px;
  cursor: pointer;
  transition: all 0.2s;
}

.add-circle-btn:hover {
  background-color: #1a1c21;
  color: white;
}

.student-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.student-card {
  background-color: #121316;
  border: 1px solid #1f2126;
  border-radius: 12px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  transition: transform 0.2s, border-color 0.2s;
}

.student-card:hover {
  transform: translateY(-3px);
  border-color: #38bdf8;
}

.student-icon {
  font-size: 40px;
  margin-bottom: 15px;
}

.student-name {
  margin: 0;
  font-size: 16px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.student-exp {
  margin: 5px 0 0;
  color: #888;
  font-size: 14px;
}

/* --- ESTILOS PANEL DERECHO (TICKET) --- */
.details-panel {
  background-color: #121316;
  border-left: 1px solid #1f2126;
  display: flex;
  flex-direction: column;
}

.ticket-header {
  padding: 20px;
  border-bottom: 1px solid #1f2126;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.ticket-header h2 {
  margin: 0;
  font-size: 14px;
  color: #888;
  letter-spacing: 1px;
}

.ticket-num {
  color: #888;
  font-size: 14px;
}

.form-ticket {
  padding: 20px;
  flex-grow: 1;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 11px;
  color: #888;
  margin-bottom: 5px;
  letter-spacing: 1px;
}

.form-group input {
  width: 100%;
  padding: 10px;
  background-color: transparent;
  border: 1px solid #1f2126;
  border-radius: 6px;
  color: white;
  box-sizing: border-box;
}

.form-group input:disabled {
    color: #555;
    background-color: #1a1c21;
}

.ticket-actions {
  padding: 20px;
  border-top: 1px solid #1f2126;
  background-color: #0c0d10;
}

.action-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  margin-bottom: 15px;
}

.action-grid button {
  background-color: #121316;
  border: 1px solid #1f2126;
  color: #888;
  border-radius: 8px;
  padding: 10px;
  text-align: center;
  font-size: 12px;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}

.action-grid button:hover {
    color: white;
    background-color: #1a1c21;
}

.btn-clear:hover {
    color: #e74c3c !important;
}

.main-buttons {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.btn-primary, .btn-cancel {
  width: 100%;
  padding: 15px;
  border-radius: 8px;
  border: none;
  font-weight: bold;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.btn-primary {
  background-color: #38bdf8;
  color: #0c0d10;
}

.btn-cancel {
  background-color: #1a1c21;
  border: 1px solid #e74c3c;
  color: #e74c3c;
}

/* Iconos mock (Placeholder, se pueden cambiar por FontAwesome) */
[class^="icon-"]::before { content: "⊡ "; }
</style>
