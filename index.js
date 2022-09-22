'use strict'

const app = require('./configs/app');
const mysql = require('./configs/pooldb');

mysql.connection;
app.initServer();