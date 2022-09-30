'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, cuentasContables, detallesPartida } = require('../utils/validate.utils');

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

exports.partidasDetalle = async(req, res) => {
    try{
        let detalle = 'SELECT * FROM PartidaContableDetalle';
        db.query(detalle, (err, resu) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Accounting item detais founds', resu});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor partidaDetalle'});
    }
}

exports.detalleById =  async(req, res) => {
    try{
        let detalleId = req.params.idDetalle;
        let detalleExist = await detallesPartida();
        let detalle = detalleExist.find(detalle => detalle.codigoPartidaContableMaestro == detalleId);
        if(!detalle) return res.status(404).send({Message: 'Accounting iterms details not found'});
        return res.status(200).send({Message: 'Accounting items details found', detalle});
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor detalleById'});
    }
}

exports.putDetalle = async(req, res) => {
    try{
        let partidaId = req.params.idDetalle;
        let partidaExist = await detallesPartida();
        let partida = partidaExist.find(detalle => detalle.codigoPartidaContableDetalle == partidaId);
        if(!partida) {
            return res.status(404).send({Message: 'Accounting item details not found'});
        }else{
            const body = req.body;
            const data = {
                codigoCuentaContable: body.codigoCuentaContable,
                numeroPartidaContable: body.numeroPartidaContable,
                correlativoPartidaContable: body.correlativoPartidaContable,
                tipoMovimientoPartidaContable: body.tipoMovimientoPartidaContable,
                montoCuentaContable: body.montoCuentaContable
            };
            let updateDetalle = `UPDATE PartidaContableDetalle SET codigoCuentaContable = '${data.codigoCuentaContable}', numeroPartidaContable = '${data.numeroPartidaContable}', correlativoPartidaContable = '${data.correlativoPartidaContable}, tipoMovimientoPartidaContable = '${data.tipoMovimientoPartidaContable}', montoCuentaContable = '${data.montoCuentaContable}' WHERE codigoPartidaContableDetalle = ${partidaId}`;
            await db.query(updateDetalle, data, (err, resu) => {
                if(err) throw err;
                return res.status(200).send({Message: 'Accounting item details updated', data});
            })
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor en el servidor putDetalle'});;
    }
}

exports.deleteDetalle =async(req, res) => {
    try{
        const detalleId = req.params.idDetalle;
        const detalleExist = await detallesPartida();
        const detalle = detalleExist.find(detalle => detalle.codigoPartidaContableDetalle == detalleId);
        if(detalle) {
            let deleteDetalle = `DELETE FROM PartidaContableDetalle WHERE codigoPartidaContableDetalle = ${partidaId}`;
            await db.query(deleteDetalle, (err, resu) => {
                if(err) throw err;
                return res.status(200).send({Message: 'Account item details deleted', detalle});
            })
        }else{
            return res.status(404).send({Message: 'Accounting iten details not found'});
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor deleteDetalle'});
    }
}