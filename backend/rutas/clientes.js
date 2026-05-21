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
        const { nombre, email, telefono, activo, codigo_rfid } = req.body;

        const query = `
            UPDATE clientes
            SET nombre = $1, email = $2, telefono = $3, activo = $4, codigo_rfid = $5
            WHERE id_cliente = $6
            RETURNING *
        `;

        const values = [nombre, email, telefono, activo, codigo_rfid || null, id];
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
        const query = 'SELECT * FROM clientes WHERE activo = true ORDER BY nombre';
        
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
        const query = 'SELECT fn_alta_tipo_beneficio($1, $2) AS id_tipo_beneficio';
        const result = await db.query(query, [nombre, descripcion || null]);
        const idRetornado = result.rows[0].id_tipo_beneficio;

        res.status(201).json({ status: "ok", mensaje: "Tipo de beneficio registrado correctamente", id_tipo_beneficio: idRetornado });
    } catch (err) {
        if (err.message.includes('ya existe') || err.message.includes('El tipo de beneficio ya existe')) {
            return res.status(400).json({ status: "error", mensaje: "El tipo de beneficio ya existe" });
        }
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});

// Mostrar beneficios
router.get('/beneficio/mostrar', async (req, res) => {
    try {
        const query = 'SELECT id_tipo_beneficio, nombre, descripcion, activo FROM tipo_beneficio ORDER BY id_tipo_beneficio ASC';
        
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

// Elimina un beneficio específico por su ID (soft delete)
router.delete('/beneficio/eliminar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_tipo_beneficio($1) AS resultado';
        const result = await db.query(query, [id]);
        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'No existe el tipo de beneficio') {
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
        console.error("Error al eliminar beneficio:", err.message);
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
        const { nombre, descripcion, activo } = req.body;
        const query = 'SELECT fn_actualizar_tipo_beneficio($1, $2, $3, $4) AS resultado';
        const values = [id, nombre || null, descripcion || null, activo !== undefined ? activo : null];

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
            datos_actualizados: { id, nombre, descripcion, activo }
        });

    } catch (err) {
        console.error("Error al actualizar tipo de beneficio:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la actualización del beneficio"
        });
    }
});

//////////////////////////////////////////////
//CLIENTES BENEFICIOS
//////////////////////////////////////////////
//MOSTRAR CLIENTES BENEFICIOS
router.get('/beneficio-clientes/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'SELECT * from v_cliente_beneficio';
        
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

router.post('/beneficio-clientes/agregar', verificarToken, async (req, res) => {
    try {
        const { 
            id_cliente, 
            id_tipo_beneficio, 
            fecha_inicio, 
            cantidad, 
            fecha_fin, 
            dias 
        } = req.body;

        if (!id_cliente || !id_tipo_beneficio || !fecha_inicio) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_cliente, id_tipo_beneficio y fecha_inicio son obligatorios."
            });
        }
        const query = `
            SELECT fn_alta_cliente_beneficio($1, $2, $3, $4, $5, $6) AS id_asignacion
        `;
        
        const values = [
            id_cliente,
            id_tipo_beneficio,
            fecha_inicio,
            cantidad !== undefined ? cantidad : 0,
            fecha_fin || null,
            dias || null
        ];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Beneficio asignado correctamente al cliente",
            id_cliente_beneficio: result.rows[0].id_asignacion
        });

    } catch (err) {
        console.error("Error al asignar beneficio:", err.message);
        if (err.message.includes('Cantidad no puede ser negativa')) {
            return res.status(400).json({
                status: "error",
                mensaje: "La cantidad de beneficios debe ser un número positivo."
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la asignación del beneficio"
        });
    }
});

router.delete('/beneficio-clientes/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_cliente_beneficio($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'No existe el registro') {
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
        console.error("Error al dar de baja el beneficio del cliente:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar desactivar el beneficio"
        });
    }
});

router.put('/beneficio-clientes/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            disponible, 
            usado, 
            fecha_inicio, 
            fecha_fin, 
            dias, 
            activo 
        } = req.body;

        const query = `
            SELECT fn_actualizar_cliente_beneficio($1, $2, $3, $4, $5, $6, $7) AS resultado
        `;
        
        const values = [
            id,
            disponible !== undefined ? disponible : null,
            usado !== undefined ? usado : null,
            fecha_inicio || null,
            fecha_fin || null,
            dias || null,
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'No existe el registro') {
            return res.status(404).json({
                status: "error",
                mensaje
            });
        }

        if (mensaje === 'Cantidad inválida') {
            return res.status(400).json({
                status: "error",
                mensaje: "La cantidad disponible no puede ser menor a 0"
            });
        }
        res.json({
            status: "ok",
            mensaje: "Beneficio actualizado correctamente",
            datos_actualizados: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar beneficio del cliente:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la actualización del beneficio"
        });
    }
});


//////////////////////////////////////////////
/// USO BENEFICIOS
//////////////////////////////////////////////

//alta

router.post('/beneficios/uso', verificarToken, async (req, res) => {
    try {
        const { id_cliente_beneficio, id_orden, cantidad } = req.body;

        if (!id_cliente_beneficio || !id_orden) {
            return res.status(400).json({
                status: "error", 
                mensaje: "id_cliente_beneficio e id_orden son obligatorios."
            });
        }

        const query = 'SELECT fn_alta_uso_beneficio($1, $2, $3) AS resultado';
        const result = await db.query(query, [id_cliente_beneficio, id_orden, cantidad || 1]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Cantidad inválida') {
            return res.status(400).json({ status: "error", mensaje });
        }

        res.status(201).json({ status: "ok", mensaje });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ status: "error", mensaje: "Error al registrar el uso del beneficio" });
    }
});

//Actualizar
router.put('/beneficios/uso/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { cantidad, activo } = req.body;

        const query = 'SELECT fn_actualizar_uso_beneficio($1, $2, $3) AS resultado';
        const result = await db.query(query, [id, cantidad !== undefined ? cantidad : null, activo !== undefined ? activo : null]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Registro no existe') return res.status(404).json({ status: "error", mensaje });
        if (mensaje === 'Cantidad inválida') return res.status(400).json({ status: "error", mensaje });

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error al actualizar el registro" });
    }
});

/////////baja

router.delete('/beneficios/uso/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_uso_beneficio($1) AS resultado';
        const result = await db.query(query, [id]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Registro no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error al desactivar el uso del beneficio" });
    }
});

//get 
router.get('/beneficios/uso', verificarToken, async (req, res) => {
    try {
        const result = await db.query('SELECT * FROM v_uso_beneficios');
        res.json({
            status: "ok",
            datos: result.rows
        });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error al obtener historial" });
    }
});


module.exports = router; 