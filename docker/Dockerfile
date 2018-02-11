## xlmp
FROM xenocider/container:bottle-env
LABEL maintainer="xenos <xenos.lu@gmail.com>"

RUN apk add --no-cache git \
    && apk add --no-cache supervisor \
    && apk add --no-cache nginx \
    && apk add --no-cache rsyslog \
    && echo "*.* @@nas:1514" >>/etc/rsyslog.conf \
    && mkdir /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf

# copy nginx config file
COPY xlmp.conf /etc/nginx/conf.d/

# deploy script
COPY deploy /usr/local/bin
RUN chmod +x /usr/local/bin/deploy

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp
# RUN git clone https://github.com/XenosLu/dlnap.git /tmp/dlnap

EXPOSE 80

# media folder: /xlmp/media
CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
