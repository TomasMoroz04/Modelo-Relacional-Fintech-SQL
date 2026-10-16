<h1 align="center">💳 Modelo Relacional de una Fintech</h1>
<h3 align="center">Diseño de base de datos para una billetera virtual</h3>

<p align="center">
  <img src="https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="SQL">
  <img src="https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL">
  <img src="https://img.shields.io/badge/Modelado-Relacional-6C5CE7?style=for-the-badge" alt="Modelado relacional">
  <img src="https://img.shields.io/badge/Normalización-3FN-00897B?style=for-the-badge" alt="Tercera forma normal">
</p>

Trabajo Práctico Integrador desarrollado en **MySQL** para la cátedra de **Bases de Datos** (2.° año de Ingeniería en Informática, UGD).

El proyecto modela la arquitectura de datos de una plataforma financiera digital inspirada en el ecosistema de **Mercado Pago**. Abarca desde el relevamiento y el modelado conceptual —DER extendido— hasta la normalización en **Tercera Forma Normal (3FN)**, la implementación física mediante DDL, la carga de lotes transaccionales consistentes y la resolución de consultas analíticas y operativas con DML.

---

## 📑 Índice

- [Contexto y créditos](#-contexto-del-proyecto-y-créditos)
- [Arquitectura del modelo](#-arquitectura-del-modelo-de-datos)
- [Consultas analíticas y auditoría](#-consultas-y-operaciones-resueltas)
- [Operaciones transaccionales](#-parte-2-operaciones-transaccionales-dml)
- [Ejecución del script](#-cómo-ejecutar-el-script)

---

## 👥 Contexto del proyecto y créditos

Este trabajo refleja el **esfuerzo colaborativo de cinco estudiantes**, desarrollado durante nuestro segundo año de carrera. La versión publicada contiene el script SQL del proyecto final entregado y defendido para la aprobación de la materia, demostrando el dominio del diseño relacional avanzado y la resolución de consultas complejas.

**Equipo de desarrolladores:**

- B. Benitez
- V. Calogerópulos
- P. Luna
- **Tomás Moroz** — curador de este repositorio
- J. Pereyra

---

## 🏗️ Arquitectura del modelo de datos

El esquema implementa **jerarquías de generalización y especialización**, representadas mediante tablas de supertipos y subtipos vinculadas por claves foráneas. Se contemplan restricciones de integridad referencial como `ON DELETE RESTRICT` y la normalización de atributos multivaluados.

### 👤 Usuarios

- **`Usuario` (supertipo):** centraliza CUIT, condición fiscal y contacto. Tiene una relación `1:N` con `Direccion` para registrar múltiples domicilios normalizados.
- **`Fisica` (subtipo):** representa personas humanas mediante DNI y nombre completo.
- **`Juridica` (subtipo):** representa empresas con razón social, nombre comercial y categoría —PyME o Gran Empresa—.

### 💼 Cuentas

- **`Cuenta` (supertipo):** identifica cuentas del ecosistema financiero mediante `Alias` y `CVU_CBU` únicos.
- **`Externa` (subtipo):** representa cuentas bancarias tradicionales vinculadas mediante CBU.
- **`MercadoPago` (subtipo):** modela billeteras virtuales internas, con administración de saldo y vínculo con fondos de inversión.
  - **`Personal`:** cuentas de individuos.
  - **`Empresa`:** cuentas de comercios habilitadas para recibir cobros.

### 💳 Medios de pago e inversiones

- **`Tarjeta`:** contempla tarjetas de crédito, débito y saldo en cuenta (`Dinero disponible`) asociado a cada billetera.
- **`FCI` e `Invierte_en`:** representan los Fondos Comunes de Inversión y el registro diario de rendimientos devengados.

### 🔁 Motor transaccional

- **`Transfiere_a`:** registra transferencias entre cuentas internas o externas, validando montos positivos mediante `CHECK (Total > 0)`.
- **`Pago_a`:** registra pagos comerciales desde cuentas de origen hacia cuentas `Empresa`, categorizados por rubro.

---

## 📊 Consultas y operaciones resueltas

El archivo principal del proyecto es `Script_MP.sql`.

### Parte 1: consultas analíticas y auditoría

1. **Conciliación contable de saldos:** cálculo dinámico de los saldos de cada billetera, cruzando ingresos (`Transfiere_a`, `Pago_a`, `Invierte_en`) y egresos abonados con dinero en cuenta para contrastarlos con el saldo persistido.
2. **Ranking de medios de pago:** uso de vistas (`CREATE VIEW`), `UNION ALL` y expresiones de tabla comunes (`WITH ... AS`) para identificar los medios de pago más utilizados.
3. **Historial unificado de destinatarios:** trazabilidad de transferencias y pagos comerciales emitidos desde una cuenta.
4. **Cálculo de rendimientos financieros:** suma de beneficios obtenidos por inversiones en FCI dentro de una ventana temporal (`BETWEEN`).
5. **Reporte de actividad y auditoría de usuarios:** consulta con `CASE WHEN`, `CONCAT`, `LEFT JOIN`, `INNER JOIN`, `GROUP BY` y `HAVING` para unificar titulares físicos y jurídicos, aplicando filtros por volumen de gasto y cantidad de operaciones.

### Parte 2: operaciones transaccionales (DML)

- Registro de transferencias entre billeteras mediante `INSERT` y actualización masiva de saldos con `UPDATE` y subconsultas.
- Reversión de operaciones mediante `DELETE` y recálculo consistente de las cuentas afectadas.
- Baja controlada de medios de pago respetando la integridad referencial (`ON DELETE RESTRICT`).
- Alta transaccional en cascada de un nuevo cliente recorriendo la jerarquía de especialización: `Usuario` → `Fisica` → `Cuenta` → `MercadoPago` → `Personal`.

---

## 🚀 Cómo ejecutar el script

1. Abrí **MySQL Workbench** o un cliente compatible con MySQL.
2. Abrí el archivo `Script_MP.sql`.
3. Ejecutá el script completo.

El script está diseñado para crear el esquema `mercadopago`, definir las 13 tablas con sus restricciones, cargar los lotes de prueba y ejecutar las consultas de verificación.

> **Recomendación:** ejecutalo en una base de datos de prueba, ya que contiene operaciones de creación, inserción, actualización y eliminación de registros.

---

<p align="center"><b>Bases de Datos · MySQL · Modelado relacional · SQL analítico y transaccional</b></p>
