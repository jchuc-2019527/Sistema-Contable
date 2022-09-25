'use strict'

const jwt = require('jwt-simple');
const moment = require('moment');
const key = 'SecretKey';

exports.createToken = async(usuario) =>{
    try{
        const payload = {
            sub: usuario.codigoUsuario,
            nombre: usuario.nombre,
            apellido: usuario.apellido,
            username: usuario.username,
            correo: usuario.correo,
            roleUser: usuario.roleUser,
            iat: moment().unix(),
            exp: moment().add(5, 'hours').unix()
        }
        return jwt.encode(payload, key);
    }catch(err) {
        console.log(err);
        return err;
    }
}