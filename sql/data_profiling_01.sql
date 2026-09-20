USE Melbourne_PropTech;
GO 
--1: AGNÓSTICO DE DATOS

--Volumen total de registros que se cargaron 
SELECT COUNT(*) AS Total_registros FROM melbourne_raw;

-- Cantidad de casas con al menos un dato nulo clave
SELECT COUNT(*) FROM melbourne_raw 
WHERE Price IS NULL OR  BuildingArea IS NULL OR YearBuilt IS NULL; 

--Casas	con datos clave completos 
SELECT COUNT(*) FROM melbourne_raw 
WHERE Price IS NOT NULL AND BuildingArea IS NOT NULL AND YearBuilt IS NOT NULL;


--Contamos los nulos de una de estas columnas y sacamos porcentaje
SELECT 
	--Conteos 
	SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Price_nulls,
    SUM(CASE WHEN BuildingArea IS NULL THEN 1 ELSE 0 END) AS BuildingArea_nulls,
    SUM(CASE WHEN YearBuilt IS NULL THEN 1 ELSE 0 END) AS YearBuilt_nulls,

	--Porcentaje
	ROUND((SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) * 100.0)/COUNT(*),2) AS Price_nulls_percentage,
	ROUND((SUM(CASE WHEN BuildingArea IS NULL THEN 1 ELSE 0 END) * 100.0)/COUNT(*),2) AS BuildingArea_nulls_percentage,
	ROUND((SUM(CASE WHEN YearBuilt IS NULL THEN 1 ELSE 0 END) * 100.0)/COUNT(*),2) AS YearBuilt_nulls_percentage
FROM melbourne_raw; 


