"use strict";

const db = require("../../configs/pooldb");
const {validateData, userExist, encrypPassword, checkPassword} = require('../utils/validate.utils');
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
          const usernameExist = await userExist(req.body.username)
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
      let search = await userExist(req.body.username);
      const userLogin = search.find(username => username.username === data.username)
      console.log(userLogin)
      if(userLogin && await checkPassword(body.claveUsuario, search.claveUsuario)) {
       const token = await createToken(search);
       return res.status(200).send({message: 'Log in successfuly', userLogin, token})
      }else{
        return res.status(400).send({message: 'Username or password incorrect'})
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
