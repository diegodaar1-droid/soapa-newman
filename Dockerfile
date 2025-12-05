FROM postman/newman:5-alpine

WORKDIR /etc/newman

# 1. Instalar dependencias: ssmtp, bsd-mailx (la alternativa a mailx), npm, tar/gzip.
# Eliminamos openssl ya que ssmtp lo gestiona o lo trae.
# Nota: La bandera --suppress-exit-code no es estándar en todas las versiones.
RUN apk update && \
    apk add --no-cache ssmtp bsd-mailx tar gzip && \
    npm install newman-reporter-html && \
    mkdir -p reportes && \
    rm -rf /var/cache/apk/*

COPY . .

ENTRYPOINT ["/bin/sh", "run_and_mail.sh"]
