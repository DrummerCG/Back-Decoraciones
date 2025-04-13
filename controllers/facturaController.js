const pool = require('../config/database');

exports.crearFactura = async (req, res) => {
    const { cliente_id, productos } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.beginTransaction();

        const result = await conn.query('INSERT INTO factura (fecha, cliente_id, total) VALUES (CURDATE(), ?, 0)', [cliente_id]);
        const facturaId = result.insertId;

        let total = 0;
        for (const producto of productos) {
            const { producto_id, cantidad, precio } = producto;
            await conn.query('INSERT INTO detalle_factura (factura_id, producto_id, cantidad, precio) VALUES (?, ?, ?, ?)', [facturaId, producto_id, cantidad, precio]);
            total += cantidad * precio;
        }

        await conn.query('UPDATE factura SET total = ? WHERE id = ?', [total, facturaId]);
        await conn.commit();
        res.status(201).json({ facturaId });
    } catch (err) {
        if (conn) await conn.rollback();
        res.status(500).json({ error: err.message });
    } finally {
        if (conn) conn.release();
    }
};

exports.obtenerFacturaPorId = async (req, res) => {
    const { id } = req.params;
    let conn;
    try {
        conn = await pool.getConnection();
        const factura = await conn.query('SELECT * FROM factura WHERE id = ?', [id]);
        const detalles = await conn.query('SELECT * FROM detalle_factura WHERE factura_id = ?', [id]);
        res.json({ factura: factura[0], detalles });
    } catch (err) {
        res.status(500).json({ error: err.message });
    } finally {
        if (conn) conn.release();
    }
};

exports.actualizarFactura = async (req, res) => {
    const { id } = req.params;
    const { cliente_id, productos, total } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.beginTransaction();

        await conn.query('UPDATE factura SET cliente_id = ?, total = ? WHERE id = ?', [cliente_id, total, id]);

        await conn.query('DELETE FROM detalle_factura WHERE factura_id = ?', [id]);
        for (const producto of productos) {
            const { producto_id, cantidad, precio } = producto;
            await conn.query('INSERT INTO detalle_factura (factura_id, producto_id, cantidad, precio) VALUES (?, ?, ?, ?)', [id, producto_id, cantidad, precio]);
        }

        await conn.commit();
        res.status(200).json({ message: 'Factura actualizada' });
    } catch (err) {
        if (conn) await conn.rollback();
        res.status(500).json({ error: err.message });
    } finally {
        if (conn) conn.release();
    }
};

exports.eliminarFactura = async (req, res) => {
    const { id } = req.params;
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.beginTransaction();

        await conn.query('DELETE FROM detalle_factura WHERE factura_id = ?', [id]);
        await conn.query('DELETE FROM factura WHERE id = ?', [id]);

        await conn.commit();
        res.status(200).json({ message: 'Factura eliminada' });
    } catch (err) {
        if (conn) await conn.rollback();
        res.status(500).json({ error: err.message });
    } finally {
        if (conn) conn.release();
    }
};

exports.obtenerUltimaFactura = async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const [factura] = await conn.query('SELECT * FROM factura ORDER BY id DESC LIMIT 1');
        const detalles = await conn.query('SELECT * FROM detalle_factura WHERE factura_id = ?', [factura.id]);
        res.json({ factura, detalles });
    } catch (err) {
        res.status(500).json({ error: err.message });
    } finally {
        if (conn) conn.release();
    }
};