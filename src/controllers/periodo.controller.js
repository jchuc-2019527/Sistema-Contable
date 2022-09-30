'use strict'

const db = require('../../configs/pooldb');
const { validateData, periodos } = require('../utils/validate.utils');

exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test periodo controller is running'});
}

exports.newPeriodo = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            codigoEmpresa: req.params.idEmpresa,
            estadoPeriodo: body.estadoPeriodo,
            fechaInicial: body.fechaInicial,
            fechaFinal: body.fechaFinal
        };
        let msg =validateData(data);
        if(!msg) {
            let empreExi = req.params.idEmpre;
            let periodoId = await periodos();
            let periodo = periodoId.find(periodo => periodo.codigoEmpresa == empreExi);
            if(!periodo) return res.status(404).send({Message: 'Bisiness not found'});
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