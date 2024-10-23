const mariadb = require('mariadb');
const express = require('express');
const nodemailer = require('nodemailer');
const app = express();

// Middleware para manejar JSON en el cuerpo de las solicitudes
app.use(express.json());

const pool = mariadb.createPool({
    host: 'localhost', // Cambia esto al host de tu base de datos
    user: 'root',
    password: '',
    database: 'decoraciones',
    connectionLimit: 5, // Límite de conexiones simultáneas
});

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', 'http://localhost:3000'); // Cambia esto al dominio de tu aplicación React
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
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
                `INSERT INTO contacto (Id, Tipo_id, Nombre, Telefono, Correo, Direccion, Ciudad, Departamento, Pais) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [id, id_type, name, phone, email, address, neighborhood, city, state, country]
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
            user: 'tuemail@gmail.com', // Cambia esto a tu correo
            pass: 'tucontraseña', // Cambia esto a tu contraseña
        },
    });

    let mailOptions = {
        from: 'tuemail@gmail.com', // Cambia esto a tu correo
        to: email,
        subject: 'Verificación de correo electrónico',
        html: `
                <div style="font-family: Arial, sans-serif; text-align: center;">
                    <h2 style="color: #4CAF50;">¡Bienvenido a Decoraciones!</h2>
                    <p>Gracias por registrarte. Por favor, haz clic en el botón de abajo para verificar tu correo electrónico.</p>
                    <a href="http://localhost:3000/verificar?email=${email}" style="display: inline-block; padding: 10px 20px; font-size: 16px; color: white; background-color: #4CAF50; text-decoration: none; border-radius: 5px;">Verificar Correo</a>
                    <p>Si no te has registrado en nuestro sitio, por favor ignora este correo.</p>
                    <p>Saludos,<br>El equipo de Decoraciones</p>
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

const port = process.env.PORT || 3001;
app.listen(port, () => {
    console.log(`La aplicación está escuchando en el puerto ${port}`);
});