"use strict";

const db = require("../../configs/pooldb");
const {validateData, userExist, encrypPassword, checkPassword, passwordExists} = require('../utils/validate.utils');
const {createToken} = require('../services/token.services');

exports.test = (req, res) => {
  return res.send({ message: "Test user controller is running" });
};

exports.newUser = async(req, res) => {
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
          const usernameExist = await userExist()
          const user = usernameExist.find(username => username.username === data.username)
          if(!user) {
            data.claveUsuario = await encrypPassword(req.body.claveUsuario);
            let userNew = 'INSERT INTO Usuario SET ?';
             await db.query(userNew, data,(error, result) => {
              if(error) throw error;
              return res.status(201).send({message: 'User created', data})
            })
          }else{
            return res.status(409).send({message: 'User already use'})
          }
        }else{
           return res.status(402).send(msg);
        }
    }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor newUser'});
    }
}


exports.login = async(req, res) => {
  try{
    const body = req.body;
    const data = {
      username: body.username,
      claveUsuario: body.claveUsuario
    };
    let msg = validateData(data);
    if(!msg) {
      const users = await passwordExists();
      const existUser = users.find(user => user.username === data.username);
      const username = await userExist()
      const us = username.find(user => user.username === data.username);
      // console.log(us);
      if(us && await checkPassword(data.claveUsuario, existUser.claveUsuario)) {
        // return res.status(404).send({message: 'User not found'})
        // console.log('no existe el username')
        const token = await createToken(existUser);
        return res.status(202).send({token,message: 'Login success', existUser});
      }else{
        return res.status(403).send({message: 'Username or password incorrect'})
      }
    }else{
      return res.status(402).send(msg)
    }
  }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor login'})
  }
}




exports.putUser = async(req, res) => {
  try{
    // const body = req.body;

  }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor puUser'})
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
