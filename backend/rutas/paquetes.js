const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

// POST: http://localhost:3000/api/usuarios/paquetes
router.post('/agregar', verificarToken, async (req, res) => {
    try {
        const { 
            nombre, 
            descripcion, 
            precio, 
            es_temporal, 
            fecha_inicio, 
            fecha_fin, 
            dias_disponibles, 
            url_imagen 
        } = req.body;
        if (!nombre || !precio) {
            return res.status(400).json({
                status: "error",
                mensaje: "El nombre y el precio del paquete son obligatorios."
            });
        }
        const query = `
            SELECT fn_alta_paquete($1, $2, $3, $4, $5, $6, $7, $8) AS id_paquete
        `;
        
        const values = [
            nombre,
            descripcion || null,
            precio,
            es_temporal !== undefined ? es_temporal : false, 
            fecha_inicio || null,
            fecha_fin || null,
            dias_disponibles || null,
            url_imagen || null
        ];

        const result = await db.query(query, values);
        const idGenerado = result.rows[0].id_paquete;

        res.status(201).json({
            status: "ok",
            mensaje: "Paquete creado exitosamente",
            id_paquete: idGenerado
        });

    } catch (err) {
        console.error("Error al crear paquete:", err.message);

        const erroresSQL = [
            'precio del paquete debe ser mayor a 0',
            'Debe indicar fecha_inicio y fecha_fin',
            'fecha_fin no puede ser menor'
        ];

        if (erroresSQL.some(msg => err.message.includes(msg))) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el alta del paquete"
        });
    }
});

router.delete('/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_paquete($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'El paquete no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'El paquete ya está inactivo') {
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
        console.error("Error al dar de baja el paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar procesar la baja del paquete"
        });
    }
});

// Actualizar paquete  
router.put('/actualizar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            nombre, 
            descripcion, 
            precio, 
            es_temporal, 
            fecha_inicio, 
            fecha_fin, 
            dias_disponibles, 
            url_imagen, 
            activo 
        } = req.body;

        const query = `
            SELECT fn_actualizar_paquete($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) AS resultado
        `;
        
        const values = [
            id,
            nombre || null,
            descripcion || null,
            precio !== undefined ? precio : null,
            es_temporal !== undefined ? es_temporal : null,
            fecha_inicio || null,
            fecha_fin || null,
            dias_disponibles || null,
            url_imagen || null,
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'El paquete no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        if (mensaje === 'Precio inválido' || mensaje.includes('no puede ser menor')) {
            return res.status(400).json({ status: "error", mensaje });
        }

        res.json({
            status: "ok",
            mensaje,
            datos_editados: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar el paquete"
        });
    }
});


//MOSTRAR PAQUETE VISTA REDUCIDA 
router.get('/vista-comprimida', async (req, res) => {
    try {
        const query = 'select*from v_paquetes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay paquetes",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de paquetes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener paquetes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener paquetes" 
        });
    }
});

//MOSTRAR PAQUETE VISTA COMPLETA 

router.get('/vista-completa', async (req, res) => {
    try {
        const query = 'select*from paquetes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay paquetes",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de paquetes completos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener paquetes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener los paquetes" 
        });
    }
});


//////////////////////////////////
//PAQUETES GRUPO 
/////////////////////////////////


//ALTA PAQUETE GRUPO

router.post('/grupos/agregar', verificarToken, async (req, res) => {
    try {
        const { id_paquete, nombre_grupo, es_obligatorio, cantidad } = req.body;
        if (!id_paquete || !nombre_grupo) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_paquete y nombre_grupo son campos obligatorios."
            });
        }
        const query = `
            SELECT fn_alta_paquete_grupo($1, $2, $3, $4) AS id_grupo
        `;
        const values = [
            id_paquete,
            nombre_grupo,
            es_obligatorio !== undefined ? es_obligatorio : true,
            cantidad || 1
        ];

        const result = await db.query(query, values);
        
        res.status(201).json({
            status: "ok",
            mensaje: "Grupo de selección creado exitosamente",
            id_paquete_grupo: result.rows[0].id_grupo
        });

    } catch (err) {
        console.error("Error al crear grupo de paquete:", err.message);
        if (err.message.includes('El paquete no existe') || err.message.includes('mayor a 0')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el grupo del paquete"
        });
    }
});

router.delete('/grupos/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_paquete_grupo($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;
        if (mensajeRecibido === 'El grupo no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'El grupo ya está inactivo') {
            return res.status(400).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            id_grupo_desactivado: id
        });

    } catch (err) {
        console.error("Error al desactivar grupo de paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la baja del grupo"
        });
    }
});


