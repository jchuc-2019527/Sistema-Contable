'use strict'

const jwt = require('jwt-simple');
const key = 'SecretKey';

exports.ensureAuth = async(req, res, next) => {
    if(req.headers.authorization) {
        try{
        let token = req.headers.authorization.replace(/['"]+/g, '');
        var payload = jwt.decode(token, key);
        }catch(err){
            console.log(err);
            return res.status(401).send({message: 'Token invalid or expired'});
        }
        req.user = payload;
        next();
    }else{
        return res.status(403).send({message: 'The request does not have the authentication header'})
    }
}

exports.isAdmin = async(req, res, next) => {
    try{

        const user = req.user;
        if(user === 'ADMIN') {
            return next();
        }else{ 
            return res.status(401).send({message: 'User not authorized'});
        }
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor isAdmin'})
    }
}