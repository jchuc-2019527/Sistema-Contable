'use strict'

const express = require('express');
const user = require('../controllers/usuario.controller');
const auth = require('../services/authenticated.services');

const api =express();

api.get('/test', user.test);
api.get('/users', user.users);
api.post('/newUser/:idEmpre', user.newUser);
api.post('/login', user.login);
api.put('/putUser/:idUser', [auth.ensureAuth],user.putUser);
api.delete('/deleteUser/:idUser',[auth.ensureAuth, auth.isAdmin], user.deleteUser);
api.get('/userById/:idUser', [auth.ensureAuth], user.userById);
api.get('/usersByCompany/:idEmpre', user.usersByCompany);

module.exports = api;
