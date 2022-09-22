'use strict'

const mysql = require("mysql2");

  let getCon;
  exports.connection =  getCon = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "ADMIN",
    database: "movedb",
  });

