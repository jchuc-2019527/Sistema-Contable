'use strict'

const jwt = require('jwt-simple');
const moment = require('moment');
const key = 'SecretKey';

exports.createToken = async(user) =>{
    try{
        const payload = {
            sub: user._codigoUsuario,
            nombre: user.nombre,
            apellido: user.apellido,
            username: user.username,
            correo: user.correo,
            role: user.role,
            iat: moment().unix(),
            exp: moment().add(5, 'hours').unix()
        }
        return jwt.encode(payload, key);
    }catch(err) {
        console.log(err);
        return err;
    }
}