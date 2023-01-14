CREATE DATABASE PIZZERIA;

USE PIZZERIA;

CREATE TABLE Cliente(
CodCliente INT(5) AUTO_INCREMENT,
Nombre VARCHAR(50) NOT NULL,
Apellidos VARCHAR(100),
Email VARCHAR(100) NOT NULL,
CONSTRAINT ccPk PRIMARY KEY(CodCliente)
);

CREATE TABLE Direcciones(
CodDir INT(5) AUTO_INCREMENT,
Direccion VARCHAR(100) NOT NULL,
CodCliente INT(5),
CONSTRAINT cdPk PRIMARY KEY(CodDir),
CONSTRAINT ccdiFk FOREIGN KEY(CodCliente) REFERENCES Cliente(CodCliente) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Telefonos(
CodTfno INT(5) AUTO_INCREMENT,
Tfno VARCHAR(11) NOT NULL,
CodCliente INT(5),
CONSTRAINT ctfPk PRIMARY KEY(CodTfno),
CONSTRAINT ccteFk FOREIGN KEY(CodCliente) REFERENCES Cliente(CodCliente) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sucursal(
CodSucur INT(5) AUTO_INCREMENT,
Nombre VARCHAR(20) NOT NULL,
Direccion VARCHAR(100) NOT NULL,
CONSTRAINT csPk PRIMARY KEY(CodSucur)
);

CREATE TABLE Pedido(
NumPedido INT(5) AUTO_INCREMENT,
Entrega CHAR(1) NOT NULL CHECK (Entrega IN('R','D')),
PrecioTotal FLOAT(5,2),
FechaPedido DATE NOT NULL,
HoraPedido TIME NOT NULL,
FechaLiquidado DATE,
HoraLiquidado TIME,
Liquidado BOOLEAN DEFAULT FALSE,
CodCliente INT(5),
CodSucur INT(5),
CONSTRAINT npPk PRIMARY KEY(NumPedido),
CONSTRAINT ccpeFk FOREIGN KEY(CodCliente) REFERENCES Cliente(CodCliente) ON DELETE SET NULL ON UPDATE SET NULL,
CONSTRAINT cspeFk FOREIGN KEY(CodSucur) REFERENCES Sucursal(CodSucur) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Tipo(
CodTipo INT(2),
Nombre VARCHAR(20),
Descripcion VARCHAR(150),
CONSTRAINT ctPK PRIMARY KEY(CodTipo)
);

CREATE TABLE Pizza(
CodPizza INT(5) AUTO_INCREMENT,
CodTipo INT(2),
NumPedido INT(5) NOT NULL,
CONSTRAINT cpPk PRIMARY KEY(CodPizza),
CONSTRAINT ctpiFk FOREIGN KEY(CodTipo) REFERENCES Tipo(CodTipo) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT nppiFk FOREIGN KEY(NumPedido) REFERENCES Pedido(NumPedido) ON DELETE CASCADE
);

CREATE TABLE PrecioPizza(
CodPizza INT(5),
PrecioPizza FLOAT(5,2),
CONSTRAINT ppPk PRIMARY KEY(CodPizza),
CONSTRAINT cpppFk FOREIGN KEY(CodPizza) REFERENCES Pizza(CodPizza) ON DELETE CASCADE
);


CREATE TABLE Ingrediente(
CodIngre VARCHAR(4),
Nombre VARCHAR(20),
Descripcion VARCHAR(150),
CONSTRAINT ciPk PRIMARY KEY(CodIngre)
);

CREATE TABLE Pizza_Ingrediente(
CodPizza INT(5),
CodIngre VARCHAR(4),
CantIngre INT(1) DEFAULT 1,
CONSTRAINT piPk PRIMARY KEY(CodPizza, CodIngre),
CONSTRAINT cppiFk FOREIGN KEY(CodPizza) REFERENCES Pizza(CodPizza) ON DELETE CASCADE,
CONSTRAINT cipiFk FOREIGN KEY(CodIngre) REFERENCES Ingrediente(CodIngre) ON UPDATE CASCADE
);

CREATE TABLE Tipo_Ingrediente(
CodTipo INT(2),
CodIngre VARCHAR(4),
CONSTRAINT tiPK PRIMARY KEY(CodTipo,CodIngre),
CONSTRAINT cttiFK FOREIGN KEY (CodTipo) REFERENCES Tipo(CodTipo) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT citiFK FOREIGN KEY (CodIngre) REFERENCES Ingrediente(CodIngre) ON UPDATE CASCADE
);

CREATE TABLE ListaPrecios(
CodList VARCHAR(10),
FechaInicio DATE NOT NULL,
FechaFin DATE NOT NULL,
Descripcion VARCHAR(100),
CONSTRAINT clpPk PRIMARY KEY(CodList)
);

CREATE TABLE PrecioVigente(
CodVigen VARCHAR(10),
PrecioIngre FLOAT(4,2),
CodIngre VARCHAR(4),
CodList VARCHAR(10),
CONSTRAINT cvPk PRIMARY KEY(CodVigen),
CONSTRAINT cipFk FOREIGN KEY(CodIngre) REFERENCES Ingrediente(CodIngre) ON UPDATE CASCADE ,
CONSTRAINT clpFk FOREIGN KEY(CodList) REFERENCES ListaPrecios(CodList) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Envio(
CantPedidos INT(2),
FechaEnvio DATE,
HoraEnvio TIME
);


INSERT INTO Cliente VALUES
(1, 'María', NULL, 'maria@email.com'),
(2,'Andrés', NULL, 'andres@email.com'),
(3, 'Daniel', NULL, 'daniel@email.com');


INSERT INTO Direcciones VALUES
(1 , 'C/ Ancha, 2', 1),
(2 , 'C/ Mayor, 3', 2),
(3 , 'C/ Ancha, 5', 3);


INSERT INTO Telefonos VALUES
(1 , '22222', 1),
(2 , '33333', 2),
(3 , '55555', 3);

INSERT INTO Sucursal VALUES
(1,'Guadarrama','C/Alfonso Senra 59, 28440'),
(2,'Collado Villalba','C/Rio Tajo 16, 28400');

INSERT INTO Ingrediente VALUES
('M','Masa','Masa de harina de trigo, agua, sal y levadura'),
('T', 'Tomate','Salsa de tomate natural de la variedad San Marzano'),
('Q', 'Queso','Queso mozzarella rallado especial para pizzas'),
('C', 'Cebolla', 'Cebolla dulce fresca'),
('Ca', 'Carne', 'Carne picada de vacuno'),
('A', 'Atún', 'Atún en aceite de oliva'),
('B', 'Bacon', 'Bacon en lonchas'),
('Ch', 'Champiñón', 'Champiñón portobello laminado'),
('An', 'Anchoas', 'Anchoas de Santoña'),
('P', 'Pimiento', 'Pimiento morron rojo en tiras'),
('Sb', 'Salsa Barbacoa', 'Salsa casera a base de salsa perrins, mostaza, ketchup y miel'),
('Sc', 'Salsa Carbonara', 'Salsa casera a base de nata, huevos, queso parmesano y cebolla');

INSERT INTO ListaPrecios VALUES
('TempAlta', '2010-06-01','2010-08-31', 'Temporada alta. En Verano los ingedientes tienen un suplemento de 0,20€'),
('TempBaja1', '2010-01-01', '2010-05-30', 'Temporada baja. Primera mitad del año'),
('TempBaja2', '2010-09-01', '2010-12-31', 'Temporada baja. Segunda mitad del año');

INSERT INTO PrecioVigente VALUES
('V1', 2.2, 'M', 'TempAlta'),
('V2', 2, 'M', 'TempBaja1'),
('V3', 2, 'M', 'TempBaja2'),
('V4', 2.2, 'T', 'TempAlta'),
('V5', 2, 'T', 'TempBaja1'),
('V6', 2, 'T', 'TempBaja2'),
('V7', 2.2, 'Q', 'TempAlta'),
('V8', 2, 'Q', 'TempBaja1'),
('V9', 2, 'Q', 'TempBaja2'),
('V10', 2.2, 'C', 'TempAlta'),
('V11', 2, 'C', 'TempBaja1'),
('V12', 2, 'C', 'TempBaja2'),
('V13', 4.2, 'Ca', 'TempAlta'),
('V14', 4, 'Ca', 'TempBaja1'),
('V15', 4, 'Ca', 'TempBaja2'),
('V16', 3.2, 'A', 'TempAlta'),
('V17', 3, 'A', 'TempBaja1'),
('V18', 3, 'A', 'TempBaja2'),
('V19', 2.2, 'B', 'TempAlta'),
('V20', 2, 'B', 'TempBaja1'),
('V21', 2, 'B', 'TempBaja2'),
('V22', 2.2, 'Ch', 'TempAlta'),
('V23', 2, 'Ch', 'TempBaja1'),
('V24', 2, 'Ch', 'TempBaja2'),
('V25', 3.2, 'An', 'TempAlta'),
('V26', 3, 'An', 'TempBaja1'),
('V27', 3, 'An', 'TempBaja2'),
('V28', 2.2, 'P', 'TempAlta'),
('V29', 2, 'P', 'TempBaja1'),
('V30', 2, 'P', 'TempBaja2'),
('V31', 3.2, 'Sb', 'TempAlta'),
('V32', 3, 'Sb', 'TempBaja1'),
('V33', 3, 'Sb', 'TempBaja2'),
('V34', 3.2, 'Sc', 'TempAlta'),
('V35', 3, 'Sc', 'TempBaja1'),
('V36', 3, 'Sc', 'TempBaja2');

INSERT INTO Tipo VALUES
(1 , 'Margarita', 'Pizza margarita con masa, tomate y queso'),
(2 , 'Barbacoa', 'Pizza barbacoa con masa, salsa barbacoa, queso y carne'),
(3 , 'Carbonara', 'Pizza carbonara con masa, salsa carbonara, queso, cebolla, bacon y champiñon'),
(4 , 'Gusto', 'Pizza al gusto con cualquier ingrediente con un máximo de 6 ingredientes');

INSERT INTO Pedido (NumPedido,Entrega,PrecioTotal,FechaPedido,HoraPedido,CodCliente,CodSucur)VALUES
(1,'D', 19.2, '2010-06-20','21:15:00', 3,1),
(2,'D', 8.8, '2010-06-28','21:00:00', 1,2),
(3,'R', 30.6, '2010-06-29','20:30:00', 2,1),
(4,'D', 28, '2010-06-30','21:10:00', 1,1),
(5,'R', 17.4, '2010-06-30','21:30:00', 3,1),
(6,'D', 13, '2010-07-13','20:45:00', 2,2);

INSERT INTO Pizza (CodTipo,NumPedido)VALUES
(1,3),
(1,2),
(2,4),
(2,1),
(3,3),
(3,5),
(4,3),
(4,6),
(4,4);
INSERT INTO PrecioPizza VALUES
(1,6.6),
(2,8.8),
(3,16),
(4,19.2),
(5,14.2),
(6,17.4),
(7,9.8),
(8,13),
(9,12);

INSERT INTO Pizza_Ingrediente VALUES
(1,'M',1),
(1,'T',1),
(1,'Q',1),
(2,'M',1),
(2,'T',1),
(2,'Q',2),
(3,'M',1),
(3,'Q',1),
(3,'Ca',2),
(3,'Sb',1),
(4,'M',1),
(4,'Q',1),
(4,'Ca',2),
(4,'Sb',2),
(5,'M',1),
(5,'Q',1),
(5,'C',1),
(5,'B',1),
(5,'Ch',1),
(5,'Sc',1),
(6,'M',1),
(6,'Q',1),
(6,'C',1),
(6,'B',1),
(6,'Ch',1),
(6,'Sc',2),
(7,'M',1),
(7,'T',1),
(7,'C',1),
(7,'A',1),
(8,'M',1),
(8,'Q',2),
(8,'T',1),
(8,'Ca',1),
(9,'M',1),
(9,'Q',1),
(9,'C',1),
(9,'Ch',1),
(9,'Sc',1);

INSERT INTO Tipo_Ingrediente VALUES
(1,'M'),
(1,'T'),
(1,'Q'),
(2,'M'),
(2,'Q'),
(2,'Ca'),
(2,'C'),
(2,'B'),
(2,'Sb'),
(3,'M'),
(3,'Q'),
(3,'C'),
(3,'B'),
(3,'Ch'),
(3,'Sc'),
(4,'M');

DELIMITER $$
DROP FUNCTION IF EXISTS PrecioPizza$$
CREATE FUNCTION PrecioPizza(codigo INT)
RETURNS FLOAT(5,2) DETERMINISTIC
BEGIN
DECLARE ingreCod VARCHAR(4);
DECLARE listCod VARCHAR(10);
DECLARE ingreCant,fin INT(4) DEFAULT 1;
DECLARE precio FLOAT(5,2) DEFAULT 0;
DECLARE pedidoFecha DATE;

DECLARE PizIngCursor CURSOR FOR SELECT CodIngre, CantIngre FROM Pizza_Ingrediente WHERE CodPizza=codigo;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=0;

SELECT Pe.FechaPedido
INTO pedidoFecha
FROM Pedido Pe,Pizza P 
WHERE Pe.NumPedido=P.NumPedido AND CodPizza=codigo; 

SELECT CodList 
INTO listCod
FROM ListaPrecios 
WHERE date_format(FechaInicio,'%m-%d') <= date_format(pedidoFecha,'%m-%d') AND date_format(FechaFin,'%m-%d') >= date_format(pedidoFecha,'%m-%d');

OPEN PizIngCursor;
FETCH PizIngCursor INTO ingreCod,ingreCant;

WHILE fin DO
    SET precio=precio+((
        SELECT PrecioIngre 
        FROM PrecioVigente 
        WHERE CodIngre=ingreCod AND CodList=listCod)*ingreCant);
    FETCH PizIngCursor INTO ingreCod,ingreCant;
END WHILE;

CLOSE PizIngCursor;
RETURN precio;
END$$


DROP FUNCTION IF EXISTS PrecioPedido$$
CREATE FUNCTION PrecioPedido(codigo INT)
RETURNS FLOAT(5,2) DETERMINISTIC
BEGIN
DECLARE precio FLOAT(5,2);

SELECT SUM(P.PrecioPizza)
INTO precio 
FROM PrecioPizza P,Pizza Z 
WHERE Z.NumPedido=codigo AND P.CodPizza=Z.CodPizza;

RETURN precio;
END$$


DROP PROCEDURE IF EXISTS InsertaIngrediente$$
CREATE PROCEDURE InsertaIngrediente(IN pizzaCod INT, IN ingreCod VARCHAR(4),IN ingreCant INT)
BEGIN
INSERT INTO Pizza_Ingrediente VALUES(pizzaCod,ingreCod,ingreCant);
END$$


DROP PROCEDURE IF EXISTS CrearPizzaBase$$
CREATE PROCEDURE CrearPizzaBase(IN codigo INT)
BEGIN
DECLARE ingreCod VARCHAR(4);
DECLARE fin INT(1) DEFAULT 1;

DECLARE TipIngCursor CURSOR FOR SELECT CodIngre FROM Tipo_Ingrediente WHERE CodTipo=(SELECT CodTipo FROM Pizza WHERE CodPizza=codigo);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=0;

OPEN TipIngCursor;
FETCH TipIngCursor INTO ingreCod;

WHILE fin DO
    call InsertaIngrediente(codigo,ingreCod,1);
    FETCH TipIngCursor INTO ingreCod;
END WHILE;

END$$


DROP PROCEDURE IF EXISTS EnvioPedidos$$
CREATE PROCEDURE EnvioPedidos()
BEGIN
DECLARE numeroPedidos INT(3);

SELECT COUNT(*) 
INTO numeroPedidos
FROM Pedido 
WHERE Entrega='D' AND Liquidado=0 GROUP BY Entrega;

UPDATE Pedido SET FechaLiquidado=CURDATE(), HoraLiquidado=CURTIME(), Liquidado=1 WHERE Entrega='D' AND Liquidado=0;
INSERT INTO Envios VALUES(numeroPedidos,CURDATE(),CURTIME());

COMMIT;
END$$


DROP PROCEDURE IF EXISTS PedidoRecogido$$
CREATE PROCEDURE PedidoRecogido(IN codigo INT(5))
BEGIN
UPDATE Pedido SET Liquidado=1,FechaLiquidado=CURDATE(),HoraLiquidado=CURTIME() WHERE NumPedido=codigo AND Entrega='R';
COMMIT;
END$$


DROP TRIGGER IF EXISTS nuevaPizza_after_insert $$
CREATE TRIGGER nuevaPizza_after_insert
AFTER INSERT
ON Pizza FOR EACH ROW 
BEGIN
call CrearPizzaBase(NEW.CodPizza);
END$$



DROP PROCEDURE IF EXISTS ActualizaPrecioPizza$$
CREATE PROCEDURE ActualizaPrecioPizza(IN codigo VARCHAR(4))
BEGIN
IF EXISTS(SELECT CodPizza FROM PrecioPizza WHERE CodPizza=codigo) THEN
    UPDATE PrecioPizza SET PrecioPizza=PrecioPizza(codigo) WHERE CodPizza=codigo;
ELSE
    INSERT INTO PrecioPizza VALUES(codigo,PrecioPizza(codigo));
END IF;
END$$

DROP TRIGGER IF EXISTS nuevoIngre_after_insert $$
CREATE TRIGGER nuevoIngre_after_insert 
AFTER INSERT
ON Pizza_Ingrediente FOR EACH ROW
BEGIN
call ActualizaPrecioPizza(NEW.CodPizza);
END$$

DROP TRIGGER IF EXISTS nuevoIngre_after_update $$
CREATE TRIGGER nuevoIngre_after_update
AFTER UPDATE
ON Pizza_Ingrediente FOR EACH ROW
BEGIN
call ActualizaPrecioPizza(NEW.CodPizza);
END$$

DROP PROCEDURE IF EXISTS ActualizaPrecioPedido$$
CREATE PROCEDURE ActualizaPrecioPedido(IN codigo VARCHAR(4))
BEGIN
UPDATE Pedido SET PrecioTotal=PrecioPedido(codigo) WHERE NumPedido=codigo;
END$$

DROP TRIGGER IF EXISTS pizzaPedido_after_insert $$
CREATE TRIGGER pizzaPedido_after_insert
AFTER INSERT
ON Pizza FOR EACH ROW FOLLOWS nuevaPizza_after_insert
BEGIN
call ActualizaPrecioPedido(NEW.NumPedido);
END$$


DROP TRIGGER IF EXISTS pizzaPedido_after_delete $$
CREATE TRIGGER pizzaPedido_after_delete
AFTER DELETE
ON Pizza FOR EACH ROW 
BEGIN
call ActualizaPrecioPedido(OLD.NumPedido);
END$$

DELIMITER ;


 


