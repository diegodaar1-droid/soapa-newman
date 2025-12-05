FROM postman/newman:5-alpine

WORKDIR /etc/newman

# 1. Instalar dependencias de correo, ssmtp y openssl para SSL/TLS
# Ya no incluimos 'mailutils'
RUN apk update && \
    apk add --no-cache ssmtp openssl tar gzip mailx && \
    rm -rf /var/cache/apk/*

# 2. INSTALACIÓN CRÍTICA: Instalar el reportero HTML
RUN npm install newman-reporter-html

# 3. Crear el directorio de reportes
RUN mkdir -p reportes

COPY . .

ENTRYPOINT ["/bin/sh", "run_and_mail.sh"]
