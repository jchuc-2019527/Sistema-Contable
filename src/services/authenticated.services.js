'use strict'

const jwt = require('jwt-simple');
const key = 'clave_secreta';

exports.ensureAuth = async(req, res, next) => {
    if(req.headers.authorization) {
        try{
        let token = req.headers.authorization.replace(/['"]+/g, '');
        var payload = jwt.decode(token, key);
        }catch(err){
            console.log(err);
            return res.status(500).send({message: 'Token invalid or expired'});
        }
        req.user = payload;
        next();
    }else{
        return res.status(403).send({message: 'The request does not have the authentication header'})
    }
}