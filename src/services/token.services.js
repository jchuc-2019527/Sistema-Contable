'use strict'

const jwt = require('jwt-simple');
const moment = require('moment');
const key = 'Secret Key';

exports.createToken = async(usuario) =>{
    try{
        const payload = {
            sub: usuario._codigoUsuario,
            nombre: usuario.nombre,
            apellido: usuario.apellido,
            username: usuario.username,
            correo: usuario.correo,
            role: usuario.role,
            iat: moment().unix(),
            exp: moment().add(5, 'hours').unix()
        }
        return jwt.encode(payload, key);
    }catch(err) {
        console.log(err);
        return err;
    }
}