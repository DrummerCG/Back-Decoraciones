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

const port = process.env.PORT || 3001;
app.listen(port, () => {
    console.log(`La aplicación está escuchando en el puerto ${port}`);
});
