'use strict'

const express = require('express');
const pContableM = require('../controllers/plantillaContableMaestro.controller');
const auth = require('../services/authenticated.services');

const api = express();

api.get('/test', pContableM.test)

module.exports = api;