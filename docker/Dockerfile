## xlmp
FROM alpine:3.6
LABEL maintainer="xenos <xenos.lu@gmail.com>"
# ENV TZ 'Asia/Shanghai'

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk upgrade --update \
    && apk add python3 \
    && apk add gcc libc-dev python3-dev \
    && pip3 install meinheld \
    && apk del gcc libc-dev python3-dev \
    && apk add git \
    && apk add supervisor \
    && apk add nginx \
    && mkdir /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf \
    && rm -rf /var/cache/apk/* /tmp/*

# RUN apk add python3
# RUN apk add py3-bottle
# supervisord config file
COPY supervisord.conf /etc/supervisord.conf
# nginx config file
COPY xlmp.conf /etc/nginx/conf.d/
# web icon for ios used by nginx
COPY apple-touch-icon.png /opt/static/apple-touch-icon.png

COPY deploy /bin
RUN chmod 755 /bin/deploy

# COPY xlmp /etc/init.d/
# RUN chmod 755 /etc/init.d/xlmp


# RUN apk add git
RUN git clone https://github.com/XenosLu/xlmp.git /opt/xlmp


VOLUME ["/data"]

CMD ["/usr/bin/supervisord"]
