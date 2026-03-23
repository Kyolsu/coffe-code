<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import Sidebar from '../components/Sidebar.vue'

// ── TIPOS ─────────────────────────────
type Rol = 'admin' | 'gerente' | 'cajero' | 'cocinero'

interface Usuario {
  id: number
  nombre: string
  usuario: string
  rol: Rol
}

// ── ESTADO ────────────────────────────
const usuarios = ref<Usuario[]>([])
const busqueda = ref('')

const nuevoUsuario = ref<Usuario>({
  id: 0,
  nombre: '',
  usuario: '',
  rol: 'cajero'
})

const editando = ref(false)

// ── FILTRO ────────────────────────────
const usuariosFiltrados = computed(() =>
  usuarios.value.filter(u =>
    u.nombre.toLowerCase().includes(busqueda.value.toLowerCase()) ||
    u.usuario.toLowerCase().includes(busqueda.value.toLowerCase()) ||
    u.rol.toLowerCase().includes(busqueda.value.toLowerCase())
  )
)

// ── ACCIONES ──────────────────────────
const guardarUsuario = () => {
  if (editando.value) {
    const index = usuarios.value.findIndex(u => u.id === nuevoUsuario.value.id)
    if (index !== -1) {
      usuarios.value[index] = { ...nuevoUsuario.value }
    }
    editando.value = false
  } else {
    usuarios.value.push({
      ...nuevoUsuario.value,
      id: Date.now()
    })
  }

  limpiarFormulario()
}

const editarUsuario = (usuario: Usuario) => {
  nuevoUsuario.value = { ...usuario }
  editando.value = true
}

const eliminarUsuario = (id: number) => {
  if (confirm('¿Eliminar usuario?')) {
    usuarios.value = usuarios.value.filter(u => u.id !== id)
  }
}

const limpiarFormulario = () => {
  nuevoUsuario.value = { id: 0, nombre: '', usuario: '', rol: 'cajero' }
  editando.value = false
}

// ── PERSISTENCIA ──────────────────────
const STORAGE_KEY = 'usuarios'

const cargar = () => {
  const data = localStorage.getItem(STORAGE_KEY)
  if (data) usuarios.value = JSON.parse(data)
}

const guardar = () => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(usuarios.value))
}

cargar()

watch(usuarios, guardar, { deep: true })
</script>

<template>
  <div class="usuarios-layout">
    <Sidebar />

    <main class="usuarios-main">

      <!-- HEADER -->
      <header class="usuarios-header">
        <h1 class="page-title">Usuarios</h1>
      </header>

      <!-- BUSCADOR -->
      <input
        v-model="busqueda"
        class="search-input"
        placeholder="Buscar usuario..."
      />

      <!-- FORMULARIO -->
      <div class="form-card">
        <input v-model="nuevoUsuario.nombre" placeholder="Nombre completo" />
        <input v-model="nuevoUsuario.usuario" placeholder="Usuario (login)" />

        <select v-model="nuevoUsuario.rol">
          <option value="admin">Administrador</option>
          <option value="gerente">Gerente</option>
          <option value="cajero">Cajero</option>
          <option value="cocinero">Cocinero</option>
        </select>

        <button @click="guardarUsuario">
          {{ editando ? 'Actualizar' : 'Agregar' }}
        </button>
      </div>

      <!-- LISTA -->
      <div class="usuarios-grid">
        <div
          v-for="usuario in usuariosFiltrados"
          :key="usuario.id"
          class="usuario-card"
        >
          <div class="usuario-info">
            <strong>{{ usuario.nombre }}</strong>
            <span>@{{ usuario.usuario }}</span>
            <span class="rol">{{ usuario.rol }}</span>
          </div>

          <div class="usuario-actions">
            <button @click="editarUsuario(usuario)">✏️</button>
            <button @click="eliminarUsuario(usuario.id)">🗑️</button>
          </div>
        </div>

        <!-- VACÍO -->
        <div v-if="usuariosFiltrados.length === 0" class="empty">
          Sin usuarios registrados
        </div>
      </div>

    </main>
  </div>
</template>

<style scoped>
/* ── LAYOUT ── */
.usuarios-layout {
  display: flex;
  min-height: 100vh;
  background: var(--tenant-fondo, #000);
}

.usuarios-main {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* HEADER */
.page-title {
  color: #fff;
  font-size: 28px;
}

/* BUSCADOR */
.search-input {
  padding: 10px;
  border-radius: 8px;
  border: 1px solid #222;
  background: #111;
  color: #fff;
}

/* FORM */
.form-card {
  display: flex;
  gap: 10px;
}

.form-card input,
.form-card select {
  padding: 10px;
  background: #111;
  border: 1px solid #222;
  color: #fff;
  border-radius: 8px;
}

.form-card button {
  background: var(--tenant-primario, #3f99ff);
  color: white;
  border: none;
  padding: 10px 16px;
  border-radius: 8px;
  cursor: pointer;
}

/* GRID */
.usuarios-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

/* CARD */
.usuario-card {
  background: #0e0e0e;
  border: 1px solid #1c1c1c;
  padding: 16px;
  border-radius: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.usuario-info strong {
  color: #fff;
  display: block;
}

.usuario-info span {
  color: #888;
  font-size: 13px;
  display: block;
}

.rol {
  margin-top: 4px;
  font-size: 12px;
  color: var(--tenant-primario, #3f99ff);
}

.usuario-actions button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 16px;
}

/* EMPTY */
.empty {
  color: #666;
  grid-column: 1 / -1;
  text-align: center;
}
</style>
