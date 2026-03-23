const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens
const verificarToken = require('../middleware/auth');

//Endpoint registro
router.post('/registro', async (req, res) => {
    const { usuario, contra, rol } = req.body;

    try {
        const contracifrada =await bcrypt.hash(contra,saltRounds)
        const query = 'SELECT * FROM alta_usuario($1, $2, $3)';
        const values = [usuario, contracifrada, rol];
        
        const result = await db.query(query, values);
        const { mensaje, exito } = result.rows[0];

        if (exito) {
            res.status(201).json({ status: "ok", mensaje });
        } else {
            res.status(400).json({ status: "error", mensaje });
        }
    } catch (err) {
        console.error("Error en el servidor:", err);
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});

//endpoint eliminar usuario
router.delete('/eliminar', async (req, res) => {
    const { usuario, contra } = req.body; 

    if (!usuario || !contra) {
        return res.status(400).json({ status: "error", mensaje: "Se requiere usuario y contraseña para confirmar la baja" });
    }

    try {
        
        const userQuery = 'SELECT * FROM usuarios WHERE nombre_usuario = $1';
        const userResult = await db.query(userQuery, [usuario]);

        if (userResult.rows.length === 0) {
            return res.status(404).json({ status: "error", mensaje: "Usuario no encontrado" });
        }

        const user = userResult.rows[0];
        const match = await bcrypt.compare(contra, user.contra);

        if (!match) {
            return res.status(401).json({ status: "error", mensaje: "Contraseña incorrecta. No se pudo realizar la baja." });
        }

        const deleteQuery = 'SELECT * FROM baja_usuario_por_nombre($1)';
        const deleteResult = await db.query(deleteQuery, [usuario]);
        
        const { mensaje, exito } = deleteResult.rows[0];

        res.status(exito ? 200 : 400).json({ status: exito ? "ok" : "error", mensaje });

    } catch (err) {
        console.error("Error al procesar la baja:", err);
        res.status(500).json({ status: "error", mensaje: "Error interno del servidor" });
    }
});

// Endpoint cambiar usuario/contraseña
router.put('/actualizar', async (req, res) => {
    const { usuario_actual, contra_actual, nuevo_nombre, nueva_contra } = req.body;

    if (!usuario_actual || !contra_actual) {
        return res.status(400).json({ status: "error", mensaje: "Se requiere usuario y contraseña actual para confirmar" });
    }

    try {
        const userQuery = 'SELECT * FROM usuarios WHERE nombre_usuario = $1';
        const userResult = await db.query(userQuery, [usuario_actual]);

        if (userResult.rows.length === 0) {
            return res.status(404).json({ status: "error", mensaje: "Usuario no encontrado" });
        }

        const user = userResult.rows[0];
        const match = await bcrypt.compare(contra_actual, user.contra);
        if (!match) {
            return res.status(401).json({ status: "error", mensaje: "La contraseña actual es incorrecta" });
        }
        let passwordFinal = null;
        if (nueva_contra) {
            passwordFinal = await bcrypt.hash(nueva_contra, 10);
        }

        const updateQuery = 'SELECT * FROM actualizar_perfil_usuario($1, $2, $3)';
        const updateResult = await db.query(updateQuery, [
            user.id_usuario, 
            nuevo_nombre || null, 
            passwordFinal
        ]);

        const { mensaje, exito } = updateResult.rows[0];
        res.status(exito ? 200 : 400).json({ status: exito ? "ok" : "error", mensaje });

    } catch (err) {
        console.error(err);
        res.status(500).json({ status: "error", mensaje: "Error interno del servidor" });
    }
});
//Endpoint mostrar info del usuario 
router.get('/perfil', verificarToken, async (req, res) => {
    try {

        const query = 'SELECT id_usuario, nombre_usuario, id_rol FROM usuarios WHERE id_usuario = $1';
        const result = await db.query(query, [req.usuario.id]); 

        if (result.rows.length === 0) {
            return res.status(404).json({ status: "error", mensaje: "Usuario no encontrado" });
        }

        const usuario = result.rows[0];
        res.json({
            status: "ok",
            datos: {
                id: usuario.id_usuario,
                nombre: usuario.nombre_usuario,
                rol: usuario.id_rol
            }
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ status: "error", mensaje: "Error al obtener perfil" });
    }
});

// Endpoint de Login
router.post('/login', async (req, res) => {
    const { usuario, contra } = req.body;

    if (!usuario || !contra) {
        return res.status(400).json({ status: "error", mensaje: "Usuario y contraseña requeridos" });
    }

    try {
       // Buscar usuario
        const query = 'SELECT * FROM usuarios WHERE nombre_usuario = $1';
        const result = await db.query(query, [usuario]);

        if (result.rows.length === 0) {
            return res.status(401).json({ status: "error", mensaje: "Usuario o contraseña incorrectos" });
        }

        const user = result.rows[0];

        const match = await bcrypt.compare(contra, user.contra);

        if (match) {
                const payload = {
                        id: user.id_usuario,
                        nombre: user.nombre_usuario,
                        rol: user.id_rol}
        const token = jwt.sign(payload, process.env.JWT_SECRET, {
        expiresIn: '24h' // El token durará 24 horas
        });

            res.status(200).json({ 
                status: "ok", 
                mensaje: "¡Bienvenido ",
                token: token,
                usuario: {
                    id: user.id_usuario,
                    nombre: user.nombre_usuario,
                    rol: user.id_rol
                }
            });
        } else {
            // Contraseña incorrecta
            res.status(401).json({ status: "error", mensaje: "Usuario o contraseña incorrectos" });
        }

    } catch (err) {
        console.error("Error en el login:", err);
        res.status(500).json({ status: "error", mensaje: "Error interno del servidor" });
    }
});

//ALTA DE ROL
router.post('/rol/alta', verificarToken, async (req, res) => {
    try {
        const { nombre_rol, descripcion } = req.body;

        if (!nombre_rol) {
            return res.status(400).json({ status: "error", mensaje: "El nombre del rol es obligatorio" });
        }

        const query = 'SELECT fn_alta_rol($1, $2) AS nuevo_id';
        const result = await db.query(query, [nombre_rol, descripcion]);

        res.status(201).json({
            status: "ok",
            mensaje: "Rol creado exitosamente",
            id_rol: result.rows[0].nuevo_id
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ status: "error", mensaje: "Error al crear el rol" });
    }
});

// BAJA DE ROL
router.delete('/rol/baja/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'SELECT fn_baja_rol($1) AS eliminado';
        const result = await db.query(query, [id]);

        if (!result.rows[0].eliminado) {
            return res.status(404).json({ status: "error", mensaje: "No se encontró el rol para eliminar" });
        }

        res.json({ status: "ok", mensaje: "Rol eliminado correctamente" });
    } catch (err) {
        console.error(err.message);
        if (err.code === '23503') {
            return res.status(400).json({ 
                status: "error", 
                mensaje: "No puedes eliminar este rol porque hay usuarios asignados a él." 
            });
        }
        res.status(500).json({ status: "error", mensaje: "Error al eliminar el rol" });
    }
});

