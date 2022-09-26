'use strict'

const db = require('../../configs/pooldb');
const { validateData, impuestos, nameImpuesto} = require('../utils/validate.utils');


exports.test = (req, res) => {
    return res.status(200).send({message: 'Test impuestoAdicional controller is running'}); 
}

exports.newImpuesto = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            nombreImpuesto: body.nombreImpuesto,
            descripcionImpuesto: body.descripcionImpuesto,
            valorImpuesto: body.valorImpuesto
        };
        let msg = validateData(data);
        if(!msg) {
            const impuestoExist = await nameImpuesto();
            const impuesto = impuestoExist.find(nombreImpuesto => nombreImpuesto.nombreImpuesto === data.nombreImpuesto);
            if(!impuesto) {
                let newImpuesto = 'INSERT INTO ImpuestoAdicional SET ?';
                await db.query(newImpuesto, data,(err, resul) =>{
                    if(err) throw err;
                    return res.status(201).send({message: 'Taxes created', data});
                })
            }else{
                return res.status(409).send({message: 'Taxes alredy exist'});
            }
        }else{
            return res.status(402).send(msg);
        }
    }catch(err) {
        console.log(err)
        return res.status(500).send({message: 'Error en el servidor newImpuesto'})
    }
}

exports.putImpuesto = async(req, res) => {
    try{
        const taxeId = req.params.idTaxes;
        const impuestosExists = await impuestos();
        const nombreExist = await nameImpuesto();
        const impuesto = impuestosExists.find(impuesto => impuesto.codigoValorImpuesto == req.params.idTaxes);
        const already = nombreExist.find(name => name.nombreImpuesto === req.body.nombreImpuesto);

        if(!impuesto) return res.status(404).send({message: 'Taxes not found'});
        if(already) {
            return res.status(409).send({message: 'Taxes alredy exist'});
        }else {
            const body = req.body;
            const data = {
                nombreImpuesto: body.nombreImpuesto,
                descripcionImpuesto: body.descripcionImpuesto,
                valorImpuesto: body.valorImpuesto
            };
            let updateImpuesto = `UPDATE ImpuestoAdicional SET nombreImpuesto = '${data.nombreImpuesto}', descripcionImpuesto = '${data.descripcionImpuesto}', valorImpuesto ='${data.valorImpuesto}' WHERE codigoValorImpuesto = ${taxeId}`;
            await db.query(updateImpuesto, data, (err, resul) => {
                if(err) throw err;
                return res.status(200).send({message: 'Taxes updated', data});
            })
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor PutTaxes'});
    }
}

exports.taxes = async(req, res) => {
    try{
        let getTaxes = 'SELECT * FROM ImpuestoAdicional';
        await db.query(getTaxes, (err, result) => {
            if(err) throw err;
            return res.status(200).send({Messaga: 'Taxes', result});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor taxes'});
    }
} 

exports.taxeById = async(req, res) => {
    try{
        let taxeId = req.params.idTaxe;
        let taxesExists = await impuestos();
        let impuesto = taxesExists.find(impuesto => impuesto.codigoValorImpuesto == taxeId);
        if(!impuesto) return res.status(404).send({Message: 'Taxe not found'});
        return res.status(302).send({Message: 'Taxe found', impuesto});
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor taxesById'});
    }
}

exports.deleteTaxe = async(req, res) => {
    try{
        let taxeId = req.params.idTaxe;
        let taxeExist = await impuestos();
        let taxe = taxeExist.find(taxe => taxe.codigoValorImpuesto == taxeId);
        if(!taxe) {
            return res.status(404).send({Message: 'Taxe not found'});
        }else{
            let deleteTaxe = `DELETE FROM ImpuestoAdicional WHERE codigoValorImpuesto = ${taxeId}`;
            await db.query(deleteTaxe, (err, resul) => {
                if(err) throw err;
                return res.status(200).send({Message: 'Taxe deleted', taxe});
            })
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor deleteTaxe'});
    }
}