const express = require('express');
const router = express.Router();
const db = require('../db'); 

// estado del servidor
let accionPendiente = null;

// =========================================================================
// GET: http://192.168.100.39:3000/api/iot/rfid/:uid
// =========================================================================
router.get('/rfid/:uid', async (req, res) => {
    try {
        const { uid } = req.params;
        const cleanUid = uid.trim().toUpperCase();

        const io = req.app.get('socketio');

        ///////////////
        // MODO REGISTRO
        /////////////
        if (accionPendiente && accionPendiente.type === 'registro') {
            const idClienteTarget = accionPendiente.id_cliente;
            accionPendiente = null;
            const updateQuery = `
                UPDATE clientes
                SET codigo_rfid = $1
                WHERE id_cliente = $2
                RETURNING id_cliente, nombre
            `;
            const result = await db.query(updateQuery, [cleanUid, idClienteTarget]);
            if (result.rows.length === 0) {
                return res.status(404).json({ status: "error", mensaje: "El cliente a registrar no existe." });
            }
            io.emit('rfid_detectado', {
                uid: cleanUid,
                status: 'registro_exitoso',
                mensaje: `Tarjeta vinculada correctamente a ${result.rows[0].nombre}`,
                timestamp: new Date().toISOString()
            });
            return res.json({
                status: "registro_exitoso",
                mensaje: `Tarjeta vinculada correctamente a ${result.rows[0].nombre}`,
                codigo_rfid: cleanUid
            });
        }

        ///////////////
        // MODO DESACTIVAR
        /////////////
        if (accionPendiente && accionPendiente.type === 'desactivar') {
            accionPendiente = null;
            const deactivateQuery = `
                UPDATE clientes
                SET codigo_rfid = NULL
                WHERE codigo_rfid = $1
                RETURNING id_cliente, nombre
            `;
            const result = await db.query(deactivateQuery, [cleanUid]);
            if (result.rows.length === 0) {
                return res.status(404).json({ status: "error", mensaje: "Esta tarjeta no estaba asignada a ningún cliente." });
            }
            io.emit('rfid_detectado', {
                uid: cleanUid,
                status: 'desactivacion_exitosa',
                mensaje: `La tarjeta del cliente ${result.rows[0].nombre} fue removida con éxito.`,
                timestamp: new Date().toISOString()
            });
            return res.json({
                status: "desactivacion_exitosa",
                mensaje: `La tarjeta del cliente ${result.rows[0].nombre} fue removida con éxito.`
            });
        }

        /////////////
        // MODO NORMAL — SOLO IDENTIFICAR (no consume beneficios)
        /////////////
        const clienteQuery = 'SELECT id_cliente, nombre, activo FROM clientes WHERE codigo_rfid = $1';
        const clienteRes = await db.query(clienteQuery, [cleanUid]);

        if (clienteRes.rows.length === 0) {
            io.emit('rfid_detectado', {
                uid: cleanUid,
                status: 'no_registrado',
                mensaje: 'Tarjeta no vinculada a ningún cliente.',
                timestamp: new Date().toISOString()
            });
            return res.status(404).json({ status: "no_registrado", mensaje: "Tarjeta no vinculada a ningún cliente." });
        }

        const cliente = clienteRes.rows[0];
        if (!cliente.activo) {
            return res.status(403).json({ status: "inactivo", mensaje: "El cliente está desactivado en el sistema." });
        }

        // Buscar beneficios activos para mostrarlos (sin decrementar)
        const beneficioQuery = `
            SELECT cb.id_cliente_beneficio, cb.cantidad_disponible, cb.fecha_inicio, cb.fecha_fin, cb.activo,
                   tb.nombre as nombre_beneficio
            FROM cliente_beneficio cb
            INNER JOIN tipo_beneficio tb ON cb.id_tipo_beneficio = tb.id_tipo_beneficio
            WHERE cb.id_cliente = $1 AND cb.activo = true AND tb.activo = true
            ORDER BY cb.fecha_inicio DESC
        `;
        const beneficioRes = await db.query(beneficioQuery, [cliente.id_cliente]);

        const beneficios = beneficioRes.rows.map(b => ({
            id_cliente_beneficio: b.id_cliente_beneficio,
            nombre_beneficio: b.nombre_beneficio,
            cantidad_disponible: b.cantidad_disponible,
            disponible: b.cantidad_disponible > 0
        }))

        // Emitir socket con datos completos para que frontend no haga segundo request
        io.emit('rfid_detectado', {
            uid: cleanUid,
            status: 'cliente_identificado',
            mensaje: `Cliente ${cliente.nombre} identificado.`,
            cliente: {
                id_cliente: cliente.id_cliente,
                nombre: cliente.nombre
            },
            beneficios: beneficios,
            timestamp: new Date().toISOString()
        });

        return res.json({
            status: "cliente_identificado",
            mensaje: `Cliente ${cliente.nombre} identificado.`,
            cliente: {
                id_cliente: cliente.id_cliente,
                nombre: cliente.nombre
            },
            beneficios: beneficios
        });

    } catch (err) {
        console.error("Error en el lector RFID:", err.message);
        res.status(500).json({ status: "error", mensaje: "Error interno del servidor al procesar RFID." });
    }
});

router.post('/modo-registro', (req, res) => {
    const { id_cliente } = req.body;
    if (!id_cliente) {
        return res.status(400).json({ status: "error", mensaje: "Falta el id_cliente." });
    }
    accionPendiente = { type: 'registro', id_cliente: parseInt(id_cliente) };
    res.json({ status: "servidor_preparado", mensaje: "Modo registro activado. Pase la tarjeta por el lector." });
});

router.post('/modo-desactivar', (req, res) => {
    accionPendiente = { type: 'desactivar' };
    res.json({ status: "servidor_preparado", mensaje: "Modo desactivación activado. Pase la tarjeta a remover." });
});

module.exports = router;