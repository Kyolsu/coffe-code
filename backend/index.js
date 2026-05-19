const express = require('express');
const db = require('./db'); 
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;
const usuariosRutas=require('./rutas/usuarios')
const clientesRutas=require('./rutas/clientes')
const ProductosRutas=require('./rutas/productos')
const menuRutas=require('./rutas/menu')
const tiendaRutas=require('./rutas/tienda_modulos')
const paquetesRutas=require('./rutas/paquetes')
const PromocionesRutas=require('./rutas/promociones')
const ordenesRutas=require('./rutas/ordenes')
const inventarioRutas=require('./rutas/inventario')
const IOTRutas=require('./rutas/iot')
app.use(express.json());
app.use(cors({
  origin: ['http://localhost:5173', 'https://coffe-code-psi.vercel.app']
}));
//RUTAS DE ENDPOINTS
app.use('/api/usuarios', usuariosRutas);
app.use('/api/clientes',clientesRutas);
app.use('/api/productos',ProductosRutas);
app.use('/api/menu',menuRutas);
app.use('/api/tienda',tiendaRutas);
app.use('/api/paquetes',paquetesRutas);
app.use('/api/promociones',PromocionesRutas);
app.use('/api/ordenes',ordenesRutas);
app.use('/api/inventario',inventarioRutas);
app.use('/api/iot',IOTRutas);
app.listen(port, '0.0.0.0' ,() => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
}); 
