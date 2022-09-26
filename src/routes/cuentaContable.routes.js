'use strict'

const express = require('express');
const cuentaContable = require('../controllers/cuentaContable.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/test', cuentaContable.test);
api.post('/newCuentaContable', [auth.ensureAuth], cuentaContable.newCuentaContable);

module.exports = api;
