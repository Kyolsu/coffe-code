const express = require('express');
const db = require('./db'); 
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;
const usuariosRutas=require('./rutas/usuarios')
const clientesRutas=require('./rutas/clientes')
const clientesProductos=require('./rutas/productos')
app.use(express.json());
app.use(cors({
  origin: 'http://localhost:5173',
}));
app.use(express.json());
//RUTAS DE ENDPOINTS
app.use('/api/usuarios', usuariosRutas);
app.use('/api/clientes',clientesRutas);
app.use('/api/productos',clientesProductos);
app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
