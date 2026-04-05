const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');
//ALTA PROMOCION 
router.post('/agregar', verificarToken, async (req, res) => {
    try {
        const { 
            nombre, descripcion, tipo, valor, 
            es_temporal, fecha_inicio, fecha_fin, 
            hora_inicio, hora_fin, dias, 
            es_permanente, solo_clientes 
        } = req.body;

        const query = `
            SELECT fn_alta_promocion($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) AS id_promo
        `;
        
        const values = [
            nombre, descripcion, tipo, valor,
            es_temporal || false, 
            fecha_inicio || null, fecha_fin || null,
            hora_inicio || null, hora_fin || null,
            dias || null, 
            es_permanente || false,
            solo_clientes || false
        ];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Promoción creada exitosamente",
            id_promocion: result.rows[0].id_promo
        });

    } catch (err) {
        console.error("Error al crear promoción:", err.message);
        if (err.message.includes('negativo')) {
            return res.status(400).json({ status: "error", mensaje: err.message });
        }
        res.status(500).json({ status: "error", mensaje: "Error al procesar el alta" });
    }
});

//
//BAJA PROMOCIONES
router.delete('/eliminar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_promocion($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensaje = result.rows[0].resultado;

        if (mensaje === 'La promoción no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});
////
//MODIFICAR PROMOCION
////

router.put('/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        const query = `
            SELECT fn_actualizar_promocion($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) AS resultado
        `;
        
        const values = [
            id,
            data.nombre || null,
            data.descripcion || null,
            data.tipo || null,
            data.valor !== undefined ? data.valor : null,
            data.es_temporal !== undefined ? data.es_temporal : null,
            data.fecha_inicio || null,
            data.fecha_fin || null,
            data.hora_inicio || null,
            data.hora_fin || null,
            data.dias || null,
            data.es_permanente !== undefined ? data.es_permanente : null,
            data.solo_clientes !== undefined ? data.solo_clientes : null,
            data.activo !== undefined ? data.activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'La promoción no existe') return res.status(404).json({ status: "error", mensaje });
        if (mensaje === 'Valor inválido') return res.status(400).json({ status: "error", mensaje });

        res.json({ status: "ok", mensaje, datos: data });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});

////
//Mostrar promociones 
////
router.get('/mostrar', async (req, res) => {
    try {
        const query = 'Select * from v_promociones';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay promociones",
                datos: []
            });
        }
    
        res.json({
            status: "ok",
            mensaje: "Lista de productos promociones",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las promociones:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 


//////////////////////////////////////////////////////////////////
// PROMOCIONES PAQUETES
//////////////////////////////////////////////////////////////////


module.exports = router; 