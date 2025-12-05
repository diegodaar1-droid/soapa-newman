#!/bin/sh

# 1. Definir variables de entorno de Coolify
SMTP_USER=${SMTP_USER:?"Debe definir SMTP_USER en Coolify"}
SMTP_PASSWORD=${SMTP_PASSWORD:?"Debe definir SMTP_PASSWORD en Coolify"}
DESTINATION_EMAIL=${DESTINATION_EMAIL:?"Debe definir DESTINATION_EMAIL en Coolify"}

# 2. Configurar SSMTP para el envío de correo (usando las variables secretas)
cat > /etc/ssmtp/ssmtp.conf << EOF
root=$SMTP_USER
mailhub=$SMTP_HOST:$SMTP_PORT
AuthUser=$SMTP_USER
AuthPass=$SMTP_PASSWORD
UseSTARTTLS=Yes
UseTLS=Yes
hostname=$SMTP_HOST
FromLineOverride=yes
EOF

# 3. Ejecutar Newman
# Línea CRÍTICA: Se agrega la bandera --ignore-failures al final
newman run SoapaCollection.json \
    -e SIOX_environment.json \
    --iteration-data cuentas.csv \
    --reporters cli,html \
    --reporter-html-export reportes/reporte.html \
    --ignore-failures

# 4. Empaquetar el reporte HTML
tar -czf reporte.tar.gz reportes/reporte.html

# 5. Enviar el correo electrónico
echo "El Job de Newman ha finalizado. Adjunto informe." | mailx \
    -s "Reporte de Pruebas Newman | $(date +%Y%m%d)" \
    -a reporte.tar.gz \
    -r "Newman Job <$SMTP_USER>" \
    "$DESTINATION_EMAIL"
