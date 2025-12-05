#!/bin/sh
# ... (Bloque de configuración de variables SMTP)

# 3. Ejecutar Newman (SIN la bandera "--ignore-failures" o "--suppress-exit-code")
# Si las pruebas fallan, Newman saldrá con código 1, pero el reporte se debería generar.
newman run SoapaCollection.json \
    -e SIOX_environment.json \
    --iteration-data cuentas.csv \
    --reporters cli,html \
    --reporter-html-export reportes/reporte.html \

# 4. Verificar si el reporte existe antes de intentar comprimirlo y enviarlo
if [ -f "reportes/reporte.html" ]; then
    tar -czf reporte.tar.gz reportes/reporte.html

    # 5. Enviar el correo electrónico
    echo "El Job de Newman ha finalizado. Adjunto informe." | mailx \
        -s "Reporte de Pruebas Newman | $(date +%Y%m%d)" \
        -a reporte.tar.gz \
        -r "Newman Job <$SMTP_USER>" \
        "$DESTINATION_EMAIL"
else
    # Si Newman falla en generar el reporte, enviaremos un correo de aviso sin adjunto
    echo "El Job de Newman falló en generar el reporte. Revisar logs." | mailx \
        -s "FALLO CRÍTICO Newman Job | $(date +%Y%m%d)" \
        -r "Newman Job <$SMTP_USER>" \
        "$DESTINATION_EMAIL"
fi
    -s "Reporte de Pruebas Newman | $(date +%Y%m%d)" \
    -a reporte.tar.gz \
    -r "Newman Job <$SMTP_USER>" \
    "$DESTINATION_EMAIL"
