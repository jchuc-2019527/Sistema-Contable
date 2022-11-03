"use strict";

const e = require("cors");
const db = require("../../configs/pooldb");
const {
  validateData,
  existEntity,
  entities,
  existNit,
} = require("../utils/validate.utils");

exports.test = (req, res) => {
  res.status(200).send({ message: "Tesr entity controller is running" });
};

exports.newEntity = async (req, res) => {
  try {
    const body = req.body;
    const data = {
      NITEntidad: body.NITEntidad,
      nombreEntidad: body.nombreEntidad,
    };
    let msg = validateData(data);
    if (!msg) {
      const nombreExist = await existEntity();
      const nitExist = await existNit();
      const entidad = nombreExist.find(
        (entidad) => entidad.nombreEntidad === data.nombreEntidad
      );
      const newNit = nitExist.find((nit) => nit.NITEntidad === data.NITEntidad);
      if (!entidad) {
        if (!newNit) {
          let entidadNew = "INSERT INTO Entidad SET ?";
          await db.query(entidadNew, data, (err, result) => {
            if (err) throw err;
            return res.status(201).send({ message: "Entity created", data });
          });
        }else{
            return res.status(403).send({message: 'NIT ya existe'});
        }
      }else{
        return res.status(403).send({message: 'Nombre de la empresa ya existe'})
      }
      return res.status(402).send(msg);
    }
  } catch (err) {
    console.log(err);
    return res.status(500).send({ message: "Error en el servidor newEntity" });
  }
};

exports.putEntity = async (req, res) => {
  try {
    const entityId = req.params.idEntity;
    const nombreExist = await existEntity();
    const entityExist = await entities();
    const entidad = entityExist.find(
      (entidad) => entidad.codigoNIT == req.params.idEntity
    );
    const already = nombreExist.find(
      (entidad) => entidad.nombreEntidad === req.body.nombreEntidad
    );
    if (!entidad) return res.status(404).send({ message: "Entity not found" });
    if (already) {
      return res.status(409).send({ message: "Entity already use" });
    } else {
      const body = req.body;
      const data = {
        NITEntidad: body.NITEntidad,
        nombreEntidad: body.nombreEntidad,
      };
      let updateEntity = `UPDATE Entidad SET NITEntidad = '${data.NITEntidad}', nombreEntidad = '${data.nombreEntidad}' WHERE codigoNIT = ${entityId}`;
      await db.query(updateEntity, data, (err, result) => {
        if (err) throw err;
        return res.status(200).send({ message: "Entity updated", data });
      });
    }
  } catch (err) {
    console.log(err);
    return res.status(500).send({ message: "Error en el servidor putEntity" });
  }
};

exports.deleteEntity = async (req, res) => {
  try {
    const entityId = req.params.idEntity;
    const entityExist = await entities();
    const entidad = entityExist.find(
      (entidad) => entidad.codigoNIT == req.params.idEntity
    );
    if (!entidad) {
      return res.status(404).send({ message: "Entity not found" });
    } else {
      let deleteEntity = `DELETE FROM Entidad WHERE codigoNIT = ${entityId}`;
      await db.query(deleteEntity, (err, result) => {
        if (err) throw err;
        return res.status(200).send({ message: "Entity deleted", entidad });
      });
    }
  } catch (err) {
    console.log(err);
    return res
      .status(500)
      .send({ message: "Error en el servidor deleteEntity" });
  }
};

exports.entities = async (req, res) => {
  try {
    let getEntidades = "SELECT * FROM Entidad";
    await db.query(getEntidades, (err, resul) => {
      if (err) throw err;
      return res.status(200).send({ message: "Entities", resul });
    });
  } catch (err) {
    console.log(err);
    return res.status(500).send({ message: "Error en el servidor entities" });
  }
};

exports.entityById = async (req, res) => {
  try {
    const entidadId = req.params.idEntity;
    const entityId =  `SELECT * from Entidad WHERE codigoNIT = ${entidadId}`;
    await db.query(entityId, (err, resu) => {
      if(err) throw err;
      return res.status(200).send({message: 'Entidad encontrada', resu})
    })
  } catch (err) {
    console.log(err);
    return res.status(500).send({ message: "Error en el servidor entityById" });
  }
};
