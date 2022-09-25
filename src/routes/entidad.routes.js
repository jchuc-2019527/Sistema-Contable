'use strict'

const express = require('express');
const entidad = require('../controllers/entidad.controller');
const auth = require('../services/authenticated.services');

const api =express();

api.get('/test', entidad.test);
api.post('/newEntity', [auth.ensureAuth], entidad.newEntity);
api.put('/putEntity/:idEntity', [auth.ensureAuth], entidad.putEntity);
api.get('/entities', [auth.ensureAuth], entidad.entities);
api.get('/entityById/:idEntity', [auth.ensureAuth], entidad.entityById);
api.delete('/deleteEntity/:idEntity', [auth.ensureAuth], entidad.deleteEntity);

module.exports = api;