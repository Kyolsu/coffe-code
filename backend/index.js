const express = require('express');
const http = require('http'); //  Amarrar WebSockets
const { Server } = require('socket.io'); // Servidor de Sockets
const cors = require('cors');

const db = require('./db');

const port = process.env.PORT || 3000;

// IMPORTACIÓN DE RUTAS
const usuariosRutas = require('./rutas/usuarios');
const clientesRutas = require('./rutas/clientes');
const ProductosRutas = require('./rutas/productos');
const menuRutas = require('./rutas/menu');
const tiendaRutas = require('./rutas/tienda_modulos');
const paquetesRutas = require('./rutas/paquetes');
const PromocionesRutas = require('./rutas/promociones');
const ordenesRutas = require('./rutas/ordenes');
const inventarioRutas = require('./rutas/inventario');
const IOTRutas = require('./rutas/iot');

const app = express();

// MIDDLEWARES (Limpios y sin repeticiones)
app.use(express.json());
app.options('*', (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', req.headers.origin || '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.sendStatus(200);
});
app.use(cors({
  origin: ['http://localhost:5173', 'http://localhost:5174', 'https://*.vercel.app', 'https://coffe-code-*.onrender.com'],
  methods: ["GET", "POST", "PUT", "DELETE"],
  credentials: true
}));

// CREACIÓN DEL SERVIDOR HTTP CON EXPRESS
const server = http.createServer(app);

//INICIALIZACIÓN DE SOCKET.IO
const io = new Server(server, {
  cors: {
    origin: ['http://localhost:5173', 'http://localhost:5174', 'https://*.vercel.app', 'https://coffe-code-*.onrender.com'],
    methods: ["GET", "POST"],
    credentials: true
  }
});

//COMPARTIR 'IO' GLOBALMENTE PARA QUE TUS ENPOINTS (COMO IOT) PUEDAN USARLO
app.set('socketio', io);

// Evento de escucha para cuando el Frontend abra la página
io.on('connection', (socket) => {
  console.log(`Cliente web conectado al socket: ${socket.id}`);
  
  socket.on('disconnect', () => {
    console.log('Cliente web desconectado de los sockets');
  });
});

// RUTAS DE ENDPOINTS
app.use('/api/usuarios', usuariosRutas);
app.use('/api/clientes', clientesRutas);
app.use('/api/productos', ProductosRutas);
app.use('/api/menu', menuRutas);
app.use('/api/tienda', tiendaRutas);
app.use('/api/paquetes', paquetesRutas);
app.use('/api/promociones', PromocionesRutas);
app.use('/api/ordenes', ordenesRutas);
app.use('/api/inventario', inventarioRutas);
app.use('/api/iot', IOTRutas);

// 
server.listen(port, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
  console.log(`Canales de WebSockets listos y escuchando.`);
});