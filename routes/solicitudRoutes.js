const express = require('express');
const router = express.Router();
const solicitudController = require('../controllers/solicitudController');

router.post('/', solicitudController.crearSolicitud);
router.get('/', solicitudController.obtenerSolicitudes);

module.exports = router;