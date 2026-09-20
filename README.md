# Proyecto PropTech: Análisis Inmobiliario de Melbourne en SQL Server

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-005571?style=for-the-badge)

## Descripción del Proyecto
Este proyecto simula un entorno real de análisis de datos para el sector inmobiliario (PropTech). Utilizando **SQL Server (T-SQL)**, se procesó un dataset de ventas de propiedades en Melbourne (Australia) de más de 34,000 registros. 

El objetivo principal fue auditar la calidad de los datos crudos (*Data Profiling*), diseñar una capa de datos limpios preservando el linaje (*Data Cleaning & Views*), y responder preguntas complejas de negocio utilizando SQL Avanzado (*Advanced Analytics*).

Se construyó un pipeline de datos usando Python (pandas y SQLAlchemy) para automatizar la ingesta del dataset crudo hacia Microsoft SQL Server, habilitando el posterior análisis estructurado en T-SQL.

---

## Tecnologías y Conceptos Aplicados
* **Motor de Base de Datos:** Microsoft SQL Server (SSMS).
* **Técnicas DDL/DML:** `ALTER TABLE`, `UPDATE`, `CREATE VIEW`.
* **Transformación Segura:** `TRY_CONVERT` para control de errores en tipos de datos.
* **SQL Avanzado:** Agregaciones temporales, Common Table Expressions (CTEs) y Funciones de Ventana (`DENSE_RANK`, `PARTITION BY`).

---

## Estructura del Proyecto y Fases

### Fase 1: Data Profiling (`01_data_profiling.sql`)
Diagnóstico inicial de la tabla cruda (`melbourne_raw`) para evaluar la calidad del dato:
* Contabilización de valores `NULL` utilizando `SUM(CASE WHEN...)`.
* Cálculo de porcentajes de completitud de datos superando la limitación de la división de enteros en SQL (multiplicación por `100.0` y `ROUND`).
* *Hallazgo:* Variables críticas como `Price` tenían un 21.8% de valores nulos, y `BuildingArea` superaba el 60%, dictando la estrategia de limpieza.

### Fase 2: Data Cleaning y Capa Curada (`02_data_cleaning.sql`)
Transformación de tipos de datos y manejo de anomalías físicas:
* Conversión de cadenas de texto a formato fecha estándar (`DATE`) mediante la función `TRY_CONVERT(DATE, Date, 103)`.
* Detección de valores anómalos: 76 propiedades con `0 m²` y 5 registros con años de construcción imposibles.
* **Creación de `v_melbourne_clean`:** Se implementó una **Vista (VIEW)** como capa semántica (Curated Layer). Esto permite filtrar los datos sucios (fechas anómalas, nulos críticos) sin destruir la tabla original, preservando la trazabilidad (*Data Lineage*).

### Fase 3: Analítica Avanzada (`03_advanced_analytics.sql`)
Ejecución de consultas de negocio directamente sobre la vista limpia:
1. **Métricas de Mercado:** Identificación de los 5 barrios más exclusivos utilizando `GROUP BY` y promedios.
2. **Eficiencia por m²:** Cálculo del precio medio por metro cuadrado para aislar el sesgo del tamaño de las propiedades.
3. **Análisis Temporal:** Evolución histórica del volumen de ventas y fluctuación de precios agrupando por `YEAR(Date)`.
4. **Ranking Particionado:** Uso de CTEs (`WITH`) y funciones de ventana (`DENSE_RANK() OVER(PARTITION BY...)`) para extraer el Top 2 de propiedades más caras de cada barrio individual.

---

## 🚀 Cómo ejecutar este proyecto
1. Restaurar la base de datos o importar el CSV a una tabla llamada `melbourne_raw`.
2. Ejecutar los scripts en orden secuencial (01, 02, 03).
3. Asegurarse de ejecutar la creación de la vista en el script `02` antes de lanzar las consultas analíticas del script `03`.