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

router.get('/paquetes/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_promocion_paquetes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay columnas en la tabla promociones paquetes",
                datos: []
            });
        }
    
        res.json({
            status: "ok",
            mensaje: "Lista de promociones vinculadas a paquetes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las promociones vinculadas a los paquetes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

router.post('/paquetes/vincular', verificarToken, async (req, res) => {
    try {
        const { id_promocion, id_paquete } = req.body;

        if (!id_promocion || !id_paquete) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_promocion e id_paquete son obligatorios."
            });
        }

        const query = 'SELECT fn_alta_promocion_paquete($1, $2) AS resultado';
        const result = await db.query(query, [id_promocion, id_paquete]);
        const mensaje = result.rows[0].resultado;

        // Si la función retorna que ya existe, mandamos un código 409 (Conflicto)
        if (mensaje === 'El paquete ya está en esta promoción') {
            return res.status(409).json({
                status: "error",
                mensaje
            });
        }

        res.status(201).json({
            status: "ok",
            mensaje,
            datos: { id_promocion, id_paquete }
        });

    } catch (err) {
        console.error("Error al asignar paquete a promoción:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la vinculación"
        });
    }
});

router.delete('/paquetes/desvincular', verificarToken, async (req, res) => {
    try {
        const { id_promocion, id_paquete } = req.body;

        if (!id_promocion || !id_paquete) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_promocion e id_paquete son necesarios para la eliminación."
            });
        }

        const query = 'SELECT fn_baja_promocion_paquete($1, $2) AS resultado';
        const result = await db.query(query, [id_promocion, id_paquete]);
        const mensaje = result.rows[0].resultado;

        res.json({
            status: "ok",
            mensaje,
            datos_eliminados: { id_promocion, id_paquete }
        });

    } catch (err) {
        console.error("Error al desvincular paquete de promoción:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar eliminar la relación"
        });
    }
});

//////////////////////////////////////////////////////////////////
// PROMOCION CLIENTE
//////////////////////////////////////////////////////////////////

router.post('/clientes/vincular', verificarToken, async (req, res) => {
    try {
        const { id_promocion, id_cliente } = req.body;
        if (!id_promocion || !id_cliente) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_promocion e id_cliente son obligatorios."
            });
        }

        const query = 'SELECT fn_alta_promocion_cliente($1, $2) AS resultado';
        const values = [id_promocion, id_cliente];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;
        if (mensaje === 'El cliente ya tiene esta promoción') {
            return res.status(409).json({ 
                status: "error",
                mensaje
            });
        }

        res.status(201).json({
            status: "ok",
            mensaje,
            datos: { id_promocion, id_cliente }
        });

    } catch (err) {
        console.error("Error al asignar promoción al cliente:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar vincular al cliente con la promoción"
        });
    }
});

router.delete('/clientes/desvincular', verificarToken, async (req, res) => {
    try {
        const { id_promocion, id_cliente } = req.body;

        if (!id_promocion || !id_cliente) {
            return res.status(400).json({
                status: "error",
                mensaje: "Se requiere id_promocion e id_cliente para procesar la baja."
            });
        }
        const query = 'SELECT fn_baja_promocion_cliente($1, $2) AS resultado';
        const result = await db.query(query, [id_promocion, id_cliente]);
        
        const mensajeRecibido = result.rows[0].resultado;
        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            datos_eliminados: { id_promocion, id_cliente }
        });

    } catch (err) {
        console.error("Error al eliminar promoción del cliente:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar quitar la promoción al cliente"
        });
    }
});

router.get('/clientes/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_promocion_clientes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay columnas en la tabla promociones paquetes",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de promociones vinculadas a paquetes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las promociones vinculadas a los paquetes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

//////////////////////////////////////////////////////////////////
// PROMOCION PRODUCTOS
//////////////////////////////////////////////////////////////////

router.post('/productos/vincular', verificarToken, async (req, res) => {
    try {
        const { id_promocion, id_producto } = req.body;

        if (!id_promocion || !id_producto) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_promocion e id_producto son obligatorios."
            });
        }

        const query = 'SELECT fn_alta_promocion_producto($1, $2) AS resultado';
        const result = await db.query(query, [id_promocion, id_producto]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'El producto ya está en esta promoción') {
            return res.status(409).json({
                status: "error",
                mensaje
            });
        }

        res.status(201).json({
            status: "ok",
            mensaje,
            datos: { id_promocion, id_producto }
        });

    } catch (err) {
        console.error("Error al asignar producto a promoción:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la vinculación del producto"
        });
    }
});

router.delete('/productos/desvincular', verificarToken, async (req, res) => {
    try {
        const { id_promocion, id_producto } = req.body;

        if (!id_promocion || !id_producto) {
            return res.status(400).json({
                status: "error",
                mensaje: "Se requiere id_promocion e id_producto para la baja."
            });
        }

        const query = 'SELECT fn_baja_promocion_producto($1, $2) AS resultado';
        const result = await db.query(query, [id_promocion, id_producto]);
        const mensaje = result.rows[0].resultado;

        res.json({
            status: "ok",
            mensaje,
            datos_eliminados: { id_promocion, id_producto }
        });

    } catch (err) {
        console.error("Error al desvincular producto de promoción:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar eliminar la relación"
        });
    }
});


router.get('/productos/mostrar',verificarToken, async (req, res) => {
    try {
        const query = 'Select * from v_promocion_productos';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay columnas en la tabla promociones productos",
                datos: []
            });
        }
        res.json({
            status: "ok",
            mensaje: "Lista de promociones vinculadas a productos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener las promociones vinculadas a los productos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener la informacion" 
        });
    }
}); 

module.exports = router; 