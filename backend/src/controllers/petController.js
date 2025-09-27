const db = require("../app/models");
const { sequelize, Pet } = db;
const { Op } = require("sequelize");

class petController {
  async store(req, res) {
    try {
      const {
        nome_tutor,
        contato_tutor,
        especie,
        raca,
        data_entrada,
        data_saida,
      } = req.body;

      if (!nome_tutor || !contato_tutor || !especie || !raca || !data_entrada) {
        return res.status(400).json("Os campos devem ser preenchidos");
      }

      const createdPet = await Pet.create({
        nome_tutor,
        contato_tutor,
        especie,
        raca,
        data_entrada,
        data_saida: data_saida || null,
      });
      return res.status(201).json(createdPet);
    } catch (error) {
      console.error(error);
      return res.status(400).json(" Falha ao cadastrar pet");
    }
  }

 async index(req, res) {
    try {
      const filtros = req.query || {}; 
      const where = {};

      if (Object.keys(filtros).length > 0) {
        for (const key in filtros) {
          if (!filtros[key]) continue;

          if (["nome_tutor", "contato_tutor", "raca"].includes(key)) {
            where[key] = { [Op.like]: `%${filtros[key]}%` };
          }

          if (["data_entrada", "data_saida","especie"].includes(key)) {
            where[key] = filtros[key];
          }
          
        }
      }

      const pets = await Pet.findAll({ where }); 
      return res.status(200).json(pets);
    } catch (error) {
      console.error(error);
      return res.status(400).json({ error: "Erro ao buscar pets" });
    }
  }

  
  async delete(req, res) {
    try {
      const { id } = req.params;
      const pet = await Pet.findByPk(id);
      if (!pet) {
        return res.status(404).json("Pet não encontrado");
      }
      await pet.destroy();
      return res.status(200).json("Pet deletado com sucesso");
    } catch (error) {
      console.error(error);
      return res.status(400).json("Falha ao deletar pet");
    }
  }

  async update(req, res) {
    try {
      const { id } = req.params;
      const {
        nome_tutor,
        contato_tutor,
        especie,
        raca,
        data_entrada,
        data_saida,
      } = req.body;
      const pet = await Pet.findByPk(id);
      if (!pet) {
        return res.status(404).json("Pet não encontrado");
      }
      pet.nome_tutor = nome_tutor || pet.nome_tutor;
      pet.contato_tutor = contato_tutor || pet.contato_tutor;
      pet.especie = especie || pet.especie;
      pet.raca = raca || pet.raca;
      pet.data_entrada = data_entrada || pet.data_entrada;
      pet.data_saida = data_saida || pet.data_saida;

      await pet.save();

      return res.status(200).json(pet);
    } catch (error) {
      console.error(error);
      return res.status(400).json("Falha ao atualizar pet");
    }
  }

 
}

module.exports = new petController();
