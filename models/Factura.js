const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Factura = sequelize.define('Factura', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    fecha: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
    cliente_id: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    total: {
        type: DataTypes.FLOAT,
        allowNull: false,
    },
}, {
    tableName: 'factura',
    timestamps: false,
});

const DetalleFactura = sequelize.define('DetalleFactura', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    factura_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    producto_id: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    cantidad: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    precio: {
        type: DataTypes.FLOAT,
        allowNull: false,
    },
}, {
    tableName: 'detalle_factura',
    timestamps: false,
});

Factura.hasMany(DetalleFactura, { foreignKey: 'factura_id' });
DetalleFactura.belongsTo(Factura, { foreignKey: 'factura_id' });

module.exports = { Factura, DetalleFactura };