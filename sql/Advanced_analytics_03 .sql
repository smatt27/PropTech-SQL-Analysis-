USE Melbourne_PropTech 
GO 

--Calculamos precio promedio y mostramos los 5 primeros resultados 
SELECT TOP 5 Suburb, ROUND(AVG(price), 2) AS mean_price 
FROM v_melbourne_clean
GROUP BY Suburb 
ORDER BY mean_price DESC; 

--Ahora lo hacemos pero teniendo en cuenta em m2 para evitar sesgos. 
SELECT TOP 5 Suburb, ROUND(AVG(Price/BuildingArea), 2) AS mean_pricre_m2 
FROM v_melbourne_clean
WHERE BuildingArea IS NOT NULL
GROUP BY Suburb 
ORDER BY mean_pricre_m2 DESC 

-- Analisis temporal (Ventas por año y precio promedio)
SELECT YEAR(Date) AS Anio,
COUNT(*) AS Total_ventas,
ROUND(AVG(Price), 2) AS mean_price 
FROM v_melbourne_clean 
GROUP BY YEAR(Date) 
ORDER BY Anio ASC; 

-- Creamos una tabla virtual y calcamos rankings // Después extraemos las primeras dos posiciones de cada Suburb 
WITH RankedProperties AS (
    SELECT 
        Suburb,
        Address,
        Price,
        DENSE_RANK() OVER(PARTITION BY Suburb ORDER BY Price DESC) AS Posicion
    FROM v_melbourne_clean
)
SELECT 
    Suburb,
    Address,
    Price,
    Posicion
FROM RankedProperties
WHERE Posicion <= 2
ORDER BY Suburb, Posicion;

