const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');
//Alta zonas 
router.post('/zonas/agregar', verificarToken, async (req, res) => {
    try {
        const { nombre, descripcion } = req.body;
        if (!nombre) {
            return res.status(400).json({
                status: "error",
                mensaje: "El nombre de la zona es obligatorio"
            });
        }
        const query = 'SELECT fn_alta_zona($1, $2) AS id_zona';
        const values = [nombre, descripcion || null];

        const result = await db.query(query, values);
        const idGenerado = result.rows[0].id_zona;

        res.status(201).json({
            status: "ok",
            mensaje: "Zona registrada exitosamente",
            datos: {
                id_zona: idGenerado,
                nombre_zona: nombre
            }
        });

    } catch (err) {
        console.error("Error al registrar zona:", err.message);
        if (err.message.includes('no puede estar vacío') || err.message.includes('ya existe')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el registro de la zona"
        });
    }
});


//desactivar zonas

// DELETE: http://localhost:3000/api/usuarios/zonas/3
router.delete('/zonas/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_zona($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'La zona no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'La zona ya está inactiva') {
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
        console.error("Error al desactivar zona:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la baja de la zona"
        });
    }
});

//Modificar zonas
router.put('/zonas/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, descripcion, activo } = req.body;
        const query = 'SELECT fn_actualizar_zona($1, $2, $3, $4) AS resultado';
        
        const values = [
            id,
            nombre || null,
            descripcion || null,
            activo !== undefined ? activo : null 
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'La zona no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        if (mensaje === 'Nombre inválido' || mensaje === 'Ya existe otra zona con ese nombre') {
            return res.status(400).json({ status: "error", mensaje });
        }
        res.json({
            status: "ok",
            mensaje,
            datos: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar zona:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar la zona"
        });
    }
});

//mostrar zonas 

router.get('/zonas/mostrar', async (req, res) => {
    try {
        const query = 'Select * from v_zonas';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay zonas ",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de zonas del lugar: ",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las zonas:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno con el servidor" 
        });
    }
}); 

router.get('/zonas/mostrar-inactivas', async (req, res) => {
    try {
        const query = 'Select * from zonas where activo is false';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay zonas inactivas ",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de zonas inactivas del lugar: ",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las zonas inactivas:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno con el servidor" 
        });
    }
}); 

/////////////////////////////////////////////////CATEGORIAS///////////////////////////////////////////
//ALTA CATEGORIAS
router.post('/categorias/agregar', verificarToken, async (req, res) => {
    try {
        const { nombre, descripcion } = req.body;

        // 1. Validación básica de entrada
        if (!nombre) {
            return res.status(400).json({
                status: "error",
                mensaje: "El nombre de la categoría es obligatorio"
            });
        }
        const query = 'SELECT fn_alta_categoria($1, $2) AS id_generado';
        const values = [nombre, descripcion || null];

        const result = await db.query(query, values);
        const idNuevo = result.rows[0].id_generado;

        res.status(201).json({
            status: "ok",
            mensaje: "Categoría creada exitosamente",
            datos: {
                id_categoria: idNuevo,
                nombre_cat: nombre
            }
        });

    } catch (err) {
        console.error("Error al crear categoría:", err.message);

        if (err.message.includes('no puede estar vacío') || err.message.includes('ya existe')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el alta de la categoría"
        });
    }
});

// BAJA CATEGORIAS
router.delete('/categorias/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_categoria($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;


        if (mensajeRecibido === 'La categoría no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'La categoría ya está inactiva') {
            return res.status(400).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            id_desactivada: id
        });

    } catch (err) {
        console.error("Error al desactivar categoría:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la baja de la categoría"
        });
    }
});
//MODIFICAR CATEGORIAS 
router.put('/categorias/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, descripcion, activo } = req.body;
        const query = 'SELECT fn_actualizar_categoria($1, $2, $3, $4) AS resultado';
        
        const values = [
            id,
            nombre || null,
            descripcion || null,
            activo !== undefined ? activo : null 
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'La categoría no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        if (mensaje === 'Nombre inválido' || mensaje === 'Ya existe otra categoría con ese nombre') {
            return res.status(400).json({ status: "error", mensaje });
        }
        res.json({
            status: "ok",
            mensaje,
            datos_actualizados: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar categoría:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar la categoría"
        });
    }
});

//MOSTRAR CATEGORIAS
router.get('/categorias/mostrar', async (req, res) => {
    try {
        const query = 'Select * from v_categoria';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay categorias que mostrar ",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de categorias del lugar: ",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las categorias:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno con las categorias" 
        });
    }
}); 

router.get('/categorias/mostrar-inactivas', async (req, res) => {
    try {
        const query = 'Select * from categoria where activo is false';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay categorias inactivas que mostrar ",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de categorias inactivas del lugar: ",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las categorias inactivas:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno con las categorias inactivas" 
        });
    }
}); 

module.exports = router; 