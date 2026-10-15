-- DROP DATABASE IF EXISTS mercadopago;
CREATE DATABASE IF NOT EXISTS mercadopago;
USE mercadopago;

-- ============================================================================
-- 1. CREACIÓN DE TABLAS (DDL) E INSERCIÓN DE LOTES DE PRUEBA
-- ============================================================================

-- Tabla Usuario (Supertipo)
CREATE TABLE IF NOT EXISTS Usuario (
    ID_Usuario INT PRIMARY KEY NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    CUIT VARCHAR(20) UNIQUE NOT NULL,
    Condicion_Fiscal VARCHAR(50)
);

INSERT INTO Usuario (ID_Usuario, Telefono, Email, CUIT, Condicion_Fiscal) VALUES 
(101, '11-3456-7890', 'usuario1@example.com', '20-12345678-9', 'Responsable Inscripto'),
(102, '11-9876-5432', 'usuario2@example.com', '27-87654321-4', 'Monotributista'),
(103, '11-2233-4455', 'usuario3@example.com', '20-56789012-3', 'Exento'),
(104, '11-5566-7788', 'usuario4@example.com', '30-34567890-1', 'Responsable Inscripto'),
(105, '11-9988-7766', 'usuario5@example.com', '23-23456789-0', 'Monotributista'),
(106, '11-2648-9285', 'usuario6@example.com', '25-73890298-2', 'Exento'),
(107, '11-9988-7766', 'usuario7@example.com', '20-31568974-3', 'Monotributista'),
(108, '11-2648-9285', 'usuario8@example.com', '30-65841392-1', 'Exento');

