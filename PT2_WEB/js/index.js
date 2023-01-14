import express from 'express' //Importar express
import bodyParser from 'body-parser' //Importar librería bodyparser
import {agregarCliente,agregarPedido} from './mysql_conector.js' //Importar conector de mysql


const app = express() //Iniciar express

//Iniciamos servidor
app.listen('8000', () => {
    console.log('aplicacion iniciada puerto 8000')
})

//Configurando archivos estáticos
app.use(express.static('./'))

/* Uso la librería BodyParser como midleware para administrar los formularios html*/
app.use(bodyParser.urlencoded({ extended: false }))

/* Recojo el formulario de login enviado por método post */
app.post('/login', (req, res) => {
    let nombre = req.body.nombre
    let apellidos = req.body.apellidos
    let direccion = req.body.direccion
    let email = req.body.email
    let telefono = req.body.telefono

    agregarCliente(nombre, apellidos, email, direccion, telefono)
  
    res.redirect('/registered.html') 
})


/* Recojo el objeto pedido enviado desde el cliente y lo convierto en objeto de js */
app.get('/pedir/:pedidoJSON', (req, res) => {

    let pedido = JSON.parse(req.params.pedidoJSON)

    agregarPedido(pedido)//Inserción en la base de datos

    res.redirect('/ordered.html') 

})

