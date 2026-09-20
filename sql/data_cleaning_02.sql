USE Melbourne_PropTech 
GO 

--SELECT TOP 5 Date FROM melbourne_raw; (Pra fijarnos en que formato esta la fecha)


-- Cómo a se almacenan como texto para evitar fallos en ordenaciones pasamos los datos a un tipo fecha. 
-- Probamos y comparamos las dos columnas para ver que este todo correcto 
--SELECT TOP 10 
    --Date AS Fecha_Original_Text, 
    --TRY_CONVERT(DATE, Date, 103) AS Fecha_Limpia_Date
--FROM melbourne_raw;

-- Creamos una nueva columna 
--ALTER TABLE melbourne_raw 
--ADD Date_clean DATE; 
-- La llenamos con los datos convertidos
--UPDATE melbourne_raw 
--SET Date_clean = TRY_CONVERT(DATE, Date, 103);

--SELECT
    -- Casas con metros cuadrados iguial a 0 y Aós de construcciones imposibles. 
    --SUM(CASE WHEN BuildingArea = 0 THEN 1 ELSE 0 END) AS Casas_Area_Cero, 
    --SUM(CASE WHEN YearBuilt < 1835 OR YearBuilt > YEAR(GETDATE()) THEN 1 ELSE 0 END) AS Y_Imposibles

--FROM melbourne_raw; (Dio 76 Casas con area 0 y 5 con años fuera de lugar)

-- Creación de una capa limpia de análisis
CREATE VIEW v_melbourne_clean AS
SELECT 
    Suburb,
    Address,
    Rooms,
    Type,
    Price,
    Method,
    SellerG,
    Date_Clean AS Date, 
    Distance,
    Postcode,
    Bedroom2,
    Bathroom,
    Car,
    Landsize,
    BuildingArea,
    YearBuilt,
    Regionname,
    Propertycount
FROM melbourne_raw
WHERE 
    Price IS NOT NULL 
    AND (BuildingArea IS NULL OR BuildingArea > 0) 
    AND (YearBuilt IS NULL OR (YearBuilt >= 1835 AND YearBuilt <= YEAR(GETDATE())));
GO 



