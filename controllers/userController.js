const pool = require('../config/database'); // Conexión a la base de datos
const nodemailer = require('nodemailer'); // Para enviar correos de verificación

// Función para enviar correo de verificación
const enviarCorreoVerificacion = async (email) => {
    console.log(`Enviando correo de verificación a ${email}`);
    let transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'santizxz@gmail.com',
            pass: 'Put@elquelolea3',
        },
    });

    let mailOptions = {
        from: 'tuemail@gmail.com',
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

// Controlador para registrar un usuario
exports.registrarUsuario = async (req, res) => {
    let conn;
    try {
        console.log('Iniciando registro de usuario...');
        conn = await pool.getConnection();
        console.log('Conexión a la base de datos establecida.');

        const { id_type, id, name, phone, email, address, neighborhood, city, state, country, password, confirmPassword, terms } = req.body;
        console.log('Datos recibidos:', req.body);

        // Validaciones
        if (!terms) {
            console.log('Error: No se aceptaron los términos y condiciones.');
            return res.status(400).json({ error: 'Debe aceptar los términos y condiciones' });
        }
        if (password !== confirmPassword) {
            console.log('Error: Las contraseñas no coinciden.');
            return res.status(400).json({ error: 'Las contraseñas no coinciden' });
        }

        // Verificar si el usuario ya existe
        const [existingUser] = await conn.query(`SELECT * FROM usuario WHERE Correo = ?`, [email]);
        console.log('Resultado de búsqueda de usuario existente:', existingUser);

        if (existingUser && existingUser.length > 0) {
            return res.status(400).json({ error: 'El usuario ya existe' });
        }

        // Verificar si el contacto ya existe
        const [existingContact] = await conn.query(`SELECT * FROM contacto WHERE Id = ?`, [id]);
        console.log('Resultado de búsqueda de contacto existente:', existingContact);

        if (existingContact.length === 0) {
            console.log('Insertando nuevo contacto...');
            await conn.query(
                `INSERT INTO contacto (Id, Tipo_id, Nombre, Telefono, Correo, Direccion, Ciudad, Departamento, Nacionalidad, Barrio) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [id, id_type, name, phone, email, address, neighborhood, city, state, country]
            );
        }

        // Insertar usuario
        console.log('Insertando nuevo usuario...');
        await conn.query(
            `INSERT INTO usuario (Correo, Contraseña, ID_Contacto, Verificado) VALUES (?, ?, ?, ?)`,
            [email, password, id, 0]
        );

        enviarCorreoVerificacion(email);
        console.log('Correo de verificación enviado.');

        res.status(201).json({ mensaje: 'Usuario registrado exitosamente!' });
    } catch (err) {
        console.error('Error en el registro de usuario:', err);
        res.status(500).json({ error: 'Error al registrar usuario' });
    } finally {
        if (conn) conn.release();
    }
};

exports.obtenerUsuarios = async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection(); // Obtén una conexión del pool
        console.log('Obteniendo lista de usuarios...');

        // Consulta para obtener todos los usuarios
        const usuarios = await conn.query(`
            SELECT usuario.Correo, usuario.Verificado, contacto.Nombre, contacto.Telefono, contacto.Correo AS CorreoContacto
            FROM usuario
            INNER JOIN contacto ON usuario.ID_Contacto = contacto.Id
        `);

        res.status(200).json(usuarios); // Devuelve la lista de usuarios en formato JSON
    } catch (err) {
        console.error('Error al obtener usuarios:', err);
        res.status(500).json({ error: 'Error al obtener usuarios' });
    } finally {
        if (conn) conn.release(); // Libera la conexión
    }
};