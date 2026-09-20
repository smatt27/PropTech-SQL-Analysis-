import os 
import pandas as pd
import urllib 
from sqlalchemy import create_engine 

#1. Ruta del archivo y lo leemos. 
csv_path = r"C:\Users\Milar\Desktop\proyectos\Proyecto_PropTech-20260717T154935Z-1-001\Proyecto_PropTech\archive\Melbourne_housing_FULL.csv"

print("Leyendo el archivo CSV")

try:
    # Intenta leer con auto-detección de separador. 
    df = pd.read_csv(
        csv_path, 
        sep=None,            # Detecta si usan comas, ';' o tabulaciones
        engine='python',     
        on_bad_lines='skip', # Si una fila viene corrupta lo salta. 
        encoding='utf-8'
    )
except UnicodeDecodeError:
    # Si falla por caracteres especiales del archivo de Windows
    df = pd.read_csv(
        csv_path, 
        sep=None, 
        engine='python', 
        on_bad_lines='skip', 
        encoding='latin1'
    )


print(f"Archivo leído con éxito. Se encontraron {len(df)} filas y {len(df.columns)}")

#2. Limpieza de columnas  
df.columns = df.columns.str.strip().str.replace(' ', '_').str.replace('-', '_')

#3. Configuración de la conexión con SQL serv. 
server = r"DESKTOP-8J3BL0V\SQLEXPRESS"
database = "Melbourne_PropTech"

#4.Creamos una cadena de conexión compatible con Alchemy
params = urllib.parse.quote_plus(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    f"Trusted_Connection=yes;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

#5. Datos 
print(f"Iniciando la carga de {len(df)} filas en SQL Server")
try: 
    #Se crea la tabla "merlbourne_raw" con los datos limpios 
    df.to_sql(name="melbourne_raw", con=engine, if_exists="replace", index=False)
    print("Ingreso completado, tabla lista!!")

except Exception as e:
    print(f"Error {e} durante la carga")

