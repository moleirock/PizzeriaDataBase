//importar mysql
import mysql from 'mysql'


//crear conexion
const conector = mysql.createConnection(
    {
        host: 'localhost',
        user: 'Administrador',
        password: 'Admin.1234',
        database: 'pizzeria',
        port: '33066'  //Puerto cambiado por colisión con mysql local(Dentro de xampp se cambia el puerto en la configuración y en archivo my.ini )
    }
)


//Funciones de inserción

const agregarCliente = (nombre, apellidos, email, direccion, telefono) => {
    const sqlCliente = `INSERT INTO Cliente (Nombre,Apellidos,Email) VALUES ("${nombre}","${apellidos}","${email}")`
    const idCliente = `SELECT CodCliente FROM Cliente WHERE Nombre = "${nombre}" AND Apellidos = "${apellidos}" AND Email="${email}"`
    const sqlDireccion = `INSERT INTO Direcciones (Direccion,CodCliente) VALUES ("${direccion}",(${idCliente}))`
    const sqlTelefono = `INSERT INTO Telefonos (Tfno,CodCliente) VALUES ("${telefono}",(${idCliente}))`

    conector.query(sqlCliente, (err, result, field) => {
        if (err) throw err
    })

    conector.query(sqlDireccion, (err, result, field) => {
        if (err) throw err
    })
    conector.query(sqlTelefono, (err, result, field) => {
        if (err) throw err
    })
}



const agregarPedido = (pedido) => {

    const idCliente = `SELECT CodCliente FROM Cliente WHERE Email="${pedido[0][0].usuario}"`
    const sqlPedido = `INSERT INTO pedido (Entrega,FechaPedido,HoraPedido,CodCliente,CodSucur) VALUES ('${pedido[0][0].entrega}',CURDATE(),CURTIME(),(${idCliente}),${pedido[0][0].sucursal} )`
    const sqlNumPedido = `SELECT MAX(NumPedido) AS num FROM pedido`
    const sqlCodPizza = `SELECT MAX(CodPizza) AS cod FROM pizza`
    let sqlPizza
    let sqlPizzaIngre
    let sqlExisteIngre
    let sqlUpdateCant
    /* Inserto el pedido utilizando una sentencia con el email(como clave candidata) para recoger el codigo de cliente  */
    conector.query(sqlPedido, (err, result, field) => {
        if (err) throw err
    })



    /* Querys anidadas para insercción en pizza y pizza_ingredientes */
    conector.query(sqlNumPedido, (err, result, field) => { //Obtengo la primary key del último pedido
        let NumPedido = result[0].num

        for (let i = 1; i < pedido.length; i++) { //Itero la insercción de pizzas obteniendo el tipo recorriendo el array de objetos 'pedido'.

            let tipo = pedido[i][0].tipo

            sqlPizza = `INSERT INTO pizza (CodTipo,NumPedido) VALUES (${tipo},${NumPedido})`
            conector.query(sqlPizza, (err, result, field) => {//query de insercción de pizza
                if (err) throw err
            })

            conector.query(sqlCodPizza, (err, result, field) => {//query que recoge la primary key de la última pizza insertada.
                let pizzaCod = result[0].cod

                for (let j = 1; j < pedido[i].length; j++) {// Itero la insercción de ingredientes en pizza_ingredientes recorriendo el array 'pedido'
                    let ingreCod = pedido[i][j].ingre
                    let ingreCant = pedido[i][j].cant

                    sqlExisteIngre = `SELECT COUNT(*) AS ingre FROM Pizza_Ingrediente WHERE CodPizza=${pizzaCod} AND CodIngre = "${ingreCod}"`

                    conector.query(sqlExisteIngre, (err, result, field) => {//query que comprueba si ya hay un ingrediente insertado para la pizza de esta iteración, hay que comprobarlo ya que la base de datos tiene triggers definidos que auto insertan ingredientes en función del tipo

                        sqlUpdateCant = `UPDATE Pizza_Ingrediente SET cantIngre = ${ingreCant} WHERE CodPizza=${pizzaCod} AND CodIngre = "${ingreCod}"`
                        sqlPizzaIngre = `INSERT INTO Pizza_Ingrediente VALUES (${pizzaCod},"${ingreCod}",${ingreCant})`

                        if (result[0].ingre == 0 && ingreCant != 0) {
                            conector.query(sqlPizzaIngre, (err, result, field) => {//query que inserta el ingrediente en el caso de que no estuviera antes y de que su cantidad no sea 0
                                if (err) throw err
                            })

                        } else {

                            conector.query(sqlUpdateCant, (err, result, field) => {//query que actualiza la cantidad de ingrediente
                                if (err) throw err
                            })
                        }
                    })
                }

            })


        }
    })



}


//exports
export {agregarCliente, agregarPedido }