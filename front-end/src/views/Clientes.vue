<template>
  <div class="container">
    <h1>Clientes Becados</h1>

    <!-- BUSCADOR -->
    <input 
      v-model="busqueda" 
      placeholder="Buscar por nombre o expediente..." 
      class="buscador"
    />

    <!-- FORMULARIO -->
    <form @submit.prevent="guardarCliente">
      <input v-model="cliente.nombre" placeholder="Nombre" required />
      <input v-model="cliente.expediente" placeholder="Expediente" required />
      <button type="submit">
        {{ editando ? 'Actualizar' : 'Agregar' }}
      </button>
    </form>

    <!-- LISTA -->
    <table>
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Expediente</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(c, index) in clientesFiltrados" :key="index">
          <td>{{ c.nombre }}</td>
          <td>{{ c.expediente }}</td>
          <td>
            <button @click="editarCliente(index)">Editar</button>
            <button @click="eliminarCliente(index)">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      clientes: [],
      cliente: {
        nombre: '',
        expediente: ''
      },
      editando: false,
      indexEditando: null,
      busqueda: ''
    };
  },

  computed: {
    clientesFiltrados() {
      return this.clientes.filter(c =>
        c.nombre.toLowerCase().includes(this.busqueda.toLowerCase()) ||
        c.expediente.toLowerCase().includes(this.busqueda.toLowerCase())
      );
    }
  },

  methods: {
    guardarCliente() {
      if (this.editando) {
        this.clientes[this.indexEditando] = { ...this.cliente };
        this.editando = false;
      } else {
        this.clientes.push({ ...this.cliente });
      }
      this.limpiarFormulario();
    },

    editarCliente(index) {
      this.cliente = { ...this.clientes[index] };
      this.editando = true;
      this.indexEditando = index;
    },

    eliminarCliente(index) {
      if (confirm('¿Seguro que quieres eliminar este cliente?')) {
        this.clientes.splice(index, 1);
      }
    },

    limpiarFormulario() {
      this.cliente = { nombre: '', expediente: '' };
      this.editando = false;
      this.indexEditando = null;
    }
  },

  mounted() {
    const data = localStorage.getItem('clientes');
    if (data) this.clientes = JSON.parse(data);
  },

  watch: {
    clientes: {
      handler(val) {
        localStorage.setItem('clientes', JSON.stringify(val));
      },
      deep: true
    }
  }
};
</script>

<style>
.container {
  padding: 20px;
}

.buscador {
  margin-bottom: 15px;
  padding: 8px;
  width: 100%;
}

table {
  margin-top: 20px;
  width: 100%;
}

button {
  margin-right: 5px;
}
</style>
