FROM alpine:3.7
LABEL maintainer="pete@digitalidentitylabs.com"

RUN  apk add --update --no-cache \
     php7-apache2 && \
	 mkdir -p /run/apache2 && chown apache /run/apache2 && \
	 rm -f /var/www/localhost/htdocs/index.html

COPY source/index.php /var/www/localhost/htdocs/
COPY source/qndinfo.conf  /etc/apache2/conf.d/


USER root
EXPOSE 80 443

ENTRYPOINT httpd -f /etc/apache2/httpd.conf -DFOREGROUND
