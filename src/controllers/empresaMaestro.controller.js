'use strict'

const db = require('../../configs/pooldb');
const {validateData, nombreEmpresaExist, empresasMaestros } = require('../utils/validate.utils');

exports.test = (req, res) => {
    return res.status(200).send({message: 'Test empresaMaestro controller is running'});
}

exports.newEmpresaMaestro = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            nombreEmpresa: body.nombreEmpresa,
            nombreComercial: body.nombreComercial,
            direccionEmpresa: body.direccionEmpresa,
            NITEmpresa: body.NITEmpresa,
            porcentajeIVA: body.porcentajeIVA,
        };
        let msg = validateData(data);
        if(!msg) {
            const empresaEx = await nombreEmpresaExist()
            const empresa = empresaEx.find(nombreEmpresa => nombreEmpresa.nombreEmpresa == data.nombreEmpresa);
            if(!empresa) {
                let empresaNew = 'INSERT INTO EmpresaMaestro SET ?';
                await db.query(empresaNew, data,(error, result) => {
                    if(error) throw error;
                    return res.status(201).send({message: 'Buisiness created', data});
                })
            }else{
                return res.status(409).send({message: 'Business already exist'})
            }
        }else{
            return res.status(402).send(msg);
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor newEmpresaMaestro'});
    }
}

exports.putEmpresaMaestro = async(req, res) => {
    try{
        const empresaId = req.params.idEmpresa;
        const empreMaestro = await nombreEmpresaExist();
        const maestroExist = await empresasMaestros();
        const empresa = maestroExist.find(empresa => empresa.codigoEmpresa == req.params.idEmpresa);
        const already = maestroExist.find(empresa => empresa.nombreEmpresa === req.body.nombreEmpresa);
        if(!empresa) return res.status(404).send({message: 'Business not found'});
        if(already) {
            res.status(409).send({message: 'Business already exist'});
        }else{
            const body = req.body;
            const data = {
                nombreEmpresa: body.nombreEmpresa,
                nombreComercial: body.nombreComercial,
                direccionEmpresa: body.direccionEmpresa,
                NITEmpresa: body.NITEmpresa,
                porcentajeIVA: body.porcentajeIVA,
            };
            let updateEmpresa = `UPDATE EmpresaMaestro SET nombreEmpresa = '${data.nombreEmpresa}', nombreComercial = '${data.nombreComercial}', direccionEmpresa = '${data.direccionEmpresa}', NITEmpresa = '${data.NITEmpresa}', porcentajeIVA = '${data.porcentajeIVA}' WHERE codigoEmpresa = ${empresaId}`;
            await db.query(updateEmpresa, data, (err, result) => {
                if(err) throw err;
                return res.status(200).send({message: 'Business updated', data});
            });
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor putEmpresaMaestro'});
    }
}

exports.empresasMaestros = async(req, res) => {
    try{
        let getEmpresasMaestros = 'SELECT * FROM EmpresaMaestro';
        db.query(getEmpresasMaestros, (err, result) => {
            if(err) throw err;
            return res.status(200).send({message: 'Businesses', result});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor empresasMaestros'});
    }
}

exports.empresaById = async(req, res) => {
    try{
        const empresaId = req.params.idEmpresa;
        const empresaExist = await empresasMaestros();
        const empresa = empresaExist.find(empresa => empresa.codigoEmpresa == empresaId);
        if(!empresa) return res.status(404).send({message: 'Business not found'});
        return res.status(200).send({message: 'Business found', empresa});
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor empresaById'});
    }
}

exports.deleteEmpresa = async(req, res) => {
    try{
        const empresaId = req.params.idEmpresa;
        const empresaExist = await empresasMaestros();
        const empresa = empresaExist.find(empresa => empresa.codigoEmpresa == empresaId);
        if(!empresa) {
            return res.status(404).send({message: 'Business not found'});
        }else{
            let deleteEmpresa = `DELETE FROM EmpresaMaestro WHERE codigoEmpresa = ${empresaId}`;
            await db.query(deleteEmpresa, (err, result) => {
                if(err) throw err;
                return res.status(200).send({message: 'Business deleted', empresa});
            })
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor deleteEmpresa'})
    }
}