FROM alpine:3.7

LABEL description="A quick and crude way to debug reverse proxies using PHPInfo" \
      version="0.1.0" \
      maintainer="pete@digitalidentitylabs.com"

RUN  apk add --update --no-cache \
     php7-apache2 && \
	 mkdir -p /run/apache2 && chown apache /run/apache2 && \
	 rm -f /var/www/localhost/htdocs/index.html && \
	 ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
     ln -sf /proc/self/fd/1 /var/log/apache2/error.log  && \
     ln -sf /proc/self/fd/1 /var/log/apache2/other_vhosts_access.log

COPY source/index.php /var/www/localhost/htdocs/
COPY source/qndinfo.conf  /etc/apache2/conf.d/


USER root
EXPOSE 80

ENTRYPOINT sleep 3 && httpd -f /etc/apache2/httpd.conf -DFOREGROUND

HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://localhost:8080/anything_at_all || exit 1