'use strict'

const db = require('../../configs/pooldb');
const { validateData, empresasMaestros, activos } = require('../utils/validate.utils');


exports.testActivo = (req, res) =>{
    return res.status(200).send({Message: 'Test activoFijo controller is running'});
}

exports.newActivoFijo = async(req, res) =>{
    try{
        const body = req.body;
        const data = {
            fechaAdquisicion: body.fechaAdquisicion,
            numeroDocumento: body.numeroDocumento,
            NITEntidad: body.NITEntidad,
            codigoTipo: body.codigoTipo,
            descripcionActivoFijo: body.descripcionActivoFijo,
            cantidadActivoFijo: body.cantidadActivoFijo,
            valorUnitario: body.valorUnitario,
            valorTotal: body.valorTotal,
            valorActual: body.valorActual,
            depreciacionAcumulada: body.depreciacionAcumulada,
            caracteristicasActivoFijo: body.caracteristicasActivoFijo,
            codigoEmpresa: req.params.idEmpre
        };
        let msg = validateData(data);
        if(!msg) {
            const id = req.params.idEmpre;
            const empresaId = await empresasMaestros();
            const empresaExiste = empresaId.find(id => id.codigoEmpresa == req.params.idEmpre)
            console.log(empresaExiste);
            if(!empresaExiste){
                return res.status(404).send({Message: 'Business not found'})
            }else{
                let activo = 'INSERT INTO ActivoFijo SET ?';
                await db.query(activo, data, (error, result) => {
                    if(error) throw error;
                    let inner = `SELECT EmpresaMaestro.nombreEmpresa FROM EmpresaMaestro INNER JOIN ActivoFijo ON EmpresaMaestro.codigoEmpresa = ActivoFijo.codigoEmpresa WHERE EmpresaMaestro.codigoEmpresa = ${id}`;
                    db.query(inner, (err, resul) => {
                        if(err) throw err;
                        return res.status(201).send({Message: 'Activo fijo creado', resul, data});
                    })
                })
            }
        }else{
            return res.status(402).send(msg);
        }
    }catch(err){
        consople.log(err);
        return res.status(500).send({Error: 'Error en el servidor (newActico)'});
    }
}

exports.activosFijos = async(req, res) => {
    try{
        let activosF = await activos();
        let activosFijos ='SELECT * FROM ActivoFijo';
        let permission = activosF.find(id => id.codigoEmpresa == req.user.sub);
        await db.query(activosFijos, (err, resu) =>{
            if(err) throw err;
            return res.status(200).send({Message: 'Activos fijos', resu});
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Error: 'Error en el servidor (activosFijos)'});
    }
}

exports.activoId = async(req, res) => {
    try{
        let activoId = req.params.idActivo;
        let activosF = await activos();
        const activo = activosF.find(id => id.codigoActivoFijo == activoId);
        if(!activo) return res.status(404).send({Message: 'Activo fijo no encontrado'});
        return res.status(200).send({Message: 'Activo fijo encontrado', activo});
    }catch(err) {
        console.log(err);
        return res.status(500).send({Error: 'Error en el servidor (activoId)'});
    }
}

exports.putActivo = async(req, res) => {
    try{
        
    }catch(err) {
        console.log(err);
        return res.status(500).send({Error: 'Error en el servidor (putActivo)'});
    }
}