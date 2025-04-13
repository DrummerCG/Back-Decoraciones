const pool = require('../config/database');

exports.crearSolicitud = async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const {
            tipo_solicitud,
            nombre_completo,
            correo_electronico,
            telefono,
            direccion,
            nombre_producto,
            id_referencia,
            id_factura,
            motivo,
            estado,
            imagenes_base64
        } = req.body;

        await conn.query(
            `INSERT INTO solicitud (
                tipo_solicitud,
                nombre_completo,
                correo_electronico,
                telefono,
                direccion,
                nombre_producto,
                id_referencia,
                id_factura,
                motivo,
                estado,
                imagenes_base64
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,

            [
                tipo_solicitud,
                nombre_completo,
                correo_electronico,
                telefono,
                direccion,
                nombre_producto,
                id_referencia,            
                id_factura,
                motivo,
                estado || 'PENDIENTE',
                imagenes_base64
            ]
        );
        conn.end();
        res.json({ mensaje: 'Solicitud registrada exitosamente' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al registrar la solicitud' });
    }
};

exports.obtenerSolicitudes = async (req, res) => {
    try {
        const { estado } = req.query;
        const conn = await pool.getConnection();

        let query = 'SELECT * FROM solicitud';
        let params = [];

        if (estado) {
            query += ' WHERE estado = ?';
            params.push(estado);
        }

        const rows = await conn.query(query, params);
        conn.end();
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener las solicitudes' });
    }
};