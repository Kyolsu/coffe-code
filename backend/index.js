const express = require('express');
const db = require('./db'); // Aquí mandamos llamar al archivo de arriba
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Endpoint de prueba para ver si la base de datos responde

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});