const jwt = require('jsonwebtoken');

const verificarToken = (req, res, next) => {
    // obtenemos token
    const token = req.header('auth-token');

    if (!token) {
        return res.status(401).json({ 
            status: "error", 
            mensaje: "Acceso denegado. Se requiere un token para esta operación." 
        });
    }

    try {
        // usamos clave 
        const cifrado = jwt.verify(token, process.env.JWT_SECRET);
        
        //  Guardar los datos del usuario 
        req.usuario = cifrado;
        
        next();
    } catch (err) {

        res.status(400).json({ 
            status: "error", 
            mensaje: "Token no válido o expirado." 
        });
    }
};

module.exports = verificarToken;