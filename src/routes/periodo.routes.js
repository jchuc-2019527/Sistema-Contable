'use strict'

const express = require('express');
const periodo = require('../controllers/periodo.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/test', periodo.test);
api.post('/newPeriodo', [auth.ensureAuth], periodo.newPeriodo);

module.exports = api;