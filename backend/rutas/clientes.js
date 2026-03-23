const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');
// Registro inicial 
router.post('/registro',verificarToken, async (req, res) => {
    const { nombre, email, telefono } = req.body;

    try {
        const query = 'SELECT * FROM alta_cliente($1, $2, $3)';
        const result = await db.query(query, [nombre, email, telefono]);
        const { mensaje, exito } = result.rows[0];

        res.status(exito ? 201 : 400).json({ status: exito ? "ok" : "error", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});
// Modificar clientes
router.put('/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, email, telefono, activo } = req.body;

        const query = `
            UPDATE clientes 
            SET nombre = $1, email = $2, telefono = $3, activo = $4 
            WHERE id_cliente = $5 
            RETURNING *
        `;
        
        const values = [nombre, email, telefono, activo, id];
        const result = await db.query(query, values);
        if (result.rowCount === 0) {
            return res.status(404).json({
                status: "error",
                mensaje: "No se encontró el cliente para actualizar"
            });
        }
        res.json({
            status: "ok",
            mensaje: "Cliente actualizado correctamente",
            datos: result.rows[0]
        });

    } catch (err) {
        console.error("Error al actualizar cliente:", err.message);

        if (err.code === '23505') {
            return res.status(400).json({
                status: "error",
                mensaje: "Ese correo electrónico ya está registrado con otro cliente"
            });
        }

        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al actualizar el cliente" 
        });
    }
});
//ver clientes activos
router.get('/mostrar-activos', async (req, res) => {
    try {
        const query = 'Select * from v_clientes_activos';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay clientes activos",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de clientes activos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener clientes activos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener clientes" 
        });
    }
});
//ver clientes inactivos
router.get('/mostrar-inactivos', async (req, res) => {
    try {
        const query = 'select*from clientes where activo is false';       
        const result = await db.query(query);

        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay clientes inactivos",
                datos: []
            });
        }

        res.json({
            status: "ok",
            mensaje: "Lista de clientes inactivos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener clientes inactivos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener clientes" 
        });
    }
});

// Vincular RFID 
router.put('/asignar-rfid', async (req, res) => {
    const { id_cliente, codigo_rfid } = req.body;

    if (!id_cliente || !codigo_rfid) {
        return res.status(400).json({ status: "error", mensaje: "ID de cliente y código RFID son requeridos" });
    }
    try {
        const query = 'SELECT * FROM asignar_rfid_cliente($1, $2)';
        const result = await db.query(query, [id_cliente, codigo_rfid]);
        const { mensaje, exito } = result.rows[0];
        if (exito) {
            res.status(200).json({ status: "ok", mensaje });
        } else {
            res.status(404).json({ status: "error", mensaje });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ status: "error", mensaje: "Error al vincular RFID" });
    }
});
//registrar beneficio
router.post('/beneficio/registrar', async (req, res) => {
    const { nombre, descripcion} = req.body;
    if(!nombre) {
        return res.status(400).json({ status: "error", mensaje: "registre el nombre del beneficio" });
    }
    try {
        const query = 'SELECT * FROM alta_beneficio($1, $2)';
        const result = await db.query(query, [nombre, descripcion]);
        const { mensaje, exito } = result.rows[0];

        res.status(exito ? 201 : 400).json({ status: exito ? "ok" : "error", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});

// Mostrar beneficios
router.get('/beneficio/mostrar', async (req, res) => {
    try {
        const query = 'SELECT id_tipo_beneficio, nombre, descripcion FROM tipo_beneficio ORDER BY id_tipo_beneficio ASC';
        
        const result = await db.query(query);

        // no hay beneficios
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay ningun beneficio",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de beneficios obtenida",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener beneficios:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al consultar beneficios" 
        });
    }
});

// Elimina un beneficio específico por su ID
router.delete('/beneficio/eliminar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'DELETE FROM tipo_beneficio WHERE id_tipo_beneficio = $1 RETURNING *';
        const result = await db.query(query, [id]);

        if (result.rowCount === 0) {
            return res.status(404).json({
                status: "error",
                mensaje: "No se encontró el beneficio con ese ID"
            });
        }

        res.json({
            status: "ok",
            mensaje: `Beneficio '${result.rows[0].nombre}' eliminado correctamente`,
            datos_eliminados: result.rows[0]
        });

    } catch (err) {
        console.error("Error al eliminar beneficio:", err.message);
        
        // Error en caso de que el beneficio se encuentre en otras tablas
        if (err.code === '23503') {
            return res.status(400).json({
                status: "error",
                mensaje: "No se puede eliminar este beneficio porque ya está asignado a algunos clientes"
            });
        }

        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al eliminar el beneficio" 
        });
    }
});

//Modificar un beneficio
router.put('/beneficio/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, descripcion } = req.body;

        const query = 'SELECT fn_actualizar_tipo_beneficio($1, $2, $3) AS resultado';
        const values = [id, nombre || null, descripcion || null];

        const result = await db.query(query, values);
        const mensajeRecibido = result.rows[0].resultado;
        if (mensajeRecibido === 'No existe el tipo de beneficio') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'Nombre inválido' || mensajeRecibido === 'Ya existe otro con ese nombre') {
            return res.status(400).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            datos_actualizados: { id, nombre, descripcion }
        });

    } catch (err) {
        console.error("Error al actualizar tipo de beneficio:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la actualización del beneficio"
        });
    }
});

module.exports = router; 