FROM alpine:3.14

RUN apk update && apk upgrade && apk add bash && apk add nginx && apk add php8 php8-fpm php8-opcache && apk add php8-gd php8-zlib php8-curl

COPY server/etc/nginx /etc/nginx
COPY server/etc/php /etc/php8
COPY src /usr/share/nginx/html
RUN mkdir /var/run/php
EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm8 && chmod 777 /var/run/php/php8-fpm.sock && chmod 755 /usr/share/nginx/html/* && nginx -g 'daemon off;'"]