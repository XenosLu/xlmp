## xlmp
FROM xenocider/container:python3.5.2
LABEL maintainer="xenos <xenos.lu@gmail.com>"

# ARG enable_logserver=1

RUN apk add --no-cache \
            git \
            nginx \
            dumb-init \
            # supervisor \
    && pip3 install tornado==4.5.3 \
    # && if [ "$enable_logserver" ];then apk add --no-cache rsyslog;fi \
    # && if [ "$enable_logserver" ];then echo "*.* @@nas:1514" >>/etc/rsyslog.conf;fi \
    && mkdir /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf

# copy nginx config file
COPY xlmp.conf /etc/nginx/conf.d/

# deploy script
COPY deploy /usr/local/bin
RUN chmod +x /usr/local/bin/deploy

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp

RUN chmod +x /xlmp/docker/init

EXPOSE 80

# media folder: /xlmp/media
# CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
CMD ["/xlmp/docker/init", "-v"]
