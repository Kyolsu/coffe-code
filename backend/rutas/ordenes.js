const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');


router.post('/agregar', verificarToken, async (req, res) => {
    try {
        const { 
            numero_orden, 
            subtotal, 
            total, 
            id_cliente, 
            tipo_orden, 
            mesa_numero, 
            descuento, 
            impuestos, 
            notas 
        } = req.body;

        const id_usuario = req.usuario.id_usuario; 

        if (subtotal === undefined || total === undefined) {
            return res.status(400).json({
                status: "error",
                mensaje: "El subtotal y el total son obligatorios para generar la orden."
            });
        }
        const query = `
            SELECT fn_alta_orden($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) AS id_orden
        `;
        
        const values = [
            numero_orden,
            id_usuario,
            subtotal,
            total,
            id_cliente || null,
            tipo_orden || 'local',
            mesa_numero || null,
            descuento || 0,
            impuestos || 0,
            notas || null
        ];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Orden generada exitosamente",
            id_orden: result.rows[0].id_orden,
            numero_seguimiento: numero_orden
        });

    } catch (err) {
        console.error("Error al crear la orden:", err.message);

        if (err.message.includes('Los montos no pueden ser negativos')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la orden de venta"
        });
    }
});

router.delete('/cancelar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_orden($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'La orden no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }

        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            id_orden_cancelada: id,
            fecha_cancelacion: new Date()
        });

    } catch (err) {
        console.error("Error al cancelar la orden:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar procesar la cancelación"
        });
    }
});

router.put('/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            estado_orden, 
            estado_pago, 
            metodo_pago, 
            descuento, 
            impuestos, 
            total, 
            notas, 
            fecha_entrega 
        } = req.body;


        const query = `
            SELECT fn_actualizar_orden($1, $2, $3, $4, $5, $6, $7, $8, $9) AS resultado
        `;
        
        const values = [
            id,
            estado_orden || null,
            estado_pago || null,
            metodo_pago || null,
            descuento !== undefined ? descuento : null,
            impuestos !== undefined ? impuestos : null,
            total !== undefined ? total : null,
            notas || null,
            fecha_entrega || null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'La orden no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        if (mensaje === 'Total inválido') {
            return res.status(400).json({ status: "error", mensaje });
        }

        res.json({
            status: "ok",
            mensaje,
            datos_actualizados: req.body
        });

    } catch (err) {
        console.error("Error al actualizar la orden:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar la orden"
        });
    }
});

//////////////////////////////////////////////////////////
// VISTAS ORDENES
//////////////////////////////////////////////////////////


router.get('/mostrar', async (req, res) => {
    try {
        const query = 'Select * from v_ordenes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las ordenes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 


router.get('/cocina', async (req, res) => {
    try {
        const query = 'Select * from v_ordenes_cocina';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las ordenes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

router.get('/pendientes-pago',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_ordenes_pendientes_pago';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las ordenes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

router.get('/completas', async (req, res) => {
    try {
        const query = 'Select * from v_orden_completa';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las ordenes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 


//////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////

module.exports = router; 