-- Tabla Direccion (Normalización 1FN: un usuario puede tener múltiples direcciones)
CREATE TABLE IF NOT EXISTS Direccion (
    ID_Direccion INT PRIMARY KEY NOT NULL,
    ID_Usuario INT NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Direccion (ID_Direccion, ID_Usuario, Direccion) VALUES 
(1, 101, 'Av. Libertador - 1234'),
(2, 102, 'Calle San Martín - 5674'),
(3, 103, 'Av. Rivadavia - 8901'),
(4, 104, 'Calle Belgrano - 2345'),
(5, 105, 'Av. Falsa - 4567'),
(6, 106, 'Calle Real - 7890'),
(7, 107, 'Pasaje Verde - 123'),
(8, 108, 'Av. Argentina - 456');

-- Tabla Fisica (Especialización de Usuario)
CREATE TABLE IF NOT EXISTS Fisica (
    ID_Fisica INT PRIMARY KEY NOT NULL,
    ID_Usuario INT NOT NULL,
    DNI VARCHAR(10) UNIQUE NOT NULL,
    Nombre_Persona VARCHAR(100) NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Fisica (ID_Fisica, ID_Usuario, DNI, Nombre_Persona) VALUES 
(2, 102, '40000001', 'Tomás Francisco Moroz'),
(4, 104, '40000002', 'Pablo Ariel Luna'),
(6, 106, '40000003', 'Briana Rocío Benítez'),
(7, 107, '40000004', 'Jeanette Antonella Pereyra'),
(8, 108, '40000005', 'María Valentina Calogerópulos');

-- Tabla Juridica (Especialización de Usuario)
CREATE TABLE IF NOT EXISTS Juridica (
    ID_Juridica INT PRIMARY KEY NOT NULL,
    ID_Usuario INT NOT NULL,
    Nombre_Empresa VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Razon_Social VARCHAR(100) NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Juridica (ID_Juridica, ID_Usuario, Nombre_Empresa, Categoria, Razon_Social) VALUES 
(1, 101, 'Automoviles S.A.', 'PyME', 'Automoviles Sociedad Anónima'),
(3, 103, 'GlobalCorp Ltda.', 'Gran Empresa', 'GlobalCorp Sociedad de Responsabilidad Limitada'),
(5, 105, 'NextGen Tech SRL', 'Microempresa', 'NextGen Tech Sociedad de Responsabilidad Limitada');

-- Tabla FCI (Fondo Común de Inversión)
CREATE TABLE IF NOT EXISTS FCI (
    ID_FCI INT PRIMARY KEY NOT NULL,
    Nombre_Fondo VARCHAR(100) NOT NULL,
    Rendimiento DECIMAL(5, 2),
    Tipo VARCHAR(50) NOT NULL,
    Administrador VARCHAR(100) NOT NULL
);

INSERT INTO FCI (ID_FCI, Nombre_Fondo, Rendimiento, Tipo, Administrador) VALUES 
(1, 'FCI', 81.20, 'Rentabilidad Fija', 'Industrial Asset Management SGFCISA');

-- Tabla Cuenta (Supertipo)
CREATE TABLE IF NOT EXISTS Cuenta (
    ID_Cuenta INT PRIMARY KEY NOT NULL,
    Alias VARCHAR(100) UNIQUE,
    CVU_CBU VARCHAR(22) UNIQUE
);

INSERT INTO Cuenta (ID_Cuenta, Alias, CVU_CBU) VALUES 
(1, 'mi.alias.123.mp', '0000003100012345678910'),
(2, 'alias.456.galicia', '0000003100098765432100'),
(3, 'francisco.432.mp', '0000003100034567890123'),
(4, 'nube.mar.estrella.mp', '0000003100076543210987'),
(5, 'auto.sol.manzana.mp', '0000003100076333332221'),
(6, 'tus.automoviles.mp', '0000003100076512143143'),
(7, 'luz.rio.azul.BBVA', '0000003100056789123456'),
(8, 'primadonna.luz.mp', '0000003100067899712348'),
(9, 'globLC.mp', '0000003100079010301240'),
(10, 'nextgen78.mp', '0000003100090120890132');

-- Tabla MercadoPago (Especialización de Cuenta)
CREATE TABLE IF NOT EXISTS MercadoPago (
    ID_MercadoPago INT PRIMARY KEY NOT NULL,
    ID_Cuenta INT NOT NULL,
    Nombre_Usuario VARCHAR(100),
    Saldo DECIMAL(10, 2) DEFAULT 0,
    ID_Usuario INT NOT NULL,
    ID_FCI INT NOT NULL,
    FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta(ID_Cuenta) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (ID_FCI) REFERENCES FCI(ID_FCI) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO MercadoPago (ID_MercadoPago, ID_Cuenta, Nombre_Usuario, Saldo, ID_Usuario, ID_FCI) VALUES 
(1, 1, 'CALOGEROPULOS_MARIA9281', 14000.00, 108, 1),
(2, 3, 'MOROZ_TOMÁS_FRANCISCO7314', 20500.00, 102, 1),
(3, 4, 'PEREYRAJEANETTEANTONELLA5642', 27000727.27, 107, 1),
(4, 5, 'LUNA_PABLO ARIEL1937', 140700.00, 104, 1), 
(5, 6, 'AUTOMOVILES8823', 50500300.03, 101, 1),
(6, 8, 'BENITEZ_BRIANAROCIO4159', 34600.00, 106, 1), 
(7, 9, 'GLOBALCORP7725', 59000600.01, 103, 1),
(8, 10, 'NEXTGEN2368', 17632200.02, 105, 1);

-- Tabla Externa (Especialización de Cuenta)
CREATE TABLE IF NOT EXISTS Externa (
    ID_Externa INT PRIMARY KEY NOT NULL,
    ID_Cuenta INT NOT NULL,
    Nombre_Servicio VARCHAR(100),
    DNI INT UNIQUE NOT NULL,
    FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta(ID_Cuenta) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Externa (ID_Externa, ID_Cuenta, Nombre_Servicio, DNI) VALUES 
(1, 2, 'Galicia', 40000010),
(2, 7, 'BBVA Francés', 40000004);

-- Tabla Personal (Especialización de MercadoPago)
CREATE TABLE IF NOT EXISTS Personal (
    ID_Personal INT PRIMARY KEY NOT NULL,
    ID_MercadoPago INT NOT NULL,
    FOREIGN KEY (ID_MercadoPago) REFERENCES MercadoPago(ID_MercadoPago) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Personal (ID_Personal, ID_MercadoPago) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 6);

-- Tabla Empresa (Especialización de MercadoPago)
CREATE TABLE IF NOT EXISTS Empresa (
    ID_Empresa INT PRIMARY KEY NOT NULL,
    ID_MercadoPago INT NOT NULL UNIQUE,
    FOREIGN KEY (ID_MercadoPago) REFERENCES MercadoPago(ID_MercadoPago)
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Empresa (ID_Empresa, ID_MercadoPago) VALUES 
(1, 5), (2, 7), (3, 8);

-- Tabla Tarjeta
CREATE TABLE IF NOT EXISTS Tarjeta (
    Numero VARCHAR(16) PRIMARY KEY NOT NULL,
    CVV CHAR(3) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    PIN CHAR(4) NOT NULL,
    FechaDeVencimiento DATE NOT NULL,
    Tipo VARCHAR(100) NOT NULL,
    ID_MercadoPago INT NOT NULL,
    FOREIGN KEY (ID_MercadoPago) REFERENCES MercadoPago(ID_MercadoPago) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Tarjeta (Numero, PIN, CVV, FechaDeVencimiento, Nombre, ID_MercadoPago, Tipo) VALUES
('1234567890123456', '1234', '321', '2025-12-31', 'Banco Nación', 1, 'Débito'),
('9876543210987654', '5678', '654', '2026-06-30', 'Banco Galicia', 2, 'Crédito'),
('4567890123456789', '2345', '987', '2024-11-30', 'Santander', 3, 'Crédito'),
('1122334455667788', '6789', '159', '2027-03-31', 'BBVA', 4, 'Crédito'),
('0000000000000000', '000', '000', '2099-01-01', 'Mercado Pago', 1, 'Dinero disponible'),
('0000000000000001', '001', '001', '2099-01-01', 'Mercado Pago', 2, 'Dinero disponible'),
('0000000000000002', '002', '002', '2099-01-01', 'Mercado Pago', 3, 'Dinero disponible'),
('0000000000000003', '003', '003', '2099-01-01', 'Mercado Pago', 4, 'Dinero disponible'),
('0000000000000004', '004', '004', '2099-01-01', 'Mercado Pago', 5, 'Dinero disponible'),
('0000000000000005', '005', '005', '2099-01-01', 'Mercado Pago', 6, 'Dinero disponible'),
('0000000000000006', '006', '006', '2099-01-01', 'Mercado Pago', 7, 'Dinero disponible'),
('0000000000000007', '007', '007', '2099-01-01', 'Mercado Pago', 8, 'Dinero disponible');

-- Tabla Transfiere_a (Transferencias entre cuentas)
CREATE TABLE IF NOT EXISTS Transfiere_a (
    ID_CuentaOrigen INT NOT NULL, 
    ID_CuentaDestino INT NOT NULL, 
    NroOperacion BIGINT PRIMARY KEY NOT NULL,
    Motivo VARCHAR(255),
    Total DECIMAL(10, 2) NOT NULL CHECK (Total > 0),
    Tipo VARCHAR(50),
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    Medio_de_pago VARCHAR(16),
    FOREIGN KEY (ID_CuentaOrigen) REFERENCES Cuenta(ID_Cuenta) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (ID_CuentaDestino) REFERENCES Cuenta(ID_Cuenta) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (Medio_de_pago) REFERENCES Tarjeta(Numero) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Transfiere_a (ID_CuentaOrigen, ID_CuentaDestino, NroOperacion, Motivo, Total, Tipo, Fecha, Hora, Medio_de_pago) VALUES
(1, 2, 89999912312, NULL, 500, NULL, '2024-09-03', '17:00', '0000000000000000'),
(2, 1, 84449923145, NULL, 6000, NULL, '2024-09-03', '09:00', NULL),
(2, 1, 64449923145, NULL, 5000, NULL, '2024-09-03', '19:00', NULL),
(2, 3, 99844953145, NULL, 20000, NULL, '2024-09-03', '07:00', NULL),
(3, 7, 98424953149, NULL, 11000, NULL, '2024-09-03', '13:00', '0000000000000001'),
(7, 4, 97107466481, NULL, 20000000, NULL, '2024-09-03', '08:40', NULL),
(7, 5, 71623126111, NULL, 15000, NULL, '2024-09-03', '06:45', NULL),
(5, 2, 103556488816, NULL, 500, NULL, '2024-09-03', '17:00', '0000000000000003'),
(7, 8, 106780999984, NULL, 32500, NULL, '2024-09-03', '08:07', NULL),
(8, 2, 110005511151, NULL, 20000, NULL, '2024-09-03', '09:43', '9876543210987654'),
(8, 2, 113230022318, NULL, 45000, NULL, '2024-09-03', '12:01', '1234567890123456'),
(1, 7, 116454533486, NULL, 1200, NULL, '2024-09-04', '12:00', '0000000000000000'),
(8, 3, 119679044653, NULL, 5000, NULL, '2024-09-04', '09:00', '9876543210987654'),
(3, 2, 122903555821, NULL, 3000, NULL, '2024-09-04', '14:00', '0000000000000001'),
(7, 5, 126128066988, NULL, 20000, NULL, '2024-09-04', '11:43', NULL),
(5, 2, 129352578155, NULL, 17000, NULL, '2024-09-04', '12:39', '0000000000000003'),
(2, 5, 132577089323, NULL, 11000, NULL, '2024-09-04', '13:00', NULL),
(2, 8, 135801600490, NULL, 1500, NULL, '2024-09-04', '09:11', NULL),
(8, 7, 139026111658, NULL, 150, NULL, '2024-09-04', '12:01', '0000000000000005'),
(3, 1, 142250622825, NULL, 4000, NULL, '2024-09-05', '07:00', '0000000000000001'),
(1, 2, 145475133992, NULL, 600, NULL, '2024-09-05', '14:05', '0000000000000000'),
(7, 1, 148699645160, NULL, 1269.60, NULL, '2024-09-05', '18:34', NULL),
(2, 3, 151924156327, NULL, 1200, NULL, '2024-09-05', '12:00', NULL),
(7, 3, 155148667495, NULL, 3000, NULL, '2024-09-05', '12:30', NULL),
(2, 3, 158373178662, NULL, 9258.18, NULL, '2024-09-05', '13:45', NULL),
(7, 4, 161597689829, NULL, 6939464.82, NULL, '2024-09-05', '17:09', NULL),
(7, 5, 164822200997, NULL, 119155.12, NULL, '2024-09-05', '14:17', NULL),
(2, 8, 168046712164, NULL, 600, NULL, '2024-09-05', '14:05', NULL),
(7, 8, 171271223332, NULL, 49.61, NULL, '2024-09-05', '15:21', NULL);

-- Tabla Pago_a (Pagos comerciales a cuentas Empresa)
CREATE TABLE IF NOT EXISTS Pago_a (
    ID_CuentaOrigen INT NOT NULL,
    ID_Empresa INT NOT NULL,
    NroOperacion BIGINT PRIMARY KEY NOT NULL,
    Categoria VARCHAR(50),
    Total DECIMAL(10, 2) NOT NULL CHECK (Total > 0),
    Hora TIME NOT NULL,
    Fecha DATE NOT NULL,
    Medio_de_pago VARCHAR(16),
    FOREIGN KEY (ID_CuentaOrigen) REFERENCES Cuenta(ID_Cuenta) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (ID_Empresa) REFERENCES Empresa(ID_MercadoPago) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (Medio_de_pago) REFERENCES Tarjeta(Numero) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Pago_a (ID_CuentaOrigen, ID_Empresa, NroOperacion, Categoria, Total, Hora, Fecha, Medio_de_pago) VALUES
(4, 5, 100331977649, 'Transporte', 23000000, '08:47', '2024-09-03', '1122334455667788'),
(5, 7, 35467923135, 'Tecnología', 7000, '19:00', '2024-09-03', '0000000000000003'),
(2, 5, 98213371282, 'Transporte', 100000, '12:02', '2024-09-03', NULL),
(7, 5, 76432517632, 'Transporte', 1500000, '16:07', '2024-09-03', NULL),
(2, 5, 75373214449, 'Transporte', 1300000, '18:45', '2024-09-03', NULL),
(7, 7, 74313911265, 'Tecnología', 20000000, '06:07', '2024-09-03', NULL),
(7, 8, 73254608082, 'Tecnología', 1500000, '08:54', '2024-09-03', NULL),
(7, 5, 72195304898, 'Transporte', 9800000, '11:21', '2024-09-04', NULL),
(2, 5, 71136001715, 'Transporte', 120000, '15:04', '2024-09-04', NULL),
(7, 5, 70076698532, 'Transporte', 400000, '17:01', '2024-09-04', NULL),
(2, 5, 69017395348, 'Transporte', 250000, '19:40', '2024-09-04', NULL),
(2, 7, 67958092165, 'Tecnología', 15000000, '09:00', '2024-09-04', NULL),
(7, 8, 66898788981, 'Tecnología', 4000000, '07:33', '2024-09-04', NULL),
(2, 5, 65839485798, 'Transporte', 13943147.80, '14:21', '2024-09-05', NULL),
(2, 7, 64780182615, 'Tecnología', 6000000, '09:30', '2024-09-05', NULL),
(2, 7, 63720879431, 'Tecnología', 17895587.67, '11:41', '2024-09-05', NULL),
(7, 8, 62661576248, 'Tecnología', 12119442.74, '19:07', '2024-09-05', NULL);

-- Tabla Invierte_en (Rendimientos de inversión en FCI)
CREATE TABLE IF NOT EXISTS Invierte_en (
    ID_MercadoPago INT NOT NULL,
    ID_FCI INT NOT NULL,
    NroOperacion BIGINT PRIMARY KEY AUTO_INCREMENT,
    Monto DECIMAL(10, 2) NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    FOREIGN KEY (ID_MercadoPago) REFERENCES MercadoPago(ID_MercadoPago) 
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (ID_FCI) REFERENCES FCI(ID_FCI) 
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO Invierte_en (ID_MercadoPago, ID_FCI, NroOperacion, Monto, Fecha, Hora) VALUES
(1, 1, 1001, 6.12, '2024-09-03', '10:00:00'),
(2, 1, 1002, 20.40, '2024-09-03', '10:00:00'),
(3, 1, 1003, 20400.00, '2024-09-03', '10:00:00'),
(4, 1, 1004, 15.30, '2024-09-03', '10:00:00'),
(5, 1, 1005, 23460.00, '2024-09-03', '10:00:00'),
(6, 1, 1006, 33.15, '2024-09-03', '10:00:00'),
(7, 1, 1007, 20400.00, '2024-09-03', '10:00:00'),
(8, 1, 1008, 1530.00, '2024-09-03', '10:00:00'),
(1, 1, 1009, 10.71, '2024-09-04', '10:00:00'),
(2, 1, 1010, 14.28, '2024-09-04', '10:00:00'),
(3, 1, 1011, 20420.81, '2024-09-04', '10:00:00'),
(4, 1, 1012, 7.65, '2024-09-04', '10:00:00'),
(5, 1, 1013, 26441.93, '2024-09-04', '10:00:00'),
(6, 1, 1014, 34.71, '2024-09-04', '10:00:00'),
(7, 1, 1015, 35727.95, '2024-09-04', '10:00:00'),
(8, 1, 1016, 5611.56, '2024-09-04', '10:00:00'),
(1, 1, 1017, 13.57, '2024-09-05', '10:00:00'),
(2, 1, 1018, 7.14, '2024-09-05', '10:00:00'),
(3, 1, 1019, 20441.64, '2024-09-05', '10:00:00'),
(4, 1, 1020, 21.93, '2024-09-05', '10:00:00'),
(5, 1, 1021, 37250.30, '2024-09-05', '10:00:00'),
(6, 1, 1022, 32.53, '2024-09-05', '10:00:00'),
(7, 1, 1023, 41884.39, '2024-09-05', '10:00:00'),
(8, 1, 1024, 5615.72, '2024-09-05', '10:00:00');


-- ============================================================================
-- 2. CONSULTAS PARTE 1
-- ============================================================================

/* 1) Determinar el saldo de la billetera virtual mediante una consulta SQL, debe dar el mismo número
que el almacenado en Saldo. Deben consultar sobre las tablas donde guardan los distintos movimientos
de ingreso y egreso. */

SELECT 
    mp.ID_MercadoPago, 
    mp.Nombre_Usuario AS 'Nombre de Usuario', 
    mp.Saldo AS 'SALDO DE LA TABLA',
    (SELECT IFNULL(SUM(t.Total), 0) 
     FROM Transfiere_a t
     WHERE mp.ID_Cuenta = t.ID_CuentaDestino) +
    (SELECT IFNULL(SUM(p.Total), 0) 
     FROM Pago_a p
     WHERE mp.ID_MercadoPago = p.ID_Empresa) +
    (SELECT IFNULL(SUM(i.Monto), 0) 
     FROM Invierte_en i
     WHERE mp.ID_MercadoPago = i.ID_MercadoPago) -
    (SELECT IFNULL(SUM(t.Total), 0) 
     FROM Transfiere_a t 
     LEFT JOIN Tarjeta ta ON t.Medio_de_pago = ta.Numero
     WHERE mp.ID_Cuenta = t.ID_CuentaOrigen AND ta.Tipo = 'Dinero disponible') -
    (SELECT IFNULL(SUM(p.Total), 0) 
     FROM Pago_a p 
     LEFT JOIN Tarjeta ta ON p.Medio_de_pago = ta.Numero
     WHERE mp.ID_Cuenta = p.ID_CuentaOrigen AND ta.Tipo = 'Dinero disponible') AS 'SALDO CALCULADO'
FROM MercadoPago mp;


/* 2) Determinar con qué forma de pago se realizaron más pagos, solo mostrar la forma de pago:
Ejemplos de formas de pago: tarjeta de crédito, tarjeta de débito, billetera. */

DROP VIEW IF EXISTS Transferencia_por_Medio_de_Pago;
DROP VIEW IF EXISTS Pagos_por_Medio_de_Pago;

CREATE VIEW Transferencia_por_Medio_de_Pago AS
SELECT Tar.Tipo AS Tipos, COUNT(Tran.NroOperacion) AS Cantidad_de_Pagos 
FROM Transfiere_a AS Tran
LEFT JOIN Tarjeta AS Tar ON Tran.Medio_de_pago = Tar.Numero
WHERE Tran.Medio_de_pago IS NOT NULL
GROUP BY Tar.Tipo;

CREATE VIEW Pagos_por_Medio_de_Pago AS
SELECT Tar.Tipo AS Tipos, COUNT(Pag.NroOperacion) AS Cantidad_de_Pagos 
FROM Pago_a AS Pag
LEFT JOIN Tarjeta AS Tar ON Pag.Medio_de_pago = Tar.Numero
WHERE Pag.Medio_de_pago IS NOT NULL
GROUP BY Tar.Tipo;

WITH SumaTablas AS (
    SELECT Tipos, SUM(Cantidad_de_Pagos) AS Cantidad_Total
    FROM (
        SELECT Tipos, Cantidad_de_Pagos FROM Transferencia_por_Medio_de_Pago
        UNION ALL
        SELECT Tipos, Cantidad_de_Pagos FROM Pagos_por_Medio_de_Pago
    ) AS UnionTablas
    GROUP BY Tipos
)
SELECT Tipos, Cantidad_Total
FROM SumaTablas
WHERE Cantidad_Total = (SELECT MAX(Cantidad_Total) FROM SumaTablas);

DROP VIEW IF EXISTS Transferencia_por_Medio_de_Pago;
DROP VIEW IF EXISTS Pagos_por_Medio_de_Pago;


/* 3) Listar la identificación de las cuentas que recibieron pagos o transferencias desde nuestra cuenta.
Formato del listado: Nombre (denominación, nrocuenta, etc), Fecha movimiento, importe.
(Ejemplo configurado con ID_CuentaOrigen = 3, modificable por cualquier ID_Cuenta). */

SELECT c.Alias AS Nombre, t.Fecha AS FechaMovimiento, t.Total AS Importe 
FROM Transfiere_a AS t 
INNER JOIN Cuenta AS c ON t.ID_CuentaDestino = c.ID_Cuenta 
WHERE t.ID_CuentaOrigen = 3
UNION ALL 
SELECT ce.Alias AS Nombre, p.Fecha AS FechaMovimiento, p.Total AS Importe 
FROM Pago_a AS p
INNER JOIN MercadoPago AS mp ON p.ID_Empresa = mp.ID_MercadoPago
INNER JOIN Cuenta AS ce ON mp.ID_Cuenta = ce.ID_Cuenta 
WHERE p.ID_CuentaOrigen = 3;


/* 4) Determinar la inversión que obtuvo una cuenta entre dos fechas.
Se debe saber con exactitud qué beneficio se obtuvo por inversión. */

SELECT SUM(Monto) AS Rendimientos 
FROM Invierte_en
WHERE (Fecha BETWEEN '2024-09-03' AND '2024-09-05') 
  AND ID_MercadoPago = 1;


/* 5) Listar todas las cuentas que gastaron con billetera virtual más de X cantidad de pesos y realizaron 
más de Z movimientos entre dos fechas. Mostrar: Nombre del titular de la cuenta - algún dato de contacto:
teléfono, dirección, mail - cantidad gastada ($) - cantidad de movimientos. */

SELECT 
    CASE 
        WHEN f.Nombre_Persona IS NOT NULL THEN CONCAT(f.Nombre_Persona, ' (DNI: ', f.DNI, ')')
        ELSE CONCAT(j.Nombre_Empresa, ' (Razón Social: ', j.Razon_Social, ')')
    END AS NombreTitular,
    CONCAT('Teléfono: ', u.Telefono, ', Dirección: ', d.Direccion, ', Email: ', u.Email) AS DatosContacto,
    SUM(m.Total) AS CantidadGastada,
    COUNT(m.NroOperacion) AS CantidadMovimientos
FROM (
    SELECT t.ID_CuentaOrigen AS ID_Cuenta, t.NroOperacion, t.Total, t.Fecha 
    FROM Transfiere_a AS t
    INNER JOIN Tarjeta AS ta ON t.Medio_de_pago = ta.Numero 
    WHERE ta.Tipo = 'Dinero disponible'
    UNION ALL
    SELECT p.ID_CuentaOrigen AS ID_Cuenta, p.NroOperacion, p.Total, p.Fecha 
    FROM Pago_a AS p
    INNER JOIN Tarjeta AS ta ON p.Medio_de_pago = ta.Numero 
    WHERE ta.Tipo = 'Dinero disponible'
) AS m
INNER JOIN Cuenta AS c ON m.ID_Cuenta = c.ID_Cuenta
INNER JOIN MercadoPago AS mp ON c.ID_Cuenta = mp.ID_Cuenta 
INNER JOIN Usuario AS u ON mp.ID_Usuario = u.ID_Usuario
LEFT JOIN Direccion AS d ON u.ID_Usuario = d.ID_Usuario
LEFT JOIN Fisica AS f ON u.ID_Usuario = f.ID_Usuario
LEFT JOIN Juridica AS j ON u.ID_Usuario = j.ID_Usuario
WHERE m.Total > 0 AND m.Fecha BETWEEN '2023-01-01' AND '2025-12-31'
GROUP BY NombreTitular, DatosContacto
HAVING COUNT(m.NroOperacion) > 0 AND SUM(m.Total) > 0;


-- ============================================================================
-- 3. CONSULTAS PARTE 2 (OPERACIONES TRANSACCIONALES DML)
-- ============================================================================

/* 1) Insertar un movimiento para reflejar la transferencia de dinero de una cuenta del sistema
a otra cuenta del sistema y ejecutar los UPDATE necesarios para actualizar el valor de los saldos
de las billeteras involucradas. */

INSERT INTO Transfiere_a (ID_CuentaOrigen, ID_CuentaDestino, NroOperacion, Motivo, Total, Tipo, Fecha, Hora, Medio_de_pago) 
VALUES (1, 3, 89995552312, NULL, 500, NULL, '2024-09-07', '17:00', '0000000000000000');

UPDATE MercadoPago mp
SET mp.Saldo =
    (SELECT IFNULL(SUM(t.Total), 0) FROM Transfiere_a t WHERE mp.ID_Cuenta = t.ID_CuentaDestino) +
    (SELECT IFNULL(SUM(p.Total), 0) FROM Pago_a p WHERE mp.ID_MercadoPago = p.ID_Empresa) +
    (SELECT IFNULL(SUM(i.Monto), 0) FROM Invierte_en i WHERE mp.ID_MercadoPago = i.ID_MercadoPago) -
    (SELECT IFNULL(SUM(t.Total), 0) FROM Transfiere_a t LEFT JOIN Tarjeta ta ON t.Medio_de_pago = ta.Numero
     WHERE mp.ID_Cuenta = t.ID_CuentaOrigen AND ta.Tipo = 'Dinero disponible') -
    (SELECT IFNULL(SUM(p.Total), 0) FROM Pago_a p LEFT JOIN Tarjeta ta ON p.Medio_de_pago = ta.Numero
     WHERE mp.ID_Cuenta = p.ID_CuentaOrigen AND ta.Tipo = 'Dinero disponible')
WHERE mp.ID_MercadoPago IS NOT NULL;


/* 2) Generar el conjunto de DELETE necesarios para borrar físicamente el/los registro/s generados
en el ejercicio 1 y actualizar los saldos de las cuentas afectadas. */

DELETE FROM Transfiere_a
WHERE NroOperacion = 89995552312; 

UPDATE MercadoPago mp
SET mp.Saldo =
    (SELECT IFNULL(SUM(t.Total), 0) FROM Transfiere_a t WHERE mp.ID_Cuenta = t.ID_CuentaDestino) +
    (SELECT IFNULL(SUM(p.Total), 0) FROM Pago_a p WHERE mp.ID_MercadoPago = p.ID_Empresa) +
    (SELECT IFNULL(SUM(i.Monto), 0) FROM Invierte_en i WHERE mp.ID_MercadoPago = i.ID_MercadoPago) -
    (SELECT IFNULL(SUM(t.Total), 0) FROM Transfiere_a t LEFT JOIN Tarjeta ta ON t.Medio_de_pago = ta.Numero
     WHERE mp.ID_Cuenta = t.ID_CuentaOrigen AND ta.Tipo = 'Dinero disponible') -
    (SELECT IFNULL(SUM(p.Total), 0) FROM Pago_a p LEFT JOIN Tarjeta ta ON p.Medio_de_pago = ta.Numero
     WHERE mp.ID_Cuenta = p.ID_CuentaOrigen AND ta.Tipo = 'Dinero disponible')
WHERE mp.ID_Cuenta IN (1, 3);


/* 3) Generar el DELETE necesario para borrar una forma de pago (por ejemplo tarjeta de crédito)
del sistema, que no quede más como opción de forma de pago. Debe estar acompañado de una explicación. */

/* EXPLICACIÓN TÉCNICA:
Las tablas transaccionales Transfiere_a y Pago_a poseen una restricción de integridad referencial
(FOREIGN KEY Medio_de_pago REFERENCES Tarjeta(Numero) ON DELETE RESTRICT). 
Por lo tanto, si se intenta ejecutar directamente un DELETE sobre la tabla Tarjeta para el tipo 'Crédito',
el motor relacional rechazará la operación para proteger los movimientos históricos asociados a dichas tarjetas.
Para dar de baja definitivamente la forma de pago 'Crédito' sin destruir la trazabilidad contable de las 
transferencias y pagos ya realizados, primero desvinculamos el atributo Medio_de_pago (seteándolo en NULL) 
en las operaciones históricas afectadas y luego eliminamos físicamente las tarjetas de crédito de la tabla Tarjeta. */

UPDATE Transfiere_a 
SET Medio_de_pago = NULL 
WHERE Medio_de_pago IN (SELECT Numero FROM Tarjeta WHERE Tipo = 'Crédito');

UPDATE Pago_a 
SET Medio_de_pago = NULL 
WHERE Medio_de_pago IN (SELECT Numero FROM Tarjeta WHERE Tipo = 'Crédito');

DELETE FROM Tarjeta 
WHERE Tipo = 'Crédito';


/* 4) Generar un INSERT para agregar una cuenta completa, incluyendo las tablas de especialización
generadas en el modelo relacional. */

-- 1. Alta en supertipo Usuario:
INSERT INTO Usuario (ID_Usuario, Telefono, Email, CUIT, Condicion_Fiscal)
VALUES (125, '11-4444-7390', 'usuario125@example.com', '20-45982279-9', 'Responsable Inscripto');

-- 2. Alta en subtipo Fisica:
INSERT INTO Fisica (ID_Fisica, ID_Usuario, DNI, Nombre_Persona)
VALUES (25, 125, '45982279', 'Fernando Martin Perez');

-- 3. Alta en supertipo Cuenta:
INSERT INTO Cuenta (ID_Cuenta, Alias, CVU_CBU)
VALUES (21, 'fer.martin.144.mp', '0000007812738232000000');

-- 4. Alta en subtipo MercadoPago:
INSERT INTO MercadoPago (ID_MercadoPago, ID_Cuenta, Nombre_Usuario, Saldo, ID_Usuario, ID_FCI)
VALUES (20, 21, 'FERNANDOMARTIN281', 0.00, 125, 1);

-- 5. Alta en subtipo Personal:
INSERT INTO Personal (ID_Personal, ID_MercadoPago)
VALUES (29, 20);