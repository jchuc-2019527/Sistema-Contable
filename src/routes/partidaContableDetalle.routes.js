'use strict'

const express = require('express'); 
const contableDetalle = require('../controllers/partidaContableDetalle.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/testD', contableDetalle.testD);
api.post('/newPartidaDetalle/:idEmpre', contableDetalle.newPartidaDetalle);
api.get('/detalleById/:idDetalle', contableDetalle.detalleById);
api.get('/partidasDetalle', contableDetalle.partidasDetalle)
api.put('/putDetalle/:idDetalle', contableDetalle.putDetalle);
api.delete('/deleteDetalle/:idDetalle', contableDetalle.deleteDetalle);

module.exports = api;