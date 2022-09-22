'use strict'

const bcrypt = require('bcrypt-nodejs');
const base = require('../../configs/mysql');
const db = base.connection;

exports.validateData = (data) => {
    let keys = Object.keys(data), msg= '';
    for(let key of keys) {
        if(data[key] !== null && data[key] !== undefined && data[key] !== '') continue;
        msg +=  `The params ${key} is required \n`
    }
    return msg.trim();
}

exports.userExist = (username) => {
    try{
        const exist = 'SELECT U.username FROM Usuario U WHERE username = username';
        const userExist = db.query(exist, (error, result) => {
            if(error) throw error;
             return userExist
        })
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error in userExist'});
    }
}


exports.encrypPassword = async(password) => {
    try{
       return bcrypt.hashSync(password);
    }catch(err){
        console.log(err);
        return res.status(500).send({message: 'Error encryptPassword'});
    }
}