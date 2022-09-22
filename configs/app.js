'use strict'

//Config dep
const bodyParser = require('body-parser');
const express = require('express');
const helmet = require('helmet');
const cors =require('cors');
const port = process.env.PORT || 3000;
const app = express();

//Routes
const userRoutes = require('../src/routes/usuario.routes');


//Config client
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.use(helmet({}));
app.use(cors());


//Usege routes client
app.use('/user', userRoutes);


//Initial routes
app.get('/', (req, res) => {
    return res.status(200).send({message: 'Welcome to turboCash'});
});

app.get('/**', (req, res) => {
    return res.status(404).send({messgae: 'Endpoint not found'});
});


//Export server express
exports.initServer = () => app.listen(port, () => {
    console.log(`Listening on port ${port}`)
});