router.put('/grupos/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, obligatorio, cantidad, activo } = req.body;

        const query = `
            SELECT fn_actualizar_paquete_grupo($1, $2, $3, $4, $5) AS resultado
        `;
        const values = [
            id,
            nombre || null,
            obligatorio !== undefined ? obligatorio : null,
            cantidad !== undefined ? cantidad : null,
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;
        if (mensaje === 'El grupo no existe') {
            return res.status(404).json({ status: "error", mensaje });
        }

        if (mensaje === 'cantidad_selecciones inválida') {
            return res.status(400).json({ status: "error", mensaje });
        }
        res.json({
            status: "ok",
            mensaje,
            datos_nuevos: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar grupo de paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar el grupo"
        });
    }
}); 

//MOSTRAR PAQUETE GRUPO
router.get('/grupo/mostrar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT * FROM fn_get_grupos_por_paquete($1)';
        const result = await db.query(query, [id]);

        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "Este paquete aún no tiene grupos de selección asignados.",
                datos: []
            });
        }

        res.json({
            status: "ok",
            total_grupos: result.rows.length,
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener grupos del paquete:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al consultar los grupos del paquete"
        });
    }
});

////////////////////////////////////////////////////////////////////////////////////////////////
//paquete grupo productos 
//////////////////////////////////////////////////////////////////////////////////////////////////


///ALTA
router.post('/grupos-productos/vincular', verificarToken, async (req, res) => {
    try {
        const { id_grupo, id_producto, precio_adicional } = req.body;
        if (!id_grupo || !id_producto) {
            return res.status(400).json({
                status: "error",
                mensaje: "id_grupo e id_producto son obligatorios."
            });
        }
        const query = 'SELECT fn_alta_paquete_grupo_producto($1, $2, $3) AS resultado';
        const values = [id_grupo, id_producto, precio_adicional || 0];

        const result = await db.query(query, values);
        const mensaje = result.rows[0].resultado;
        if (mensaje === 'Ya existe esta relación') {
            return res.status(409).json({ // 409: Conflict
                status: "error",
                mensaje
            });
        }

        res.status(201).json({
            status: "ok",
            mensaje,
            datos: { id_grupo, id_producto, precio_adicional }
        });

    } catch (err) {
        console.error("Error al vincular producto al grupo:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la vinculación"
        });
    }
});

router.put('/grupos-productos/modificar', verificarToken, async (req, res) => {
    try {
        const { id_grupo, id_producto, precio } = req.body;

        if (!id_grupo || !id_producto || precio === undefined) {
            return res.status(400).json({
                status: "error",
                mensaje: "Faltan datos obligatorios (id_grupo, id_producto, precio)"
            });
        }

        const query = 'SELECT fn_actualizar_paquete_grupo_productos($1, $2, $3) AS resultado';
        const result = await db.query(query, [id_grupo, id_producto, precio]);
        const mensaje = result.rows[0].resultado;

        if (mensaje === 'Precio inválido') {
            return res.status(400).json({ status: "error", mensaje });
        }

        if (mensaje === 'Relación no encontrada') {
            return res.status(404).json({ status: "error", mensaje });
        }

        res.json({
            status: "ok",
            mensaje,
            datos: { id_grupo, id_producto, nuevo_precio: precio }
        });

    } catch (err) {
        console.error("Error al actualizar precio del item:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al actualizar el precio"
        });
    }
});

router.delete('/grupos-productos/desvincular', verificarToken, async (req, res) => {
    try {
        const { id_grupo, id_producto } = req.body;

        if (!id_grupo || !id_producto) {
            return res.status(400).json({
                status: "error",
                mensaje: "Se requiere id_grupo e id_producto para eliminar la relación."
            });
        }
        const query = 'SELECT fn_baja_paquete_grupo_producto($1, $2) AS resultado';
        const result = await db.query(query, [id_grupo, id_producto]);
        
        const mensajeRecibido = result.rows[0].resultado;
        if (mensajeRecibido === 'No existe la relación') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            datos_eliminados: { id_grupo, id_producto }
        });

    } catch (err) {
        console.error("Error al eliminar item del grupo:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar eliminar el producto del grupo"
        });
    }
});
/////////////////////////////////
//OBTENER TODAS LOS GRUPOS DE PAQUETES
////////////////////////////////

router.get('/menu-completo', async (req, res) => {
    try {
        const query = 'SELECT fn_get_menu_paquetes_completo() AS menu';
        const result = await db.query(query);
        res.json({
            status: "ok",
            datos: result.rows[0].menu || []
        });

    } catch (err) {
        console.error("Error al obtener el menú de paquetes:", err.message);
        res.status(500).json({ status: "error", mensaje: err.message });
    }
});

module.exports = router; 
