#!/bin/bash
set -e

cd /etc/ssl
if [ "${AUTOSIGNED_CERT}" = "1" ] && [ ! -e "localhost.cert.pem" ]; then

    SUBJECT="/C=FR/ST=Calvados/L=Caen/O=Zephyr-web SAS/OU=IT/CN=${NAMESERVER}"

    echo "Generate key..."
    openssl genrsa -out ./private/localhost.key.pem 2048
    chmod 666 ./private/localhost.key.pem

    if [ -f "./certs/intermediate.cert.pem" ]; then
        if [ ! -e "./index.txt" ] || [ ! -e "./serial" ]; then
            touch ./index.txt
            echo 1000 > ./serial
        fi;

        echo "Generate CSR..."
        openssl req -config ./openssl.cnf -key ./private/localhost.key.pem -new -sha256 -out ./csr/localhost.csr.pem -subj "${SUBJECT}"
        chmod 666 ./csr/localhost.csr.pem

        echo "Generate server certificate..."
        openssl ca -batch -config ./openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in ./csr/localhost.csr.pem -out ./certs/localhost.cert.pem
        chmod 666 ./certs/localhost.cert.pem
        echo "OK"
    else
        echo "Generate autosigned certificate..."
        openssl req -x509 -key ./private/localhost.key.pem -days 375 -new -sha256 -out ./certs/localhost.cert.pem -subj "${SUBJECT}"
        echo "OK"
    fi;
fi;
cd ~

if [ -f "/etc/apache2/conf-available/php-fpm.conf" ] && [ ! -e "/etc/apache2/conf-enabled/php-fpm.conf" ]; then
    a2enconf php-fpm;
fi;
if [ -f "/etc/apache2/conf-available/security.conf" ] && [ ! -e "/etc/apache2/conf-enabled/security.conf" ]; then
    a2enconf security;
fi;
if [ -f "/etc/apache2/sites-available/vhost.conf" ] && [ ! -e "/etc/apache2/sites-enabled/vhost.conf" ]; then
    a2ensite vhost;
fi;
if [ -f "/etc/apache2/sites-available/vhost-ssl.conf" ] && [ ! -e "/etc/apache2/sites-enabled/vhost-ssl.conf" ]; then
    a2ensite vhost-ssl;
fi;

exec "$@"
