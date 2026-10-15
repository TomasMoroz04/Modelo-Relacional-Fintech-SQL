# 💳 Diseño y Modelado de Base de Datos Relacional — Billetera Virtual (Fintech)

Trabajo Práctico Integrador desarrollado en **MySQL** para la cátedra de **Bases de Datos** (2.° año de Ingeniería en Informática, UGD).

El proyecto modela la arquitectura de datos completa de una plataforma financiera digital (inspirada en el ecosistema de **Mercado Pago**), abarcando desde el relevamiento y modelado conceptual (DER Extendido) hasta la normalización en **Tercera Forma Normal (3FN)**, implementación física (DDL), carga de lotes transaccionales consistentes y resolución de reportes analíticos y operativos (DML).

---

## 👥 Contexto del Proyecto y Créditos

Este trabajo refleja el **esfuerzo colaborativo de 5 estudiantes** desarrollado durante nuestro segundo año en la carrera. La versión aquí publicada captura el script SQL del proyecto final entregado y defendido para la aprobación de la materia, demostrando el dominio en el diseño relacional avanzado y la resolución de consultas complejas.

**Equipo de Desarrolladores:**
* B. Benitez
* V. Calogerópulos
* P. Luna
* **Tomás Moroz** *(Curador de este repositorio)*
* J. Pereyra

---

## 🏗️ Arquitectura del Modelo de Datos

El esquema implementa **jerarquías de generalización/especialización** (transformadas mediante tablas para supertipos y subtipos vinculadas por claves foráneas con integridad referencial `ON DELETE RESTRICT`) y normalización de atributos multivaluados:

- **`Usuario` (Supertipo):** Centraliza CUIT, condición fiscal y contacto, con relación `1:N` hacia **`Direccion`** (normalización en 1FN de múltiples domicilios).
  * **`Fisica` (Subtipo):** Personas humanas (DNI y nombre completo).
  * **`Juridica` (Subtipo):** Empresas registradas (Razón social, nombre comercial y categoría PyME/Gran Empresa).
- **`Cuenta` (Supertipo):** Identifica cualquier cuenta del ecosistema financiero mediante `Alias` y `CVU_CBU` únicos.
  * **`Externa` (Subtipo):** Cuentas bancarias tradicionales (CBU) que interactúan con la plataforma.
  * **`MercadoPago` (Subtipo):** Billeteras virtuales internas con gestión de saldo y vinculación a fondos de inversión. Se especializa a su vez en:
    * **`Personal`:** Cuentas de individuos.
    * **`Empresa`:** Cuentas comercios habilitadas para recibir cobros.
- **Medios de Pago e Inversiones:**
  * **`Tarjeta`:** Tarjetas de crédito, débito y saldo en cuenta (`Dinero disponible`) asociadas a cada billetera.
  * **`FCI` e `Invierte_en`:** Administración de Fondos Comunes de Inversión y registro diario de rendimientos devengados.
- **Motor Transaccional:**
  * **`Transfiere_a`:** Transferencias entre cuentas (internas o externas) con validación de montos positivos (`CHECK (Total > 0)`).
  * **`Pago_a`:** Pagos comerciales desde cuentas origen hacia cuentas `Empresa` categorizados por rubro.

---

## 📊 Consultas y Operaciones Resueltas (`Script_MP.sql`)

### Parte 1: Consultas Analíticas y Auditoría
1. **Conciliación contable de saldos:** Cálculo dinámico del saldo de cada billetera cruzando subconsultas correlacionadas de ingresos (`Transfiere_a`, `Pago_a`, `Invierte_en`) menos egresos abonados con dinero en cuenta, verificando su exactitud frente al saldo persistido.
2. **Ranking de medios de pago:** Uso de Vistas (`CREATE VIEW`), `UNION ALL` y Common Table Expressions (`WITH ... AS`) para determinar la forma de pago más utilizada en toda la plataforma.
3. **Historial unificado de destinatarios:** Trazabilidad de transferencias y pagos comerciales emitidos por una cuenta origen.
4. **Cálculo de rendimientos financieros:** Suma de beneficios obtenidos por inversión en FCI dentro de una ventana de fechas (`BETWEEN`).
5. **Reporte de actividad y auditoría de usuarios:** Consulta compleja con `CASE WHEN`, `CONCAT`, múltiples `LEFT/INNER JOIN`, `GROUP BY` y `HAVING` que unifica titulares físicos y jurídicos filtrando por volumen de gasto y cantidad de operaciones.

### Parte 2: Operaciones Transaccionales (DML)
- Registro de transferencias entre billeteras con recalculo y actualización masiva de saldos (`INSERT` + `UPDATE` con subconsultas).
- Reversión física de operaciones y recálculo consistente de las cuentas afectadas (`DELETE` + `UPDATE`).
- Baja controlada de medios de pago respetando restricciones de integridad referencial (`ON DELETE RESTRICT`).
- Alta transaccional en cascada de un nuevo cliente recorriendo toda la jerarquía de especialización (`Usuario` $\rightarrow$ `Fisica` $\rightarrow$ `Cuenta` $\rightarrow$ `MercadoPago` $\rightarrow$ `Personal`).

---

## 🚀 Cómo ejecutar el script

1. Abrí **MySQL Workbench** (o tu cliente MySQL/MariaDB preferido).
2. Ejecutá el archivo `Script_MP.sql` completo: el script creará automáticamente el esquema `mercadopago`, las 13 tablas con sus restricciones, los lotes de prueba y ejecutará las consultas de verificación.
