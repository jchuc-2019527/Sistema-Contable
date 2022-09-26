'use strict'

const express = require('express');
const impuesto =  require('../controllers/impuestoAdicional.controller');
const auth =  require('../services/authenticated.services');

const api = express();

api.get('/test', impuesto.test);
api.post('/newImpuesto',[auth.ensureAuth] ,impuesto.newImpuesto);
api.put('/putImpuesto/:idTaxes', [auth.ensureAuth], impuesto.putImpuesto);
api.get('/taxes', [auth.ensureAuth], impuesto.taxes);
api.get('/taxeById/:idTaxe', [auth.ensureAuth], impuesto.taxeById);
api.delete('/deleteTaxe/:idTaxe', [auth.ensureAuth], impuesto.deleteTaxe);

module.exports = api;