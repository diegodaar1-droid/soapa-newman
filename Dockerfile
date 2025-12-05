FROM postman/newman:5-alpine

WORKDIR /etc/newman

# PASO CLAVE: Crear el directorio de reportes para que Newman pueda escribir.
RUN mkdir -p reportes

COPY . .

# Se ejecuta Newman
ENTRYPOINT ["newman", "run", "SoapaCollection.json", "-e", "SIOX_environment.json", "--iteration-data", "cuentas.csv", "--reporters", "cli,html", "--reporter-html-export", "reporte.html"]
