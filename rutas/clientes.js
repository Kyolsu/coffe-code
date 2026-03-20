const express = require('express');
const router = express.Router();
const db = require('../db'); 
const bcrypt = require('bcrypt'); //pal cifrado
const saltRounds = 10; // Nivel de seguridad
const jwt = require('jsonwebtoken'); //jwt tokens

// 1. Registro inicial 
router.post('/registro', async (req, res) => {
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

// 2. Vincular RFID 
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
        const query = 'SELECT * FROM alta_beneficio($1, $2)';
        const result = await db.query(query, [nombre, descripcion]);
        const { mensaje, exito } = result.rows[0];

        res.status(exito ? 201 : 400).json({ status: exito ? "ok" : "error", mensaje });
    } catch (err) {
        res.status(500).json({ status: "error", mensaje: "Error interno" });
    }
});
module.exports = router; 