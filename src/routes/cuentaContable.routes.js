'use strict'

const express = require('express');
const cuentaContable = require('../controllers/cuentaContable.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/test', cuentaContable.test);
api.post('/newCuentaContable/:idEmpre', [auth.ensureAuth], cuentaContable.newCuentaContable);
api.get('/cuentasContables',[auth.ensureAuth], cuentaContable.cuentasContables);
api.put('/putCuentaContable/:idCuenta', [auth.ensureAuth], cuentaContable.putCuentaContable);
api.get('/cuentaById/:idCuenta', [auth.ensureAuth], cuentaContable.cuentaById);
api.delete('/deleteCuenta/:idCuenta', [auth.ensureAuth], cuentaContable.deleteCuenta);

module.exports = api;
