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

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', 'http://localhost:3000'); // Cambia esto al dominio de tu aplicación React
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
});

app.get('/productos', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const [rows] = await conn.query(`SELECT 
        product.id, 
        product.name, 
        product.description AS product_description, 
        reference.id AS reference_id, 
        reference.size, 
        reference.price, 
        reference.main, 
        reference.description AS reference_description,
        GROUP_CONCAT(reference_image.url) AS image_urls
    FROM product    
    JOIN reference ON product.id = reference.product_id
    LEFT JOIN reference_image ON reference.id = reference_image.reference_id
    GROUP BY product.id, reference.id;`);
        conn.end();
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener productos' });
    }
});

const port = process.env.PORT || 3001;
app.listen(port, () => {
    console.log(`La aplicación está escuchando en el puerto ${port}`);
});
