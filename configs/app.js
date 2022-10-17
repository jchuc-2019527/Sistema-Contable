'use strict'

//Config dep
const bodyParser = require('body-parser');
const express = require('express');
const helmet = require('helmet');
const cors =require('cors');
const port = process.env.PORT || 3200;
const app = express();

//Routes
const userRoutes = require('../src/routes/usuario.routes');
const empresaMaestroRoutes = require('../src/routes/empresaMaestro.routes');
const entidadRoutes = require('../src/routes/entidad.routes');
const impuestoAdicionalRoutes = require('../src/routes/impuestoAdicional.routes');
const tipoMovimientoLibroComprasVentasRoutes = require('../src/routes/tipoMovimientoLibroComprasVenats.routes');
const cuentaContableRoutes = require('../src/routes/cuentaContable.routes');
const plantillaContableMaestro = require('../src/routes/plantillaContableMaestro.routes');
const partidaContableMaestro = require('../src/routes/partidaContableMaestro.routes');
const partidaContableDetalle =require('../src/routes/partidaContableDetalle.routes');
const periodoRoutes = require('../src/routes/periodo.routes');
const activoFijoRoutes = require('../src/routes/activoFijo.routes');

//Config client
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.use(helmet({}));
app.use(cors());


//Usage routes client
app.use('/user', userRoutes);
app.use('/empresaMaestro', empresaMaestroRoutes);
app.use('/entidad', entidadRoutes);
app.use('/impuesto', impuestoAdicionalRoutes);
app.use('/tipoMovimiento', tipoMovimientoLibroComprasVentasRoutes);
app.use('/cuenta', cuentaContableRoutes);
app.use('/contableMaestro', plantillaContableMaestro);
app.use('/partidaMaestro', partidaContableMaestro);
app.use('/partidaDetalle', partidaContableDetalle);
app.use('/periodo', periodoRoutes);
app.use('/activoFijo', activoFijoRoutes);

//Initial routes
app.get('/', (req, res) => {
    return res.status(200).send({message: 'Welcome to turboCash'});
});

app.get('/**', (req, res) => {
    return res.status(404).send({message: 'Endpoint not found'});
});


//Export server express
exports.initServer = () => app.listen(port, () => {
    console.log(`Listening on port ${port}`)
});