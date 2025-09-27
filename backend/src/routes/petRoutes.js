const {Router} = require('express');
const petController = require('../controllers/petController');

const routes = new Router();

routes.get('/health', (req, res) => {
  res.status(200).json({ message: 'Servidor rodando!' });
});


routes.post('/pets', petController.store);
routes.get('/pets', petController.index);
routes.delete('/pets/:id', petController.delete);
routes.put('/pets/:id', petController.update);

module.exports = routes;