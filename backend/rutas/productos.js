const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

//ALTA DE PRODUCTO
// POST: http://localhost:3000/api/productos/alta
router.post('/agregar', verificarToken, async (req, res) => {
    try {

        const { nombre, descripcion, precio, id_zona, id_categoria, url_imagen } = req.body;
        if (!nombre || !precio || !id_zona || !id_categoria) {
            return res.status(400).json({
                status: "error",
                mensaje: "Faltan campos obligatorios (nombre, precio, zona o categoría)"
            });
        }

        const query = 'SELECT fn_alta_producto($1, $2, $3, $4, $5, $6) AS nuevo_id';
        const values = [nombre, descripcion, precio, id_zona, id_categoria, url_imagen || null];

        const result = await db.query(query, values);

        const idGenerado = result.rows[0].nuevo_id;

        res.status(201).json({
            status: "ok",
            mensaje: "Producto registrado exitosamente",
            datos: {
                id_producto: idGenerado,
                nombre: nombre
            }
        });

    } catch (err) {
        console.error("Error al ejecutar fn_alta_producto:", err.message);
        if (err.code === '23503') {
            return res.status(400).json({
                status: "error",
                mensaje: "El ID de zona o categoría no existe en la base de datos"
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno del servidor al dar de alta el producto"
        });
    }
});
//BAJA Producto
router.delete('/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT fn_baja_producto($1)';
        await db.query(query, [id]);
        res.json({
            status: "ok",
            mensaje: "Producto marcado como no disponible exitosamente",
            id_producto: id
        });

    } catch (err) {
        console.error("Error al dar de baja el producto:", err.message);

        if (err.message.includes('Producto no encontrado')) {
            return res.status(404).json({
                status: "error",
                mensaje: "El producto que intentas dar de baja no existe en la base de datos"
            });
        }

        // Error genérico del servidor
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar la baja del producto"
        });
    }
});
//MODIFICAR PRODUCTO 

router.put('/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            nombre, 
            descripcion, 
            precio, 
            id_zona, 
            id_categoria, 
            url_imagen, 
            disponibilidad 
        } = req.body;

        if (!nombre || !precio || !id_zona || !id_categoria) {
            return res.status(400).json({
                status: "error",
                mensaje: "Faltan campos obligatorios para actualizar el producto"
            });
        }
        const query = `
            SELECT fn_actualizar_producto($1, $2, $3, $4, $5, $6, $7, $8) AS resultado
        `;
        const values = [
            id,
            nombre,
            descripcion || null,
            precio,
            id_zona,
            id_categoria,
            url_imagen || null,
            disponibilidad !== undefined ? disponibilidad : true
        ];

        const result = await db.query(query, values);
        const mensajeRecibido = result.rows[0].resultado;
        if (mensajeRecibido === 'Producto no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        res.json({
            status: "ok",
            mensaje: "Producto actualizado correctamente",
            datos: { id, nombre, precio, disponibilidad }
        });

    } catch (err) {
        console.error("Error al actualizar producto:", err.message);

        // Error de llave foránea (si id_zona o id_categoria no existen)
        if (err.code === '23503') {
            return res.status(400).json({
                status: "error",
                mensaje: "La zona o categoría seleccionada no es válida"
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar el producto"
        });
    }
});

//Mostrar producto 

router.get('/mostrar', async (req, res) => {
    try {
        const query = 'Select * from v_productos';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay productos",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de productos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener productos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener productos" 
        });
    }
}); 
//Mostrar productos inactivos
router.get('/mostrar-inactivo', async (req, res) => {
    try {
        const query = 'Select * from productos where disponibilidad is false';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay productos inactivos",
                datos: []
            });
        }
    
        res.json({
            status: "ok",
            mensaje: "Lista de productos inactivos",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener productos inactivos:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener productos" 
        });
    }
}); 
///INGREDIENTES
//ALTA INGREDIENTE
router.post('/ingrediente/agregar', verificarToken, async (req, res) => {
    try {
        const { nombre, tipo, precio } = req.body;
        if (!nombre || !tipo) {
            return res.status(400).json({
                status: "error",
                mensaje: "El nombre y el tipo de ingrediente son obligatorios."
            });
        }

        const query = 'SELECT fn_alta_ingrediente($1, $2, $3) AS nuevo_id';
        const values = [nombre, tipo, precio || 0];

        const result = await db.query(query, values);
        const idGenerado = result.rows[0].nuevo_id;

        res.status(201).json({
            status: "ok",
            mensaje: "Ingrediente registrado correctamente",
            datos: {
                id_ingrediente: idGenerado,
                nombre,
                tipo,
                precio_adicional: precio || 0
            }
        });

    } catch (err) {
        console.error("Error al crear ingrediente:", err.message);
        if (err.message.includes('precio no puede ser negativo')) {
            return res.status(400).json({
                status: "error",
                mensaje: err.message
            });
        }
        //si el 'tipo' enviado no existe en PostgreSQL
        if (err.code === '22P02') {
            return res.status(400).json({
                status: "error",
                mensaje: `El tipo '${req.body.tipo}' no es válido. Revisa los valores permitidos en el ENUM.`
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al procesar el alta del ingrediente"
        });
    }
});
//Baja ingrediente
router.delete('/ingrediente/desactivar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_ingrediente($1) AS resultado';
        const result = await db.query(query, [id]);

        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'El ingrediente no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }
        if (mensajeRecibido === 'El ingrediente ya está inactivo') {
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
        console.error("Error al desactivar ingrediente:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar procesar la baja del ingrediente"
        });
    }
});
//Modificar ingredientes
router.put('/ingrediente/actualizar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, tipo, precio, activo } = req.body;
        const query = `
            SELECT fn_actualizar_ingrediente($1, $2, $3, $4, $5) AS resultado
        `;
        
        const values = [
            id,
            nombre || null,
            tipo || null,
            precio !== undefined ? precio : null,
            activo !== undefined ? activo : null
        ];

        const result = await db.query(query, values);
        const mensajeRecibido = result.rows[0].resultado;

        if (mensajeRecibido === 'El ingrediente no existe') {
            return res.status(404).json({
                status: "error",
                mensaje: mensajeRecibido
            });
        }

        if (mensajeRecibido === 'Precio inválido') {
            return res.status(400).json({
                status: "error",
                mensaje: "El precio no puede ser un valor negativo."
            });
        }
        res.json({
            status: "ok",
            mensaje: mensajeRecibido,
            datos_enviados: { id, ...req.body }
        });

    } catch (err) {
        console.error("Error al actualizar ingrediente:", err.message);
        if (err.code === '22P02') {
            return res.status(400).json({
                status: "error",
                mensaje: "El tipo de ingrediente enviado no es válido."
            });
        }

        res.status(500).json({
            status: "error",
            mensaje: "Error interno al intentar actualizar el ingrediente"
        });
    }
});

//Mostrar ingredientes
router.get('/ingredientes/mostrar', async (req, res) => {
    try {
        const query = 'Select * from v_ingredientes';
        
        const result = await db.query(query);
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay ingredientes",
                datos: []
            });
        }

    
        res.json({
            status: "ok",
            mensaje: "Lista de ingredientes",
            datos: result.rows
        });

    } catch (err) {
        console.error("Error al obtener ingredientes:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al obtener ingredientes" 
        });
    }
}); 
module.exports = router; 












