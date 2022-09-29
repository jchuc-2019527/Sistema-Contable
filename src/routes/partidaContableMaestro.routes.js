'use strict'

const express= require('express');
const partidaMaestro = require('../controllers/partidaContableMaestro.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/test', partidaMaestro.test);
api.post('/newPartidaMaestro/:idEmpre', partidaMaestro.newPartidaMaestro);
api.get('/partidasMaestro', partidaMaestro.partidasMaestro);
api.get('/partidaById/:idPartida', partidaMaestro.partidaById);
api.put('/putPartida/:idPartida', partidaMaestro.putPartida);
api.delete('/deletePartida/:idPartida', partidaMaestro.deletePartida);

module.exports = api;