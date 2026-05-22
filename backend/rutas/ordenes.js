const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const verificarToken = require('../middleware/auth');

const CLOUD_URL = process.env.RENDER_URL || 'https://coffe-code-s7t9.onrender.com/api';


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

        const id_usuario = req.usuario.id; 

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

        const nuevaOrden = {
            numero_orden,
            estado_orden: 'pendiente',
            total,
            cliente: null,
            fecha_creacion: new Date().toISOString()
        };

        res.status(201).json({
            status: "ok",
            mensaje: "Orden generada exitosamente",
            id_orden: result.rows[0].id_orden,
            numero_seguimiento: numero_orden
        });

        console.log('NODE_ENV:', process.env.NODE_ENV);
        console.log('¿Enviando a cloud?', process.env.NODE_ENV !== 'production');
        console.log('URL completa:', `${CLOUD_URL}/ordenes/sync`);

        if (process.env.NODE_ENV !== 'production') {
            fetch(`${CLOUD_URL}/ordenes/sync`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(nuevaOrden)
            }).then(r => console.log('Cloud response:', r.status, r.statusText)).catch(err => console.error('Sync error to cloud:', err.message));
        } else {
            console.log('NO se envía a cloud (estoy en production)');
        }

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

// Endpoint público para sync de estado de orden (sin auth)
router.post('/sync-estado', async (req, res) => {
    try {
        const { numero_orden, estado_orden } = req.body

        if (!numero_orden || !estado_orden) {
            return res.status(400).json({ status: 'error', mensaje: 'numero_orden y estado_orden son requeridos' })
        }

        const query = `
            UPDATE ordenes 
            SET estado_orden = $1, fecha_actualizacion = NOW()
            WHERE numero_orden = $2
            RETURNING id_orden, estado_orden, numero_orden
        `

        const result = await db.query(query, [estado_orden, numero_orden])

        if (result.rows.length === 0) {
            return res.status(404).json({ status: 'error', mensaje: 'Orden no encontrada' })
        }

        res.json({ status: 'ok', datos: result.rows[0] })
    } catch (err) {
        console.error('Error en sync-estado:', err.message)
        res.status(500).json({ status: 'error', mensaje: err.message })
    }
});

