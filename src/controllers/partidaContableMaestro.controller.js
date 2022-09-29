'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, partidasMaestro } = require('../utils/validate.utils');

exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test partidaMaestro controller is running'})
}

exports.newPartidaMaestro = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            codigoEmpresa: req.params.idEmpre,
            numeroPartidaContable: body.numeroPartidaContable,
            fechaPartidaContable:  body.fechaPartidaContable,
            montoDebePartidaContable: body.numeroPartidaContable,
            montoHaberPartidaContable: body.montoHaberPartidaContable,
            caracteristicas: body.caracteristicas
        };
        let msg = validateData(data);
        if(!msg) {
            let empreExi = req.params.idEmpre;
            let partidaId = await empresasMaestros();
            let partida = partidaId.find(empre => empre.codigoEmpresa == empreExi);
            if(!partida) return res.status(404).send({Message: 'Business not found'});
            let partidaNew = 'INSERT INTO PartidaContableMaestro SET ?';
            await db.query(partidaNew, data, (err, resu) => {
                if(err) throw err;
                return res.status(201).send({Message: 'Account part created', data});
            })
        }else{
            return res.status(403).send(msg);
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Erro en el sercidor newPartidaMaestro'});
    }
}

exports.partidasMaestro = async(req, res) => {
    try{
        let partidas = 'SELECT * FROM PartidaContableMaestro';
        db.query(partidas, (err, resu) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Accounts part found', resu});
        })
    }catch(err) {
        console.log(err)
        return res.status(500).send({Message: 'Error en el servidor partidasContables'})
    }
 }

exports.partidaById = async(req, res) => {
    try{
        const partidaId = req.params.idPartida;
        const partidaExist = await partidasMaestro();
        const partida = partidaExist.find(partida => partida.codigoPartidaContableMaestro == partidaId);
        if(!partida) return res.status(404).send({Message: 'Accound part not found'});
        return res.status(200).send({Message: 'Account part found', partida})
    }catch(err) {
        console.log(err)
        return res.status(500).send({Message: 'Error en el servidor partidaById'})
    }
}


exports.putPartida = async(req, res) => {
    try{
        let partidaId =req.params.idPartida;
        let partidaExist = await partidasMaestro();
        let partida = partidaExist.find(partida => partida.codigoPartidaContableMaestro == partidaId);
        if(!partida) {
            return res.status(404).send({Message: 'Account part not found'});
        }else{
        const body = req.body;
        const data = {
            numeroPartidaContable: body.numeroPartidaContable,
            fechaPartidaContable:  body.fechaPartidaContable,
            montoDebePartidaContable: body.numeroPartidaContable,
            montoHaberPartidaContable: body.montoHaberPartidaContable,
            caracteristicas: body.caracteristicas
        };
         let updateEmpresa = `UPDATE PartidaContableMaestro SET numeroPartidaContable = '${data.numeroPartidaContable}', fechaPartidaContable = '${data.fechaPartidaContable}', montoDebePartidaContable = '${data.montoDebePartidaContable}', montoHaberPartidaContable = '${data.montoHaberPartidaContable}', caracteristicas = '${data.caracteristicas}' WHERE codigoPartidaContableMaestro = ${partidaId}`;
        await db.query(updateEmpresa, data, (err, resu) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Account part updated', data})
        })
    }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor putPartida'});
    }
}

exports.deletePartida = async(req, res) => {
    try{
        const partidaId = req.params.idPartida;
        const partidaExist = await partidasMaestro();
        const partida = partidaExist.find(partida => partida.codigoPartidaContableMaestro == partidaId);
        if(partida) {
            let deletePartida = `DELETE FROM PartidaContableMaestro WHERE codigoPartidaContableMaestro = ${partidaId}`;
            await db.query(deletePartida, (err, resu) => {
                if(err) throw err;
                return res.status(200).send({Message: 'Account part deleted', partida});
            })
        }else{
            return res.status(404).send({Message: 'Account not found'})
        }
    }catch(err) {
        console.log(err)
        return res.status(500).send({Message: 'Error en el servidor deletePartida'})
    }
}