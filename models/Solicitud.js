const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Solicitud = sequelize.define('Solicitud', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    tipo_solicitud: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    nombre_completo: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    correo_electronico: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    telefono: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    direccion: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    nombre_producto: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    id_referencia: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    id_factura: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    motivo: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
    estado: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: 'PENDIENTE',
    },
    imagenes_base64: {
        type: DataTypes.TEXT,
        allowNull: true,
    },
}, {
    tableName: 'solicitud',
    timestamps: false,
});

module.exports = Solicitud;