router.post('/sync', async (req, res) => {
    try {
        const { numero_orden, estado_orden, total, cliente, fecha_creacion } = req.body;

        if (!numero_orden) {
            return res.status(400).json({ status: 'error', mensaje: 'numero_orden es requerido' });
        }

        const query = `
            INSERT INTO ordenes (numero_orden, estado_orden, total, cliente, fecha_creacion)
            VALUES ($1, $2, $3, $4, $5)
            ON CONFLICT (numero_orden) DO NOTHING
            RETURNING id_orden
        `;

        const result = await db.query(query, [numero_orden, estado_orden || 'pendiente', total, cliente, fecha_creacion]);

        res.status(201).json({ status: 'ok', id_orden: result.rows[0]?.id_orden });
    } catch (err) {
        console.error('Error en sync:', err.message);
        res.status(500).json({ status: 'error', mensaje: err.message });
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

router.put('/estado/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { estado_orden } = req.body;

        if (!estado_orden) {
            return res.status(400).json({ status: "error", mensaje: "Estado requerido" });
        }

        const query = `SELECT fn_actualizar_orden($1, $2, NULL, NULL, NULL, NULL, NULL, NULL, NULL) AS resultado`;
        const result = await db.query(query, [id, estado_orden]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'La orden no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        console.error("Error al actualizar estado:", err.message);
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});

router.get('/modificadores/:idOrden', async (req, res) => {
    try {
        const { idOrden } = req.params;

        const query = `
            SELECT om.id_detalle_modificador, om.id_orden_detalle,
                   om.id_ingrediente, i.nombre_ingrediente,
                   om.accion, om.precio_modificador,
                   om.id_seleccion,
                   od.id_orden, od.nombre_producto,
                   od.id_producto
            FROM orden_detalle_modificadores om
            JOIN orden_detalles od ON om.id_orden_detalle = od.id_orden_detalle
            JOIN ingredientes i ON om.id_ingrediente = i.id_ingrediente
            WHERE od.id_orden = $1
        `;

        const result = await db.query(query, [idOrden]);

        res.json({
            status: "ok",
            datos: result.rows
        });
    } catch (err) {
        console.error("Error al obtener modificadores:", err.message);
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});

router.get('/selecciones-paquete/:idOrden', async (req, res) => {
    try {
        const { idOrden } = req.params;

        const query = `
            SELECT ops.id_seleccion, ops.id_orden_detalle, ops.id_paquete_grupo,
                   ops.id_producto, p.nombre_producto,
                   od.id_orden
            FROM orden_paquete_selecciones ops
            JOIN orden_detalles od ON ops.id_orden_detalle = od.id_orden_detalle
            JOIN productos p ON ops.id_producto = p.id_producto
            WHERE od.id_orden = $1
        `;

        const result = await db.query(query, [idOrden]);

        res.json({
            status: "ok",
            datos: result.rows
        });
    } catch (err) {
        console.error("Error al obtener selecciones:", err.message);
        res.status(500).json({ status: "error", mensaje: "Error interno" });
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


//////////////////////////////////////////////////////////
// Orden pagos
//////////////////////////////////////////////////////////


router.post('/pagos/agregar', verificarToken, async (req, res) => {
    try {
        const { id_orden, metodo, monto, referencia } = req.body;
        const id_usuario = req.usuario.id_usuario; 

        if (!id_orden || !metodo || monto === undefined || monto === null) {
            return res.status(400).json({ status: "error", mensaje: "Faltan datos obligatorios" });
        }

        const query = 'SELECT fn_alta_pago($1, $2, $3, $4, $5) AS resultado';
        const result = await db.query(query, [id_orden, metodo, monto, referencia || null, id_usuario]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Monto inválido') {
            return res.status(400).json({ status: "error", mensaje });
        }

        res.status(201).json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }

});

router.delete('/pagos/cancelar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_pago($1) AS resultado';
        const result = await db.query(query, [id]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Pago no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});


router.put('/pagos/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { metodo, monto, referencia, activo } = req.body;
        const id_usuario = req.usuario.id_usuario;

        const query = 'SELECT fn_actualizar_pago($1, $2, $3, $4, $5, $6) AS resultado';
        const values = [
            id, 
            metodo || null, 
            monto !== undefined ? monto : null, 
            referencia || null, 
            id_usuario, 
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Pago no existe') return res.status(404).json({ status: "error", mensaje });
        if (mensaje === 'Monto inválido') return res.status(400).json({ status: "error", mensaje });

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});


router.get('/pagos/mostrar', verificarToken,async (req, res) => {
    try {
        const query = 'Select * from v_orden_pagos';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes pagos",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes de pago",
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
// Orden Paquetes Selección
//////////////////////////////////////////////////////////

router.post('/paquete-seleccion/agregar', verificarToken, async (req, res) => {
    try {
        const { id_detalle, id_grupo, id_producto, cantidad } = req.body;

        if (!id_detalle || !id_grupo || !id_producto) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_detalle, id_grupo e id_producto son obligatorios."
            });
        }

        const query = 'SELECT fn_alta_ops($1, $2, $3, $4) AS id_seleccion';
        const values = [id_detalle, id_grupo, id_producto, cantidad || 1];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Selección de paquete registrada",
            id_seleccion: result.rows[0].id_seleccion
        });

    } catch (err) {
        console.error("Error en alta OPS:", err.message);
        if (err.message.includes('Cantidad inválida')) {
            return res.status(400).json({ status: "error", mensaje: err.message });
        }
        res.status(500).json({ status: "error", mensaje: "Error interno al procesar la selección" });
    }
});


router.delete('/paquete-seleccion/cancelar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_ops($1) AS resultado';
        const result = await db.query(query, [id]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'No existe la selección') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});

router.put('/paquete-seleccion/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { cantidad } = req.body;

        const query = 'SELECT fn_actualizar_ops($1, $2) AS resultado';
        const result = await db.query(query, [id, cantidad || null]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'No existe la selección') return res.status(404).json({ status: "error", mensaje });
        if (mensaje === 'Cantidad inválida') return res.status(400).json({ status: "error", mensaje });

        res.json({ status: "ok", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});

router.get('/paquete-seleccion/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_orden_paquete_selecciones';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes paquete seleccion",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes en seleccion de paquete",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las ordenes de paquete seleccion:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

//////////////////////////////////////////////////////////
// Orden Detalles
//////////////////////////////////////////////////////////


router.post('/detalles/agregar', verificarToken, async (req, res) => {
    try {
        const { 
            id_orden, 
            cantidad, 
            precio_unitario, 
            subtotal, 
            id_producto, 
            id_paquete, 
            descuento, 
            id_promocion, 
            id_zona, 
            notas 
        } = req.body;

        // 1. Validaciones básicas antes de ir a la base de datos
        if (!id_orden || !cantidad || !precio_unitario || subtotal === undefined) {
            return res.status(400).json({
                status: "error",
                mensaje: "Faltan campos obligatorios (orden, cantidad, precio o subtotal)."
            });
        }

        // 2. Llamada a la función de PostgreSQL
        const query = `
            SELECT fn_alta_orden_detalle($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) AS id_detalle
        `;
        
        const values = [
            id_orden,
            cantidad,
            precio_unitario,
            subtotal,
            id_producto || null,
            id_paquete || null,
            descuento || 0,
            id_promocion || null,
            id_zona || null,
            notas || null
        ];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Ítem agregado a la orden",
            id_orden_detalle: result.rows[0].id_detalle
        });

    } catch (err) {
        console.error("Error al insertar detalle de orden:", err.message);

        // Capturamos los RAISE EXCEPTION específicos de tu función
        if (err.message.includes('Cantidad inválida') || 
            err.message.includes('Montos inválidos') || 
            err.message.includes('Debe especificar producto o paquete')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el detalle de la orden"
        });
    }
});

router.delete('/detalles/cancelar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_orden_detalle($1) AS resultado';
        const result = await db.query(query, [id]);
        
        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'No existe el detalle') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }

        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            id_detalle_eliminado: id
        });

    } catch (err) {
        console.error("Error al eliminar detalle de orden:", err.message);
        if (err.message.includes('foreign key constraint')) {
            return res.status(400).json({
                status: "error",
                mensaje: "No se puede eliminar el detalle porque tiene selecciones de paquete vinculadas. Elimina primero las selecciones (OPS)."
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar eliminar el ítem"
        });
    }
});

