const express = require('express');
const cors = require('cors');
const userRoutes = require('./routes/userRoutes');
const facturaRoutes = require('./routes/facturaRoutes');
const solicitudRoutes = require('./routes/solicitudRoutes');
const bodyParser = require('body-parser');
const pool = require('./config/database'); 

const app = express();
const port = process.env.PORT || 3001;

app.use(express.json());
app.use(cors({
    origin: 'http://localhost:3000', 
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true,
}));
app.use(bodyParser.json());

// Prueba de conexión a la base de datos
(async () => {
    try {
        const conn = await pool.getConnection();
        console.log('Conexión a la base de datos exitosa');
        conn.release();
    } catch (err) {
        console.error('Error al conectar a la base de datos:', err);
    }
})();

app.use('/api/usuarios', userRoutes);
app.use('/api/facturas', facturaRoutes);
app.use('/api/solicitudes', solicitudRoutes);
app.use(bodyParser.json());
app.use('/api', userRoutes);

// Inicia el servidor
app.listen(port, () => {
    console.log(`Servidor escuchando en el puerto ${port}`);
});
