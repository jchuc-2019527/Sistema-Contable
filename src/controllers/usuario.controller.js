"use strict";

const db = require("../../configs/pooldb");
const {validateData, existUsername, encrypPassword, checkPassword, usersExists} = require('../utils/validate.utils');
const {createToken} = require('../services/token.services');

exports.test = (req, res) => {
  return res.status(200).send({ message: "Test user controller is running" });
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
          const usernameExist = await existUsername()
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
      const users = await usersExists();
      const existUser = users.find(user => user.username === data.username);
      const username = await existUsername()
      const us = username.find(user => user.username === data.username);
      if(us && await checkPassword(data.claveUsuario, existUser.claveUsuario)) {
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
    const userId = req.params.idUser;
    const userExist = await usersExists();
    const userUserna = await existUsername();
    const user = userExist.find(user => user.codigoUsuario == req.params.idUser);
    const already = userUserna.find(user => user.username === req.body.username);
    if(!user) return res.status(404).send({message: 'User not found'});
    if(already) {
      return res.status(404).send({message: 'Username already use'});
    }else{
      const body = req.body;
      const data = {
        nombre: body.nombre,
        apellido: body.apellido,
        username: body.username,
        correo: body.correo,
        claveUsuario: await encrypPassword(body.claveUsuario),
      };
        let updateUser = `UPDATE Usuario SET nombre = '${data.nombre}', apellido = '${data.apellido}', username = '${data.username}', 
          correo = '${data.correo}', claveUsuario = '${data.claveUsuario}' WHERE codigoUsuario = ${userId}`;
        await db.query(updateUser, data, (err, result) => {
          if(err) throw err;
          return res.status(200).send({message: 'User updated', data});
        });
    }
  }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor puUser'})
  }
}

exports.deleteUser = async(req, res) => {
  try{
    const userId = req.params.idUser;
    const userExist = await usersExists();
    const user = userExist.find(user => console.log(user.codigoUsuario == userId));
   if(!user) {
      return res.status(404).send({message: 'User not found'});
   }else{
    let deleteUser = `DELETE FROM Usuario WHERE codigoUsuario = ${userId}`;
    await db.query(deleteUser, (err, result) => {
      if(err) throw err;
      return res.status(200).send({message: 'User deleted', user})
    })
   }
  }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor deleteUser'})
  }
}

exports.userById = async(req, res) => {
  try{
    const userId = req.params.idUser;
    const userExist = await usersExists();
    const user = userExist.find(user => user.codigoUsuario == userId);
    if(!user) {
      return res.status(404).send({message: 'User not found'});
    }else{
      return res.status(302).send({message: 'User found', user})
    }
  }catch(err) {
    console.log(err);
    return res.status(500).send({message: 'Error en el servidor userById'})
  }
}

exports.users = (req, res) => {
  try {
    let getUsers = "SELECT * FROM Usuario";
    db.query(getUsers, (err, result) => {
      if (err) throw err;s
        return res.status(200).send({ message: "Users", result});
    });
  } catch (err) {
    console.log(err);
    return res.status(500).send({ message: "Error en el servidor (getUsers)" });
  }
};
