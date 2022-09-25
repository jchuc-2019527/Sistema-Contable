'use strict'

const express = require('express');
const user = require('../controllers/usuario.controller');
const auth = require('../services/authenticated.services');

const api =express();

api.get('/test', user.test);
api.get('/users',[auth.ensureAuth], user.users);
api.post('/newUser',[auth.ensureAuth], user.newUser);
api.post('/login', user.login);
api.put('/putUser/:idUser', [auth.ensureAuth, auth.isAdmin],user.putUser);
api.delete('/deleteUser/:idUser',[auth.ensureAuth, auth.isAdmin], user.deleteUser);
api.get('/userById/:idUser', [auth.ensureAuth], user.userById);

module.exports = api;
