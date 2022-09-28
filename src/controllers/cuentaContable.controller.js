'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, nombreCuenta, cuentasContables, usersExists} = require('../utils/validate.utils');


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

exports.putCuentaContable = async(req, res) => {
    try{
       const cuentaId = req.params.idCuenta;
       const cuentasExist = await cuentasContables();
       const cuenta = cuentasExist.find(cuenta => cuenta.codigoCuentaC == req.params.idCuenta);
       const already = cuentasExist.find(cuenta => cuenta.nombreCuenta === req.body.nombreCuenta);
       if(!cuenta) return res.status(404).send({Message: 'Leadge not found'});
       if(already) {
        res.status(409).send({Message: 'Leadge already exist'});
       }else{
        const body = req.body;
        const data = {
            cuenta: body.cuenta,
            nombreCuenta: body.nombreCuenta,
            concentra: body.concentra,
            resultado: body.resultado,
            nivel: body.nivel,
            detalle: body.detalle
        };
        let updateCuenta = `UPDATE CuentaContable SET cuenta = '${data.cuenta}', nombreCuenta = '${data.nombreCuenta}', concentra = '${data.concentra}', resultado = '${data.resultado}', nivel = '${data.nivel}', detalle = '${data.detalle}' WHERE codigoEmpresa = ${cuentaId}`;
        await db.query(updateCuenta, data, (err, result) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Leadge updated', data});
        })
       }
    }catch(err) {
        console.log(err)
        return res.status(500).send({Message: 'Error en el servidor putCuentaContable'})
    }
}

exports.cuentaById = async(req, res) => {
    try{
        const cuentaId = req.params.idCuenta;
        const cuentaExist = await cuentasContables();
        const cuenta = cuentaExist.find(cuenta => cuenta.codigoCuentaC == cuentaId);
        if(!cuenta) return res.status(404).send({Message: 'Leadge not found'});
        return res.status(200).send({Message: 'Leadge found', cuenta})
    }catch(err) {
        console.log(err)
        return res.status(500).send({Message: 'Error en el servidor cuentaById'});
    }
}

exports.deleteCuenta = async(req, res) => {
    try{
        const cuentaId = req.params.idCuenta;
        const cuentaExi = await cuentasContables();
        const cuenta = cuentaExi.find(cuenta => cuenta.codigoCuentaC == cuentaId);
        if(!cuenta) {
            return res.status(404).send({Message: 'Leadge not found'});
        }else{
            let deleteCuenta = `DELETE FROM CuentaContable WHERE codigoCuentaC = ${cuentaId}`;
            await db.query(deleteCuenta, (err, resul) => {
                if(err) throw err;
                return res.status(500).send({Message: 'Leadge deleted', cuenta})
            })
        }
    }catch(err) {
        console.log(err)
        return res.status(500).send({Message: 'Error en el servidor deleteCuenta'});
    }
}