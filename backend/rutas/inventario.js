const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

//////////////////////////////
///RUTAS INVENTARIO
//////////////////////////////

//ALTA

// POST: http://localhost:3000/api/
router.post('/agregar', verificarToken, async (req, res) => {
    try {
        const { id_ingrediente, cantidad_actual, cantidad_minima, unidad } = req.body;

        if (!id_ingrediente) {
            return res.status(400).json({ status: "error", mensaje: "El id_ingrediente es obligatorio." });
        }

        const query = 'SELECT fn_alta_inventario($1, $2, $3, $4) AS resultado';
        const result = await db.query(query, [id_ingrediente, cantidad_actual || 0, cantidad_minima || 0, unidad || null]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Ingrediente no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.status(201).json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});

//MODIFICAR

// PUT: http://localhost:3000/api/usuarios/inventario/:id
router.put('/actualizar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params; // p_id_inventario
        const { cantidad_actual, cantidad_minima, unidad, activo } = req.body;

        const query = 'SELECT fn_actualizar_inventario($1, $2, $3, $4, $5) AS resultado';
        const values = [
            id,
            cantidad_actual !== undefined ? cantidad_actual : null,
            cantidad_minima !== undefined ? cantidad_minima : null,
            unidad || null,
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Inventario no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});


//Desactivar

router.delete('/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_inventario($1) AS resultado';
        const result = await db.query(query, [id]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Registro no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});

//MOSTRAR

//get 
router.get('/mostrar', verificarToken, async (req, res) => {
    try {
        const result = await db.query('SELECT * FROM V_inventario');
        res.json({
            status: "ok, mostrando inventario",
            datos: result.rows
        });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error al obtener el inventario" });
    }
});



//////////////////////////
////MOVIMIENTOS INVENTARIO 
///////////////////////////

//MOSTRAR 
//get 
router.get('/mostrar-movimientos', verificarToken, async (req, res) => {
    try {
        const result = await db.query('SELECT * FROM v_inventario_movimientos');
        res.json({
            status: "ok, mostrando movimientos del inventario",
            datos: result.rows
        });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error al obtener el inventario" });
    }
});

//Alta 
router.post('/movimientos', verificarToken, async (req, res) => {
    try {
        const { id_inventario, tipo_movimiento, cantidad, motivo } = req.body;

        const id_usuario = req.usuario.id_usuario;

        if (!id_inventario || !tipo_movimiento || !cantidad) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_inventario, tipo_movimiento y cantidad son requeridos."
            });
        }

        const query = 'SELECT fn_alta_movimiento($1, $2, $3, $4, $5) AS resultado';
        const values = [id_inventario, tipo_movimiento, cantidad, motivo || null, id_usuario];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Inventario no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }
        
        if (mensaje === 'Cantidad inválida') {
            return res.status(400).json({ status: "error", mensaje });
        }

        res.status(201).json({
            status: "ok",
            mensaje,
            detalle: {
                id_inventario,
                tipo: tipo_movimiento,
                cantidad_afectada: cantidad
            }
        });

    } catch (err) {
        console.error("Error en movimiento de inventario:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el movimiento de almacén."
        });
    }
});








module.exports = router; 