router.put('/detalles/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            cantidad, 
            precio, 
            descuento, 
            subtotal, 
            estado, 
            notas 
        } = req.body;

        const query = `
            SELECT fn_actualizar_orden_detalle($1, $2, $3, $4, $5, $6, $7) AS resultado
        `;
        
        const values = [
            id,
            cantidad !== undefined ? cantidad : null,
            precio !== undefined ? precio : null,
            descuento !== undefined ? descuento : null,
            subtotal !== undefined ? subtotal : null,
            estado || null, 
            notas || null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'No existe el detalle') {
            return res.status(404).json({
                status: "error",
                mensaje
            });
        }

        res.json({
            status: "ok",
            mensaje,
            id_actualizado: id
        });

    } catch (err) {
        console.error("Error al actualizar detalle de orden:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la actualización del detalle"
        });
    }
});

router.get('/detalles/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_orden_detalles';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de ordenes detalles",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de ordenes  detalles",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las ordenes de paquete seleccion:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

//////////////////////////////////////////////////////////
// Orden Detalles modificador
//////////////////////////////////////////////////////////

router.post('/detalles-modificadores/', verificarToken, async (req, res) => {
    try {
        const { id_detalle, id_ingrediente, accion, precio } = req.body;

        if (!id_detalle || !id_ingrediente) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_detalle e id_ingrediente son obligatorios."
            });
        }
        const query = `
            SELECT fn_alta_orden_modifica($1, $2, $3, $4) AS id_modificador
        `;
        
        const values = [
            id_detalle,
            id_ingrediente,
            accion || 'agregar', 
            precio !== undefined ? precio : 0
        ];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Modificador aplicado al producto",
            id_detalle_modificador: result.rows[0].id_modificador
        });

    } catch (err) {
        console.error("Error al aplicar modificador:", err.message);

        if (err.message.includes('Precio inválido')) {
            return res.status(400).json({
                status: "error",
                mensaje: "El precio del modificador no puede ser negativo."
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el modificador"
        });
    }
});

router.delete('/detalles-modificadores/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_orden_modificador($1) AS resultado';
        const result = await db.query(query, [id]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'No existe el modificador') {
            return res.status(404).json({
                status: "error",
                mensaje
            });
        }

        res.json({
            status: "ok",
            mensaje,
            id_eliminado: id
        });

    } catch (err) {
        console.error("Error al eliminar modificador:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar eliminar el modificador"
        });
    }
});

router.delete('/detalles-modificadores/', verificarToken, async (req, res) => {
    try {
        const { id_detalle, id_ingrediente, id_seleccion } = req.body;

        if (!id_detalle || !id_ingrediente) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_detalle e id_ingrediente son obligatorios."
            });
        }

        let query;
        let values;

        if (id_seleccion) {
            query = `
                DELETE FROM orden_detalle_modificadores
                WHERE id_orden_detalle = $1 AND id_ingrediente = $2 AND id_seleccion = $3
                RETURNING id_detalle_modificador
            `;
            values = [id_detalle, id_ingrediente, id_seleccion];
        } else {
            query = `
                DELETE FROM orden_detalle_modificadores
                WHERE id_orden_detalle = $1 AND id_ingrediente = $2 AND id_seleccion IS NULL
                RETURNING id_detalle_modificador
            `;
            values = [id_detalle, id_ingrediente];
        }

        const result = await db.query(query, values);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "error",
                mensaje: "No se encontró el modificador para eliminar"
            });
        }

        res.json({
            status: "ok",
            mensaje: "Modificador eliminado",
            id_eliminado: result.rows[0].id_detalle_modificador
        });

    } catch (err) {
        console.error("Error al eliminar modificador:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar eliminar el modificador"
        });
    }
});

router.put('/detalles-modificadores/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { accion, precio } = req.body;

        const query = 'SELECT fn_actualizar_orden_modificador($1, $2, $3) AS resultado';
        const values = [
            id,
            accion || null, 
            precio !== undefined ? precio : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'No existe el modificador') {
            return res.status(404).json({
                status: "error",
                mensaje
            });
        }

        res.json({
            status: "ok",
            mensaje,
            datos_actualizados: { id, accion, precio }
        });

    } catch (err) {
        console.error("Error al actualizar modificador:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la actualización del modificador"
        });
    }
});

router.get('/detalles-modificadores/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_orden_modificadores';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay información en la tabla de modificadores detalles",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de modificadores detalles",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener los detales de modificadores:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion de los modificadores" 
        });
    }
}); 


module.exports = router; 
