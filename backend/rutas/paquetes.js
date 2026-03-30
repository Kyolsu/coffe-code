const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

// POST: http://localhost:3000/api/usuarios/paquetes
router.post('/agregar', verificarToken, async (req, res) => {
    try {
        const { 
            nombre, 
            descripcion, 
            precio, 
            es_temporal, 
            fecha_inicio, 
            fecha_fin, 
            dias_disponibles, 
            url_imagen 
        } = req.body;
        if (!nombre || !precio) {
            return res.status(400).json({
                status: "error",
                mensaje: "El nombre y el precio del paquete son obligatorios."
            });
        }
        const query = `
            SELECT fn_alta_paquete($1, $2, $3, $4, $5, $6, $7, $8) AS id_paquete
        `;
        
        const values = [
            nombre,
            descripcion || null,
            precio,
            es_temporal !== undefined ? es_temporal : false, 
            fecha_inicio || null,
            fecha_fin || null,
            dias_disponibles || null,
            url_imagen || null
        ];

        const result = await db.query(query, values);
        const idGenerado = result.rows[0].id_paquete;

        res.status(201).json({
            status: "ok",
            mensaje: "Paquete creado exitosamente",
            id_paquete: idGenerado
        });

    } catch (err) {
        console.error("Error al crear paquete:", err.message);

        const erroresSQL = [
            'precio del paquete debe ser mayor a 0',
            'Debe indicar fecha_inicio y fecha_fin',
            'fecha_fin no puede ser menor'
        ];

        if (erroresSQL.some(msg => err.message.includes(msg))) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el alta del paquete"
        });
    }
});

router.delete('/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_paquete($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'El paquete no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'El paquete ya está inactivo') {
            return res.status(400).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }

        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            id_desactivado: id
        });

    } catch (err) {
        console.error("Error al dar de baja el paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar procesar la baja del paquete"
        });
    }
});

// Actualizar paquete  
router.put('/actualizar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            nombre, 
            descripcion, 
            precio, 
            es_temporal, 
            fecha_inicio, 
            fecha_fin, 
            dias_disponibles, 
            url_imagen, 
            activo 
        } = req.body;

        const query = `
            SELECT fn_actualizar_paquete($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) AS resultado
        `;
        
        const values = [
            id,
            nombre || null,
            descripcion || null,
            precio !== undefined ? precio : null,
            es_temporal !== undefined ? es_temporal : null,
            fecha_inicio || null,
            fecha_fin || null,
            dias_disponibles || null,
            url_imagen || null,
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'El paquete no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        if (mensaje === 'Precio inválido' || mensaje.includes('no puede ser menor')) {
            return res.status(400).json({ status: "error", mensaje });
        }

        res.json({
            status: "ok",
            mensaje,
            datos_editados: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar el paquete"
        });
    }
});


//MOSTRAR PAQUETE VISTA REDUCIDA 
router.get('/vista-comprimida', async (req, res) => {
    try {
        const query = 'select*from v_paquetes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay paquetes",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de paquetes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener paquetes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener paquetes" 
        });
    }
});

//MOSTRAR PAQUETE VISTA COMPLETA 

router.get('/vista-completa', async (req, res) => {
    try {
        const query = 'select*from paquetes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay paquetes",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de paquetes completos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener paquetes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener los paquetes" 
        });
    }
});
module.exports = router; 
