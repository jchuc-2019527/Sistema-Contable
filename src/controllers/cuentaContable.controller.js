'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, nombreCuenta, cuentasContables} = require('../utils/validate.utils');


exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test cuentaContable controller is runnig'});
}

exports.newCuentaContable = async(req, res) => {
    try{
       const body = req.body;
       const data = {
        cuenta: body.cuenta,
        nombreCuenta: body.nombreCuenta,
        concentra: body.concentra,
        resultado: body.resultado,
        nivel: body.nivel,
        detalle: body.detalle,
        codigoEmpresa: req.params.idEmpre
       };
       let msg = validateData(data);
       if(!msg) {
        const empreId = req.params.idEmpre;
        const empresaExi = await empresasMaestros();
        const nombreCu = await nombreCuenta();
        const cuentaContable = await cuentasContables();
        const newNombre = nombreCu.find(name => name.nombreCuenta === req.body.nombreCuenta);
        const empreCuenta = cuentaContable.find(id => id.codigoEmpresa == req.params.idEmpre);
        const empresa = empresaExi.find(empre => empre.codigoEmpresa == empreId);
        if(!empresa) return res.status(404).send({Message: 'Business not exist'});
        if(!empreCuenta && newNombre) {
            let inner = `select EmpresaMaestro.nombreEmpresa  FROM EmpresaMaestro INNER JOIN CuentaContable ON EmpresaMaestro.codigoEmpresa = CuentaContable.codigoCuentaC WHERE EmpresaMaestro.codigoEmpresa = ${empreId}`;
            let newCuenta = 'INSERT INTO CuentaContable SET ?';
            await db.query(newCuenta,data, (err, resu) => {
                if(err) throw err;
                 db.query(inner, (err, resu) => {
                    if(err) throw err;
                    return res.status(201).send({Message: 'Cuenta contable creada', resu, data})
                })
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

exports.cuentasContables = async(req, res) => {
    try{
        let cuenta = 'SELECT * FROM CuentaContable';
        let cuentas = await cuentasContables();
       let permission = cuentas.find(cuenta => cuenta.codigoEmpresa == req.user.sub);
      console.log('soy el sub',req.user.sub)
        await db.query(cuenta, (err, result) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Leadges accounts', permission});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor cuentasContables'});
    }
}