const express = require('express');
const router = express.Router();
const db = require('../db');
const verificarToken = require('../middleware/auth');

router.get('/mostrar', async (req, res) => {
    try {
        const result = await db.query('SELECT * FROM negocio_config WHERE id = 1');

        if (result.rows.length === 0) {
            return res.status(200).json({
                status: "ok",
                mensaje: "No hay configuración",
                datos: null
            });
        }

        const cfg = result.rows[0];

        res.json({
            status: "ok",
            mensaje: "Configuración obtenida",
            datos: {
                colorPrimario:     cfg.color_primario,
                colorSecundario:   cfg.color_secundario,
                colorFondo:        cfg.color_fondo,
                colorTexto:        cfg.color_texto,
                colorTextoMuted:   cfg.color_texto_muted,
                colorOscuroFondo:  cfg.color_oscuro_fondo,
                colorOscuroTexto:  cfg.color_oscuro_texto,
                logoUrl:           cfg.logo_url
            }
        });

    } catch (err) {
        console.error("Error al obtener configuración:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al obtener la configuración"
        });
    }
});

router.put('/guardar', verificarToken, async (req, res) => {
    try {
        const {
            colorPrimario, colorSecundario, colorFondo, colorTexto,
            colorTextoMuted, colorOscuroFondo, colorOscuroTexto, logoUrl
        } = req.body;

        const query = `
            UPDATE negocio_config
            SET color_primario      = COALESCE($1, color_primario),
                color_secundario    = COALESCE($2, color_secundario),
                color_fondo         = COALESCE($3, color_fondo),
                color_texto         = COALESCE($4, color_texto),
                color_texto_muted   = COALESCE($5, color_texto_muted),
                color_oscuro_fondo  = COALESCE($6, color_oscuro_fondo),
                color_oscuro_texto  = COALESCE($7, color_oscuro_texto),
                logo_url            = COALESCE($8, logo_url),
                updated_at          = now()
            WHERE id = 1
            RETURNING *
        `;
        const values = [
            colorPrimario     || null,
            colorSecundario   || null,
            colorFondo        || null,
            colorTexto        || null,
            colorTextoMuted   || null,
            colorOscuroFondo  || null,
            colorOscuroTexto  || null,
            logoUrl           !== undefined ? logoUrl : null
        ];

        const result = await db.query(query, values);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "error",
                mensaje: "No se encontró la configuración"
            });
        }

        const cfg = result.rows[0];

        res.json({
            status: "ok",
            mensaje: "Configuración guardada exitosamente",
            datos: {
                colorPrimario:     cfg.color_primario,
                colorSecundario:   cfg.color_secundario,
                colorFondo:        cfg.color_fondo,
                colorTexto:        cfg.color_texto,
                colorTextoMuted:   cfg.color_texto_muted,
                colorOscuroFondo:  cfg.color_oscuro_fondo,
                colorOscuroTexto:  cfg.color_oscuro_texto,
                logoUrl:           cfg.logo_url
            }
        });

    } catch (err) {
        console.error("Error al guardar configuración:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al guardar la configuración"
        });
    }
});

router.put('/restablecer', verificarToken, async (req, res) => {
    try {
        const query = `
            UPDATE negocio_config
            SET color_primario      = '#002D72',
                color_secundario    = '#5C2D6D',
                color_fondo         = '#f9fafb',
                color_texto         = '#111827',
                color_texto_muted   = '#6b7280',
                color_oscuro_fondo  = '#001a45',
                color_oscuro_texto  = '#f3f4f6',
                logo_url            = '',
                updated_at          = now()
            WHERE id = 1
            RETURNING *
        `;

        const result = await db.query(query);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "error",
                mensaje: "No se encontró la configuración"
            });
        }

        const cfg = result.rows[0];

        res.json({
            status: "ok",
            mensaje: "Configuración restablecida a valores predeterminados",
            datos: {
                colorPrimario:     cfg.color_primario,
                colorSecundario:   cfg.color_secundario,
                colorFondo:        cfg.color_fondo,
                colorTexto:        cfg.color_texto,
                colorTextoMuted:   cfg.color_texto_muted,
                colorOscuroFondo:  cfg.color_oscuro_fondo,
                colorOscuroTexto:  cfg.color_oscuro_texto,
                logoUrl:           cfg.logo_url
            }
        });

    } catch (err) {
        console.error("Error al restablecer configuración:", err.message);
        res.status(500).json({
            status: "error",
            mensaje: "Error interno al restablecer la configuración"
        });
    }
});

module.exports = router;
