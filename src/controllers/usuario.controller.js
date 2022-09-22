"use strict";

const base = require("../../configs/mysql");
const db = base.connection;
const {validateData, userExist, encrypPassword} = require('../utils/validate.utils');

exports.test = (req, res) => {
  return res.send({ message: "Test user controller is running" });
};

exports.newUser =  (req, res) => {
    try{
        const body = req.body;
        const data = {
            nombre: body.nombre,
            apellido: body.apellido,
            username: body.username,
            correo: body.correo,
            claveUsuario: body.claveUsuario,
            roleUser: 'CLIENT'
        };
        let msg = validateData(data);
        if(!msg) {
            const exists = userExist(body.username)
            if(!exists){
                data.claveUsuario = encrypPassword(body.claveUsuario);
                let userNew= 'CALL sp_PostUsuario(?)'
                db.query(userNew, data, (error, result) => {
                    if(error) throw error;
                    return res.status(201).send({message: 'User created', result});
                })
            }else{
                return res.status(409).send({message: 'User already exists'})
            }
        }else{
           return res.status(402).send(msg);
        }
    }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor newUser'});
    }
}




exports.users = (req, res) => {
  try {
    let getUsers = "SELECT * FROM Usuario";
    db.query(getUsers, (err, result) => {
      if (err) throw err;
      if (result.length > 0)
        return res.status(200).send({ message: "Users", result});
    });
  } catch (err) {
    console.log(err);
    return res.status(500).send({ message: "Error en el servidor (getUsers)" });
  }
};
