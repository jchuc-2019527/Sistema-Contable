'use strict'

const db = require('../../configs/pooldb');
const { validateData, periodos } = require('../utils/validate.utils');
const moment = require('moment')

exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test periodo controller is running'});
}

exports.newPeriodo = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            codigoEmpresa: req.user.codigoEmpresa,
            estadoPeriodo: true,
            fechaInicial: moment(body.fechaFinal).format('DD/MM/YYYY'),
            fechaFinal: moment(body.fechaFinal).format('DD/MM/YYYY')
        };
        let msg =validateData(data);
        if(!msg) {
            let newPeriodo = 'INSERT INTO Periodo SET ?';
            await db.query(newPeriodo, data,(err, resu) => {
                if(err) throw err;
                return res.status(201).send({Message: 'Period created', data});
            })
        }else{
            return res.status(403).send(msg);            
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor newPeriodo'});
    }
}

exports.periodos = async(req, res) => {
    try{
        let periodo = 'SELECT * FROM Periodo';
        db.query(periodo, (err, resu) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Periods founds'});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor periodos'});
    }
}

exports.periodById = async(req, res) =>{
    try{
        let periodId = req.params.idPeriod;
        let periodExist = await periodos();
        let periodo = periodExist.find(periodo => periodo.codigoPeriodo)
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor periodById'});
    }
}