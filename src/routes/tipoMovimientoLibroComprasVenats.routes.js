'use strict'

const express = require('express');
const tipoMovimiento = require('../controllers/tipoMovimientoLibroComprasVentas.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/test', tipoMovimiento.test);
api.post('/newTipoMov', [auth.ensureAuth], tipoMovimiento.newTipoMov);
api.put('/putMovimiento/:idMove', [auth.ensureAuth], tipoMovimiento.putMovimiento);
api.get('/movements', [auth.ensureAuth], tipoMovimiento.movements);
api.get('/movementById/:idMove', [auth.ensureAuth], tipoMovimiento.movementById);
api.delete('/deleteMov/:idMove', [auth.ensureAuth], tipoMovimiento.deleteMov);

module.exports = api;