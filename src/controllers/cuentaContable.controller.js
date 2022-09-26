'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, nombreCuenta } = require('../utils/validate.utils');

exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test cuentaContable controller is runnig'});
}

exports.newCuentaContable = async(req, res) => {
    try{
       const body = req.body;
       const data = {
        codigoCuentaContable: body.codigoCuentaContable,
        codigoEmpresa: body.codigoEmpresa,
        nombreCuentaContable: body.nombreCuentaContable,
        tipoCuentaContable: body.tipoCuentaContable,
        padreCuentaContable: body.padreCuentaContable,
        nivelCuentaContable: body.nivelCuentaContable,
        recibePartidasCuentaContable: body.recibePartidaCuentaContable
       };
       let msg = validateData(data);
       if(!msg) {
        const empreId = req.params.idEmpre;
        const empresaExi = await empresasMaestros();
        const nombreCu = await nombreCuenta();
        const newNombe = nombreCu.find(name => name.nombreCuentaContable === req.body.nombreCuentaContable);
        const empresa = empresaExi.find(empre => empre.codigoEmpresa == empreId);
        if(!empresa) return res.status(404).send({Message: 'Business not exist'});
        if(!newNombe) {
            let newCuenta = 'INSERT INTO CuentaContable SET ?';
            await db.query(newCuenta, data, (err, resu) => {
                if(err) throw err;
                return res.status(201).send({Message: 'Leadge created', data});
            })
        }else {
            return res.status(409).send({Message: 'Ledger account already exist'});
        }
       }else{
        return res.status(402).send(msg);
       }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor newCuentaContable'});
    }
}