FROM postman/newman:5-alpine

WORKDIR /etc/newman

# 1. Instalar dependencias de correo y utilidades
# 'mailutils' es el paquete Alpine que incluye mailx
# 'tar' y 'gzip' ya estaban, pero los incluimos para asegurar
RUN apk update && \
    apk add --no-cache ssmtp mailutils tar gzip && \
    rm -rf /var/cache/apk/*

# 2. INSTALACIÓN CRÍTICA: Instalar el reportero HTML
RUN npm install newman-reporter-html

# 3. Crear el directorio de reportes (Esto ya lo teníamos y es correcto)
RUN mkdir -p reportes

COPY . .

ENTRYPOINT ["/bin/sh", "run_and_mail.sh"]
