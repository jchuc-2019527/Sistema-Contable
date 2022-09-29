'use strict'

const express = require('express'); 
const contableDetalle = require('../controllers/partidaContableDetalle.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/testD', contableDetalle.testD);
api.post('/newPartidaDetalle/:idEmpre', contableDetalle.newPartidaDetalle);

module.exports = api;