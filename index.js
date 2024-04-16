const mariadb = require('mariadb');
const express = require('express');
const app = express();

const pool = mariadb.createPool({
    host: 'localhost', // Cambia esto al host de tu base de datos
    user: 'usuariodecoraciones',
    password: 'decoracionesdecoraciones',
    database: 'decoraciones',
    connectionLimit: 5, // Límite de conexiones simultáneas
});

app.get('/productos', async(req, res) => {
    try {
        const conn = await pool.getConnection();
        const rows = await conn.query('SELECT * FROM producto');
        conn.end();
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener productos' });
    }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`La aplicación está escuchando en el puerto ${port}`);
});
