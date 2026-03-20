const express = require('express');
const db = require('./db'); 
const app = express();
const port = process.env.PORT || 3000;
const usuariosRutas=require('./rutas/usuarios')
const clientesRutas=require('./rutas/clientes')
app.use(express.json());
//RUTAS DE ENDPOINTS
app.use('/api/usuarios', usuariosRutas);
app.use('/api/clientes',clientesRutas);

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});