'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Pets', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      nome_tutor: {
        type: Sequelize.STRING
      },
      contato_tutor: {
        type: Sequelize.STRING
      },
      especie: {
         type: Sequelize.ENUM('Cachorro', 'Gato'),
          allowNull: false
      },
      raca: {
        type: Sequelize.STRING
      },
      data_entrada: {
        type: Sequelize.DATEONLY
      },
      data_saida: {
        type: Sequelize.DATEONLY
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Pets');
  }
};