FROM postman/newman:5-alpine

WORKDIR /etc/newman

# Instalamos ssmtp (el cliente de correo) y mailx (la interfaz de envío)
# junto con tar y gzip (para adjuntar archivos)
RUN apk update && \
    apk add --no-cache ssmtp mailx tar gzip && \
    mkdir -p reportes && \
    rm -rf /var/cache/apk/*

# Copiamos todos los archivos del repo (incluyendo colecciones y el nuevo script)
COPY . .

# Usamos el script para la ejecución
ENTRYPOINT ["/bin/sh", "run_and_mail.sh"]
