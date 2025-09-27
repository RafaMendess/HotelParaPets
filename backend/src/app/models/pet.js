'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Pet extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Pet.init({
    nome_tutor: DataTypes.STRING,
    contato_tutor: DataTypes.STRING,
    especie: DataTypes.ENUM('Cachorro', 'Gato'),
    raca: DataTypes.STRING,
    data_entrada: DataTypes.DATEONLY,
    data_saida: DataTypes.DATEONLY
  }, {
    sequelize,
    modelName: 'Pet',
  });
  return Pet;
};