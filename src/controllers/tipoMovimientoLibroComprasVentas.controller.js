'use strict'

const db =  require('../../configs/pooldb');
const { validateData, nameMovimiento, movimientos } = require('../utils/validate.utils');

exports.test = (req, res) => {
    return res.status(200).send({Message: 'Test tipoMovimientoLibroComprasVentas is running'});
}

exports.newTipoMov = async(req, res) => {
    try{
        const body = req.body;
        const data = {
            nombreMovimiento: body.nombreMovimiento,
            tipoLibro: body.tipoLibro,
            tipoMovimiento: body.tipoMovimiento
        };
        let msg = validateData(data);
        if(!msg) {
            const nombreMovExist = await nameMovimiento();
            const movimiento = nombreMovExist.find(name => name.nombreMovimiento === data.nombreMovimiento);
            if(!movimiento) {
                let newMov = 'INSERT INTO TipoMovimientoLibroComprasVentas SET ?';
                await db.query(newMov, data,(err, resul) => {
                    if(err) throw err;
                    return res.status(201).send({Message: 'Type movement created', data});
                })
            }else{
                return res.status(402).send({Message: 'Nombre del novimiento ya existe'});
            }
        }else{
            return res.status(402).send(msg);
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor newTipoMov'});
    }
}

exports.putMovimiento = async(req, res) => {
    try{
        const moveId = req.params.idMove;
        const nameMov = await nameMovimiento();
        const mov = await movimientos();
        const movFind = mov.find(movimiento => movimiento.codigoMovimiento == moveId);
        const already = nameMov.find(name => name.nombreMovimiento === req.body.nombreMovimiento);
        if(!movFind) return res.status(404).send({Message: 'Movement not found'});
        if(already) {
            return res.status(409).send({Message: 'Nombre del movimineto ya existe'});
        }else{
            const body = req.body;
            const data = {
                nombreMovimiento: body.nombreMovimiento,
                tipoLibro: body.tipoLibro,
                tipoMovimiento: body.tipoMovimiento
            };
            let updateMov = `UPDATE TipoMovimientoLibroComprasVentas SET nombreMovimiento = '${data.nombreMovimiento}', tipoLibro = '${data.tipoLibro}', tipoMovimiento = '${data.tipoMovimiento}' WHERE codigoMovimiento = ${moveId}`;
            await db.query(updateMov, data,(err, resul) => {
                if(err) throw err;
                return res.status(201).send({Message: 'Type movement created', data});
            })
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor putMovimiento'});
    }
}

exports.movements = async(req, res) => {
    try{
        let getMovements = 'SELECT * FROM TipoMovimientoLibroComprasVentas';
        await db.query(getMovements, (err, resu) => {
            if(err) throw err;
            return res.status(200).send({Message: 'Type Movements book purchases adn sales', resu});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor movements'});
    }
}

exports.movementById = async(req, res) => {
    try{    
        let moveId = req.params.idMove;
        const movementId = `SELECT * from TipoMovimientoLibroComprasVentas WHERE codigoMovimiento = ${moveId}`;
        await db.query(movementId, (err, resu) => {
            if(err) throw err;
            return res.status(200).send({message: 'Tipo Movimiento encontrado', resu})
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor movementById'});
    }
}

exports.deleteMov = async(req, res) => {
    try{
        const moveId = req.params.idMove;
        const moveExi = await movimientos();
        const movimiento = moveExi.find(movem => movem.codigoMovimiento == moveId);
        if(!movimiento) {
            return res.status(404).send({Message: 'Type movement not found'});
        }else{
            let deleteMov = `DELETE FROM TipoMovimientoLibroComprasVentas WHERE codigoMovimiento = ${moveId}`;
            await db.query(deleteMov, (err, resu) => {
                return res.status(200).send({Message: 'Type movement deleted', movimiento});
            })
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor deleteMov'});
    }
}
