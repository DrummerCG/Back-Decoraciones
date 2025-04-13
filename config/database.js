/*const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('decoraciones', 'root', '', {
    host: '127.0.0.1',
    dialect: 'mariadb',
});

module.exports = sequelize;*/

const mariadb = require('mariadb');

const pool = mariadb.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'decoraciones',
    connectionLimit: 5,
});

module.exports = pool; 