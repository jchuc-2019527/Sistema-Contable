'use strict'

const db = require('../../configs/pooldb');

exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test plantillaContebleMaestro controller is runnig'})
}

exports.newPlantillaContrableMaestro = async (req, res) => {
    try{
        const body = req.body;
        const data = {

        };
    }catch(err) {
        console.log(err)
        return res.status(500),send({Message: 'Error en el servidor newPlantillaContableMaestro'});
    }
}