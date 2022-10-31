'use strict'

const express = require('express');
const empresaMaestro = require('../controllers/empresaMaestro.controller');
const auth = require('../services/authenticated.services');

const api =express();

api.get('/test', empresaMaestro.test);
api.post('/newEmpresaMaestro', [auth.ensureAuth],empresaMaestro.newEmpresaMaestro);
api.put('/putEmpresaMaestro/:idEmpresa',[auth.ensureAuth, auth.isAdmin],empresaMaestro.putEmpresaMaestro);
api.get('/empresasMaestros', empresaMaestro.empresasMaestros);
api.get('/empresaById/:idEmpresa', [auth.ensureAuth],empresaMaestro.empresaById);
api.delete('/deleteEmpresa/:idEmpre', [auth.ensureAuth,],empresaMaestro.deleteEmpresa);


module.exports = api;