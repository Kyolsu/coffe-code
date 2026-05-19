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

        // 1. 🔥 EMITIMOS EL WEBSOCKET DE INMEDIATO
        // Así el frontend siempre se entera de que el ESP32 leyó algo, sin importar el modo
        const io = req.app.get('socketio');
        io.emit('rfid_detectado', { 
            uid: cleanUid,
            timestamp: new Date().toISOString()
        });

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
            return res.json({
                status: "registro_exitoso",
                mensaje: `Tarjeta vinculada correctamente a ${result.rows[0].nombre}`, // <-- Backticks corregidos
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
            return res.json({
                status: "desactivacion_exitosa",
                mensaje: `La tarjeta del cliente ${result.rows[0].nombre} fue removida con éxito.` // <-- Backticks corregidos
            });
        }

        /////////////
        // MODO NORMAL 
        /////////////
        const clienteQuery = 'SELECT id_cliente, nombre, activo FROM clientes WHERE codigo_rfid = $1';
        const clienteRes = await db.query(clienteQuery, [cleanUid]);
        if (clienteRes.rows.length === 0) {
            return res.status(404).json({ status: "no_registrado", mensaje: "Tarjeta no vinculada a ningún cliente." });
        }
        
        const cliente = clienteRes.rows[0];
        if (!cliente.activo) {
            return res.status(403).json({ status: "inactivo", mensaje: "El cliente está desactivado en el sistema." });
        }

        // 2. Buscar beneficio activo (Unido con tipo_beneficio para validar si el global está activo)
        const beneficioQuery = `
            SELECT cb.id_cliente_beneficio, cb.cantidad_disponible, cb.fecha_inicio, cb.fecha_fin, cb.activo
            FROM cliente_beneficio cb
            INNER JOIN tipo_beneficio tb ON cb.id_tipo_beneficio = tb.id_tipo_beneficio
            WHERE cb.id_cliente = $1 AND cb.activo = true AND tb.activo = true
            LIMIT 1
        `;
        const beneficioRes = await db.query(beneficioQuery, [cliente.id_cliente]);
        
        if (beneficioRes.rows.length === 0) {
            return res.status(404).json({ status: "sin_beneficios", mensaje: "El cliente no tiene beneficios activos." });
        }

        const beneficio = beneficioRes.rows[0];
        const hoy = new Date();
        
        // 3. Validación de Fechas
        const inicio = new Date(beneficio.fecha_inicio);
        const fin = beneficio.fecha_fin ? new Date(beneficio.fecha_fin) : null;
        if (hoy < inicio || (fin && hoy > fin)) {
            return res.status(400).json({ 
                status: "fecha_no_disponible", 
                mensaje: "Error: El beneficio se encuentra fuera del rango de fechas válido." 
            });
        }

        // 4. Validar existencias
        if (beneficio.cantidad_disponible <= 0) {
            return res.status(400).json({ status: "agotado", mensaje: "El cliente ya no tiene usos disponibles." });
        }

        // 5. Transacción: Quitar 1 disponible y sumar 1 a usados
        const updateBeneficioQuery = `
            UPDATE cliente_beneficio 
            SET cantidad_disponible = cantidad_disponible - 1,
                cantidad_usada = cantidad_usada + 1
            WHERE id_cliente_beneficio = $1
            RETURNING cantidad_disponible, cantidad_usada
        `;
        const updateRes = await db.query(updateBeneficioQuery, [beneficio.id_cliente_beneficio]);

        return res.json({
            status: "uso_aplicado",
            mensaje: `Beneficio aplicado a ${cliente.nombre}.`, // <-- Backticks corregidos
            disponibles_restantes: updateRes.rows[0].cantidad_disponible,
            usos_totales: updateRes.rows[0].cantidad_usada
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