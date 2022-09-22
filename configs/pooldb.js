'use strict'

const movedb = require('./mysql');

const connection = movedb.connection;
  connection.connect(error => {
    if(error) throw error;
    console.log("MySQL | Connect to database");
  });