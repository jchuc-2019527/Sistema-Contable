'use strict'

const express = require('express');
const activoFijo = require('../controllers/activoFijo.controller');
const auth = require('../services/authenticated.services');
const api = express.Router();

api.get('/test', activoFijo.testActivo);
api.post('/newActivoFijo/:idEmpre', [auth.ensureAuth], activoFijo.newActivoFijo);
api.get('/activosFijos', [auth.ensureAuth], activoFijo.activosFijos);
api.get('/activoId/:idActivo', activoFijo.activoId);

module.exports = api;