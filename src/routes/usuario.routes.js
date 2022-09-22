'use strict'

const express = require('express');
const user = require('../controllers/usuario.controller');

const api =express();

api.get('/test', user.test);
api.get('/users', user.users);
api.post('/newUser', user.newUser);

module.exports = api;
