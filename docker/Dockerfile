## xlmp
FROM xenocider/container:meinheld
LABEL maintainer="xenos <xenos.lu@gmail.com>"

RUN apk add --no-cache git \
    && apk add  --no-cache supervisor \
    && apk add  --no-cache nginx \
    && mkdir /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache

# RUN apk add py3-bottle

# copy nginx config file
COPY xlmp.conf /etc/nginx/conf.d/

# deploy script
COPY deploy /usr/local/bin
RUN chmod +x /usr/local/bin/deploy

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp

# VOL /xlmp/media

CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
