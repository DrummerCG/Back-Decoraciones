const mariadb = require('mariadb');
const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
const app = express();
app.use(express.json()); // Middleware para manejar JSON en el cuerpo de las solicitudes

const pool = mariadb.createPool({
    host: '127.0.0.1', 
    user: 'root',
    password: '',
    database: 'decoraciones',
    connectionLimit: 5, // Límite de conexiones simultáneas
});

// Middleware para manejar CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', 'http://localhost:3000'); // Cambia esto al dominio de tu aplicación React
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
});

app.use(cors()); // Permitir todas las solicitudes CORS

// Ruta para crear una nueva factura
app.post('/facturas', async (req, res) => {
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
});

// Ruta para obtener una factura por ID
app.get('/facturas/:id', async (req, res) => {
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
});

// Ruta para actualizar una factura
app.put('/facturas/:id', async (req, res) => {
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
});

// Ruta para eliminar una factura
app.delete('/facturas/:id', async (req, res) => {
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
});

// Ruta para obtener la última factura creada
app.get('/facturas/ultima', async (req, res) => {
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
});

app.get('/productos', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const [rows] = await conn.query(`SELECT productos.id as id_producto, productos.Nombre, productos.Descripcion as descripcion_principal, productos.Url_imagen AS Url_imagen_default, 
        inventario.id as inventario_id, inventario.Color, inventario.Diseño, inventario.Calidad, inventario.Tamaño, inventario.Stock, inventario.Url_imagen, inventario.Descripcion, inventario.Ancho, inventario.Alto, inventario.Largo,
        proveedor.*
        FROM productos
        LEFT JOIN inventario ON productos.id = inventario.ID_Productos
        LEFT JOIN inventario_y_proveedor ON inventario.id = inventario_y_proveedor.id_inventario
        LEFT JOIN proveedor ON inventario_y_proveedor.id_proveedor = proveedor.id
        WHERE inventario.Stock > 0;`);
        conn.end();
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener productos' });
    }
});

app.post('/usuarios/registro', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const { id_type, id, name, phone, email, address, neighborhood, city, state, country, password, confirmPassword, terms } = req.body;

        // Check if user already exists
        const [existingUser] = await conn.query(
            `SELECT * FROM usuario WHERE Correo = ?`,
            [email]
        );

        if (existingUser) {
            conn.end();
            return res.status(400).json({ error: 'El usuario ya existe' });
        }

        // Check if contact info already exists
        const [existingContact] = await conn.query(
            `SELECT * FROM contacto WHERE Id = ?`,
            [id]
        );

        if (existingContact?.length === 0) {
            // Insert new contact info
            await conn.query(
                `INSERT INTO contacto (Id, Tipo_id, Nombre, Telefono, Correo, Direccion, Ciudad, Departamento, Barrio) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [id, id_type, name, phone, email, address, neighborhood, city, state]
            );
        }

        // Insert new user
        await conn.query(
            `INSERT INTO usuario (Correo, Contraseña, ID_Contacto, Verificado) VALUES (?, ?, ?, ?)`,
            [email, password, id, 0]
        );
        conn.end();

        enviarCorreoVerificacion(email);

        if (existingContact.length === 0) {
            res.json({ mensaje: 'Usuario y contacto registrados' });
        } else {
            res.json({ mensaje: 'Usuario registrado, la información de contacto ya existe, comunicate con un asesor para actualizarla.' });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al registrar usuario' });
    }
});


const enviarCorreoVerificacion = async (email) => {
    console.log(`Enviando correo de verificación a ${email}`);
    let transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'tuemail@gmail.com', // Cambia esto a el correo
            pass: 'tucontraseña', // Cambia esto a la contraseña
        },
    });

    let mailOptions = {
        from: 'tuemail@gmail.com', // Cambia esto al correo
        to: email,
        subject: 'Verificación de correo electrónico',
        html: `
                <div style="font-family: Arial, sans-serif; text-align: center;">
                    <h2 style="color: #4CAF50;">¡Bienvenido a Decoraciones!</h2>
                    <p>Gracias por registrarte. Por favor, haz clic en el botón de abajo para verificar tu correo electrónico.</p>
                    <a href="http://localhost:3000/verificar?email=${email}" style="display: inline-block; padding: 10px 20px; font-size: 16px; color: white; background-color: #4CAF50; text-decoration: none; border-radius: 5px;">Verificar Correo</a>
                    <p>Si no te has registrado en nuestro sitio, por favor ignora este correo.</p>
                    <p>Saludos,<br>El equipo de Decoraciones Ortiz</p>
                </div>
            `,
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Correo de verificación enviado a ${email}`);
    } catch (error) {
        console.error(`Error al enviar correo de verificación: ${error}`);
    }
};

app.post('/solicitudes', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const {
            tipo_solicitud,
            nombre_completo,
            correo_electronico,
            telefono,
            direccion,
            nombre_producto,
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
});

app.get('/solicitudes', async (req, res) => {
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
});

const port = process.env.PORT || 3001;
app.listen(port, () => {
    console.log(`La aplicación está escuchando en el puerto ${port}`);
});