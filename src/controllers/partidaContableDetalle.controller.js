'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, cuentasContables } = require('../utils/validate.utils');


exports.testD = (req, res) => {
    return res.status(200).send({Message: 'Test partidaContableDetalle controller is running'});
}

exports.newPartidaDetalle = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            codigoEmpresa: req.params.idEmpre,
            codigoCuentaContable: req.body.codigoCuentaContable,
            codigoPartidaContableMaestro: body.codigoPartidaContableMaestro,
            codigoCuentaContable: body.codigoCuentaContable,
            numeroPartidaContable: body.numeroPartidaContable,
            correlativoPartidaContable: body.correlativoPartidaContable,
            tipoMovimientoPartidaContable: body.tipoMovimientoPartidaContable,
            montoCuentaContable: body.montoCuentaContable
        };
        let msg = validateData(data); 
        if(!msg) { 
            let empreExi = req.params.idEmpre;
            let cuentaContable = req.params.idCuenta;
            let partidaDetalle = await empresasMaestros();
            let cuentas = await cuentasContables();
            let cuentasC = cuentas.find(cuenta => cuenta.codigoCuentaC == req.body.codigoCuentaContable);
            console.log(cuentasC)
            let detalle = partidaDetalle.find(partida => partida.codigoEmpresa == empreExi);
            if(!detalle && !cuentasC) return res.status(404).send({Message: 'Business or leadge account  not found'});
            let detalleNew = 'INSERT INTO PartidaContableDetalle SET ?';
            await db.query(detalleNew, data, (err, resu) => {
                if(err) throw err;
                return res.status(201).send({Message: 'Account part details created', data});
            })
        }else{
            return res.status(402).send(msg);
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor newPartidaPlantillaDetalle'});
    }
}