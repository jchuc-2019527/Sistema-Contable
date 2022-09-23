'use strict'

const bcrypt = require('bcrypt-nodejs');
const db = require('../../configs/pooldb')
exports.validateData = (data) => {
    let keys = Object.keys(data), msg= '';
    for(let key of keys) {
        if(data[key] !== null && data[key] !== undefined && data[key] !== '') continue;
        msg +=  `The req.body.${key} is required \n`
    }
    return msg.trim();
}

exports.userExist = (username) => {
    try{
        const exist = 'SELECT U.username FROM Usuario U';
        return new Promise((resolve, reject) => {
            db.query(exist, username, (err, resu) => {  
                if(err) throw err;
                return resolve(resu)
            })
        })
    }catch(err) {
        console.log(err);
        return err 
    }
}

exports.encrypPassword = async(password) => {
    try{
       return await bcrypt.hashSync(password);
    }catch(err){
        console.log(err);
        return res.status(500).send({message: 'Error encryptPassword'});
    }
}

exports.checkPassword = async(password, hashSync) => {
    try{
        return bcrypt.compareSync(password, hashSync)
    }catch(err) {
        console.log(err);
        return res.status(500).send({message: 'Error en el servidor checkPassword'});
    }
}