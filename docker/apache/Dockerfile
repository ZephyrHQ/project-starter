FROM ubuntu:latest

LABEL maintainer="Thomas Talbot <thomas.talbot@zephyr-web.fr>"

ARG DEBIAN_FRONTEND=noninteractive

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE ${APACHE_RUN_DIR}/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen fr_FR.UTF-8

ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
ENV LC_ALL fr_FR.UTF-8

RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get install --no-install-recommends -y \
        software-properties-common \
    && add-apt-repository -y ppa:ondrej/apache2 \
    && apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        openssl \
        apache2 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p ${APACHE_RUN_DIR} ${APACHE_LOCK_DIR} ${APACHE_LOG_DIR} /etc/ssl/certs \
    ;

RUN echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
RUN a2dissite 000-default \
    && a2enmod proxy_fcgi \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ssl \
    && a2enmod http2 \
    && a2enconf fqdn \
    ;

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

WORKDIR /var/www/html

EXPOSE 80 443
ENTRYPOINT ["entrypoint"]
CMD ["/usr/sbin/apache2", "-DFOREGROUND"]
