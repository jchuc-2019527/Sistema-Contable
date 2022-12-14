'use strict'

const bcrypt = require('bcrypt-nodejs');
const db = require('../../configs/pooldb');


exports.validateData = (data) => {
    let keys = Object.keys(data), msg= '';
    for(let key of keys) {
        if(data[key] !== null && data[key] !== undefined && data[key] !== '') continue;
        msg +=  `The req.body.${key} is required \n`
    }
    return msg.trim();
}

exports.existUsername = () => {
    try{
        const exist = 'SELECT U.username FROM Usuario U';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resu) => {  
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err 
    }
}

exports.usersExists= () => {
    try{
        const exist = 'SELECT * FROM Usuario';
        return new Promise((resolve, reject) => {
            db.query(exist,(err, resu) => {  
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err 
    }
}

exports.nombreEmpresaExist = () => {
    try{
        const empresaExist = 'SELECT E.nombreEmpresa FROM EmpresaMaestro E';
        return new Promise((resolve, reject) => {
            db.query(empresaExist, (err, resu) => {
                if(err) throw err;
                return resolve(resu);
            })
        })
    }catch(err) {
     console.log(err);
     return err;   
    }
}

exports.empresasMaestros = () => {
    try{
        const empresaExist = 'SELECT * FROM EmpresaMaestro ';
        return new Promise((resolve, reject) => {
            db.query(empresaExist, (err, resu) => {
                if(err) throw err;
                return resolve(resu);
            })
        })
    }catch(err) {
     console.log(err);
     return err;   
    }
}

exports.encrypPassword = async(password) => {
    try{
       return await bcrypt.hashSync(password);
    }catch(err){
        console.log(err);
        return err;
    }
}

exports.checkPassword = async(password, hashSync) => {
    try{
        return await bcrypt.compareSync(password, hashSync)
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.existEntity = () => {
    try{
        const exist = 'SELECT E.nombreEntidad FROM Entidad E';
        return new Promise((resolve, reject) => {
            db.query(exist,(err, result) => {
                if(err) throw err;
                return resolve(result);
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.existNit = () => {
    try{
        const exist = 'SELECT E.NITEntidad FROM Entidad E';
        return new Promise((resolve, reject) => {
            db.query(exist,(err, result) => {
                if(err) throw err;
                return resolve(result);
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.entities = () => {
    try{
        const exist = 'SELECT * FROM Entidad';
        return new Promise((resolve, reject) =>{
            db.query(exist, (err, result) => {
                if(err) throw err;
                return resolve(result);
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.impuestos =() => {
    try{
        const exist = 'SELECT * FROM ImpuestoAdicional';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resul) => {
                if(err) throw err;
                return resolve(resul);
            })
        })
    }catch(err) {
        console.log(err)
        return err;
    }
}

exports.nameImpuesto = () => {
    try{
        const exist = 'SELECT I.nombreImpuesto FROM ImpuestoAdicional I'
        return new Promise((resolve, reject) =>{
            db.query(exist, (err, resul) => {
                if(err) throw err;
                return resolve(resul);
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.nameMovimiento = () => {
    try{
        const exist = 'SELECT T.nombreMovimiento FROM TipoMovimientoLibroComprasVentas T';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, result) => {
                if(err) throw err;
                return resolve(result)
            })
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({Message: 'Error en el servidor newMovimiento'});
    }
}

exports.movimientos = () => {
    try{
        const exist = 'SELECT * FROM TipoMovimientoLibroComprasVentas';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resul) => {
                if(err) throw err;
                return resolve(resul);
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}
exports.nombreCuenta = () => {
    try{
        let exist = 'SELECT C.nombreCuenta FROM CuentaContable C';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resu) => {
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.cuentasContables = () => {
    try{
        let exist = 'SELECT * FROM CuentaContable';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resu) => {
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.partidasMaestro = () => {
    try{
        let exist = 'SELECT * FROM PartidaContableMaestro';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resu) => {
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.empresaPartida = () => {
    try{    
        let exist = 'SELECT codigoEmpresa FROM PartidaContableMaestro';
        return new Promise((resolve, reject) => {
            db.query(exist, (err, resu) => {
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.detallesPartida = () => {
    try{
        let detalle = 'SELECT * FROM PartidaContableDetalle';
        return new Promise((resolve, reject) => {
            db.query(detalle, (err, resu) => {
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err)
        return err;
    }
}

exports.periodos = async(req, res) => {
    try{
        let periodos = 'SELECT * FROM Periodo';
        return new Promise((resolve, reject) => {
         db.query(periodos, (err, resu) => {
            if(err) throw err;
            return resolve(resu);
         })  
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}

exports.activos = () =>{
    try{
        const exist = 'SELECT * FROM ActivoFijo';
        return new Promise ((resolve, reject) =>{
            db.query(exist, (err, resul) => {
                if(err) throw err;
                return resolve(resul);
            })
        })
    }catch(err) {
        console.log(err);
        return err;
    }
}