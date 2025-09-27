const express = require("express");
const sequelize = require("./config/config");
const routes = require("./routes/petRoutes");
const cors = require("cors");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(routes);


async function startServer() {
  try {
    await sequelize.authenticate();
    console.log(" Conectado ao banco com sucesso!");
    app.listen(3000, () => console.log(` Server started on port ${3000}`));
  } catch (err) {
    console.error("Erro ao conectar no banco:", err);
  }
}
startServer();