router.get('/rol/mostrar', verificarToken, async (req, res) => {
    try {
        const query = 'select *  from v_roles'; 
        const result = await db.query(query);
        // no hay beneficios
        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay ningun rol disponible",
                datos: []
            });
        }

        res.json({
            status: "ok",
            mensaje: "Lista de roles obtenidos",
            datos: result.rows
        });
    } catch (err) {
        console.error("Error con el servidor:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al consultar los roles" 
        });
    }
});

router.put('/rol/modificar/:id', verificarToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre_rol, descripcion } = req.body;

        // Validación: El nombre es obligatorio para mantener la integridad
        if (!nombre_rol) {
            return res.status(400).json({ 
                status: "error", 
                mensaje: "El nombre del rol es requerido para la actualización" 
            });
        }

        // Llamamos a la función de edición
        const query = 'SELECT fn_editar_rol($1, $2, $3) AS actualizado';
        const result = await db.query(query, [id, nombre_rol, descripcion]);

        // Verificamos si la función encontró el registro (retornó true)
        if (!result.rows[0].actualizado) {
            return res.status(404).json({ 
                status: "error", 
                mensaje: "No se encontró el rol solicitado para editar" 
            });
        }

        res.json({
            status: "ok",
            mensaje: "Rol actualizado correctamente",
            datos: { id, nombre_rol, descripcion }
        });

    } catch (err) {
        console.error("Error al editar rol:", err.message);
        res.status(500).json({ 
            status: "error", 
            mensaje: "Error interno al intentar actualizar el rol" 
        });
    }
});

module.exports = router;