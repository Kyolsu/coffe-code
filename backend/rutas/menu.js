const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

// ALTA MENUS
router.post('/agregar', verificarToken, async (req, res) => {
    try {

        const { 
            nombre, 
            descripcion, 
            hora_inicio, 
            hora_fin, 
            dias_semana, 
            fecha_inicio, 
            fecha_fin 
        } = req.body;

        if (!nombre || !hora_inicio || !hora_fin || !dias_semana) {
            return res.status(400).json({
                status: "error",
                mensaje: "Nombre, horas y días de la semana son obligatorios."
            });
        }

        const query = `
            SELECT fn_alta_menu($1, $2, $3, $4, $5, $6, $7) AS id_generado
        `;
        const values = [
            nombre, 
            descripcion, 
            hora_inicio, 
            hora_fin, 
            dias_semana, 
            fecha_inicio || null, 
            fecha_fin || null
        ];

        const result = await db.query(query, values);

        res.status(201).json({
            status: "ok",
            mensaje: "Menú creado exitosamente",
            id_menu: result.rows[0].id_generado
        });

    } catch (err) {
        console.error("Error al crear menú:", err.message);
        if (err.message.includes('hora_fin') || err.message.includes('fecha_fin')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message 
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el alta del menú"
        });
    }
});
//desactivar menu
router.delete('/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_menu($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'El menú no existe') {
            return res.status(404).json({
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
        console.error("Error en DELETE /menu:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar dar de baja el menú"
        });
    }
});

// Modificar menu

router.put('/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const { 
            nombre, 
            descripcion, 
            hora_inicio, 
            hora_fin, 
            dias_semana, 
            fecha_inicio, 
            fecha_fin, 
            activo 
        } = req.body;

        const query = `
            SELECT fn_actualizar_menu($1, $2, $3, $4, $5, $6, $7, $8, $9) AS resultado
        `;
        const values = [
            id,
            nombre || null,
            descripcion || null,
            hora_inicio || null,
            hora_fin || null,
            dias_semana || null,
            fecha_inicio || null,
            fecha_fin || null,
            activo !== undefined ? activo : null 
        ];

        const result = await db.query(query, values);
        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'El menú no existe') {
            return res.status(404).json({ status: "error", mensaje: mensajeRecibido });
        }

        if (mensajeRecibido.includes('debe ser mayor') || mensajeRecibido.includes('no puede ser menor')) {
            return res.status(400).json({ status: "error", mensaje: mensajeRecibido });
        }

        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            datos_actualizados: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar menú:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar el menú"
        });
    }
});

//Mostrar menu activo 
router.get('/mostrar-activo', async (req, res) => {
    try {
        const query = 'Select * from v_menu_activo';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay menus activos",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de menus activos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener menus activos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener menus" 
        });
    }
});

router.get('/mostrar-inactivo', async (req, res) => {
    try {
        const query = 'select*from menus where activo is false';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay menus inactivos",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de menus inactivos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener menus inactivos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener menus" 
        });
    }
});

module.exports = router; 
