FROM postman/newman:5-alpine

WORKDIR /etc/newman

COPY . .

ENTRYPOINT ["newman", "run", "SoapaCollection.json", "-e", "SIOX_environment.json", "--iteration-data", "cuentas.csv", "--reporters", "cli,html", "--reporter-html-export", "reportes/reporte.html"]
