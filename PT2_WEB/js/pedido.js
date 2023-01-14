

/* Declaración variables globales */

const usuario = document.getElementById('usuario')

let sucursal = document.querySelector('#sucursal').options[document.querySelector('#sucursal').selectedIndex].value

let entrega = document.querySelector('#entrega').options[document.querySelector('#entrega').selectedIndex].value

let tipo = document.querySelector('#tipo').options[document.querySelector('#tipo').selectedIndex].value

let masa = document.querySelector('#masa').value 

let tomate = document.querySelector('#tomate').value

let queso = document.querySelector('#queso').value

let cebolla = document.querySelector('#cebolla').value

let carne = document.querySelector('#carne').value

let atun = document.querySelector('#atun').value

let bacon = document.querySelector('#bacon').value

let champinon = document.querySelector('#champinon').value

let anchoas = document.querySelector('#anchoas').value

let pimiento = document.querySelector('#pimiento').value

let salsabbq = document.querySelector('#salsabbq').value

let salsacarb = document.querySelector('#salsacarb').value

/* Variable que guarda el objeto pedido en JSON */
let pedidoJSON 

/* Asignación de valores */
function configuracion() {
    sucursal = document.querySelector('#sucursal').options[document.querySelector('#sucursal').selectedIndex].value

    entrega = document.querySelector('#entrega').options[document.querySelector('#entrega').selectedIndex].value

    document.querySelector('#tipo').options[document.querySelector('#tipo').selectedIndex].value

    tipo = document.querySelector('#tipo').options[document.querySelector('#tipo').selectedIndex].value

    masa = document.querySelector('#masa').value //etc...

    tomate = document.querySelector('#tomate').value

    queso = document.querySelector('#queso').value

    cebolla = document.querySelector('#cebolla').value

    carne = document.querySelector('#carne').value

    atun = document.querySelector('#atun').value

    bacon = document.querySelector('#bacon').value

    champinon = document.querySelector('#champinon').value

    anchoas = document.querySelector('#anchoas').value

    pimiento = document.querySelector('#pimiento').value

    salsabbq = document.querySelector('#salsabbq').value

    salsacarb = document.querySelector('#salsacarb').value
}

/* Función que preselecciona los ingredientes en función del tipo */
function eligeIngrediente() {
    document.getElementById('tomate').value = 0
    document.getElementById('queso').value = 0
    document.getElementById('cebolla').value = 0
    document.getElementById('carne').value = 0
    document.getElementById('atun').value = 0
    document.getElementById('bacon').value = 0
    document.getElementById('champinon').value = 0
    document.getElementById('anchoas').value = 0
    document.getElementById('pimiento').value = 0
    document.getElementById('salsabbq').value = 0
    document.getElementById('salsacarb').value = 0
    switch (tipo) {
        case "1":
            document.getElementById('masa').value = 1
            document.getElementById('tomate').value = 1
            document.getElementById('queso').value = 1
            configuracion()
            break;
        case "2":
            document.getElementById('masa').value = 1
            document.getElementById('salsabbq').value = 1
            document.getElementById('queso').value = 1
            document.getElementById('carne').value = 1
            configuracion()
            break;
        case "3":
            document.getElementById('masa').value = 1
            document.getElementById('salsacarb').value = 1
            document.getElementById('queso').value = 1
            document.getElementById('cebolla').value = 1
            document.getElementById('bacon').value = 1
            document.getElementById('champinon').value = 1
            configuracion()
            break;
    }
}

/* Objetos que almacenan la información del pedido */
const pedido = [[{
    "usuario": "",
    "sucursal": sucursal,
    "entrega": entrega
}]]

let pizza //Variable global para el objeto pizza

function configuraPizza() { //Función de asignación
    pizza = [
        {
            "tipo": tipo
        },
        {
            "ingre": "M",
            "cant": masa
        },
        {
            "ingre": "T",
            "cant": tomate
        }, 
        {
            "ingre": "Q",
            "cant": queso
        },
        {
            "ingre": "C",
            "cant": cebolla
        },
        {
            "ingre": "Ca",
            "cant": carne
        },
        {
            "ingre": "A",
            "cant": atun
        },
        {
            "ingre": "B",
            "cant": bacon
        },
        {
            "ingre": "Ch",
            "cant": champinon
        },
        {
            "ingre": "An",
            "cant": anchoas
        }
        ,
        {
            "ingre": "P",
            "cant": pimiento
        }
        ,
        {
            "ingre": "Sb",
            "cant": salsabbq
        }
        ,
        {
            "ingre": "Sc",
            "cant": salsacarb
        }
    ]
}






/* Boton añadir para añadir una pizza al pedido */
const añadir = document.querySelector('#añadir')

/* Eveneto click sobre boton añadir */
añadir.addEventListener('click', () => {

    /* Construyo el objeto pedido y el objeto pizza con los valores actualizados*/
    pedido[0][0].usuario = usuario.value
    pedido[0][0].sucursal = sucursal
    pedido[0][0].entrega = entrega
    configuraPizza()

    /* Añadiendo una pizza al pedido y convirtiendo el objeto pedido a JSON */
    pedido.push(pizza)
    pedidoJSON = JSON.stringify(pedido)

    /* Deshabilitando las opciones que no deben cambiar una vez se empieza el pedido */
    document.getElementById('usuario').readOnly = true
    document.getElementById('entrega').disabled = true
    document.getElementById('sucursal').disabled = true

    /* Mostrar en pantalla el contenido del pedido (Carrito de la compra)*/
    const tipoNombre = document.querySelector('#tipo').options[document.querySelector('#tipo').selectedIndex].text
    const pizzaPedido = document.querySelector(".pedido__carrito__pizzas")
    pizzaPedido.insertAdjacentHTML("beforeend", '<li class="pedido__carrito__pizzas-pizza">Pizza ' + tipoNombre + ' x1 </li>')
    console.log(pedidoJSON.length)
})


/* Boton de comprar */

const comprar = document.querySelector('#comprar')

/* Mando al servidor el objeto pedido dentro de la url */
comprar.addEventListener('click', () => {

    window.location.href = `pedir/${pedidoJSON}`

})


/* Botones up/down ingredientes */

function upDown(id, step) {
    let cont = parseInt(document.getElementById(id).value) + parseInt(step)
    document.getElementById(id).value = cont >= 2 ? 2 : cont <= 0 ? document.getElementById(id).defaultValue : cont
}

/* Carrito en movimiento */

/* se ejecuta cuando hacemos scroll */
window.onscroll = () => { addFixed() }

/* capturando el carrito */
let carrito = document.getElementById("carrito")

/* posición superior e inferior del carrito*/

let carriTop = carrito.offsetTop
let carriBot = carrito.offsetBottom

function addFixed() {
    if (window.pageYOffset > carriTop ) {
        carrito.classList.add("fixed")
    } else {
        carrito.classList.remove("fixed")
    }
}