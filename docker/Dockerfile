## xlmp
FROM xenocider/container:python3.5.2
LABEL maintainer="xenos <xenos.lu@gmail.com>"

RUN apk add --no-cache \
            git \
            nginx \
            dumb-init \
            # supervisor \
    && pip3 install tornado==4.5.3 \
    && mkdir /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf

# copy nginx config file
COPY xlmp.conf /etc/nginx/conf.d/

# deploy script
COPY deploy /usr/local/bin
RUN chmod +x /usr/local/bin/deploy

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp

EXPOSE 80

# media folder:
# VOLUME /xlmp/media

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
# CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
CMD ["/usr/bin/dumb-init", "/bin/sh", "/xlmp/docker/init"]
