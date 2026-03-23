const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

//ALTA DE PRODUCTO
// POST: http://localhost:3000/api/productos/alta
router.post('/alta', verificarToken, async (req, res) => {
    try {

        const { nombre, descripcion, precio, id_zona, id_categoria, url_imagen } = req.body;
        if (!nombre || !precio || !id_zona || !id_categoria) {
            return res.status(400).json({
                status: "error",
                mensaje: "Faltan campos obligatorios (nombre, precio, zona o categoría)"
            });
        }

        const query = 'SELECT fn_alta_producto($1, $2, $3, $4, $5, $6) AS nuevo_id';
        const values = [nombre, descripcion, precio, id_zona, id_categoria, url_imagen || null];

        const result = await db.query(query, values);

        const idGenerado = result.rows[0].nuevo_id;

        res.status(201).json({
            status: "ok",
            mensaje: "Producto registrado exitosamente",
            datos: {
                id_producto: idGenerado,
                nombre: nombre
            }
        });

    } catch (err) {
        console.error("Error al ejecutar fn_alta_producto:", err.message);
        if (err.code === '23503') {
            return res.status(400).json({
                status: "error",
                mensaje: "El ID de zona o categoría no existe en la base de datos"
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno del servidor al dar de alta el producto"
        });
    }
});

module.exports = router; 












