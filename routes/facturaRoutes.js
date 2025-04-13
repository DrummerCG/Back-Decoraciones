const express = require('express');
const router = express.Router();
const facturaController = require('../controllers/facturaController');

router.post('/', facturaController.crearFactura);
router.get('/:id', facturaController.obtenerFacturaPorId);
router.put('/:id', facturaController.actualizarFactura);
router.delete('/:id', facturaController.eliminarFactura);
router.get('/ultima', facturaController.obtenerUltimaFactura);

module.exports = router;