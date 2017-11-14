## xlmp
FROM alpine:3.6
LABEL maintainer="xenos <xenos.lu@gmail.com>"
# ENV TZ 'Asia/Shanghai'

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk upgrade --update

RUN apk add python3
# RUN apk add py3-bottle

## install meinheld and clean out
RUN apk add gcc libc-dev python3-dev \
    && pip3 install meinheld \
    && apk del gcc libc-dev python3-dev

RUN apk add supervisor
COPY supervisord.conf /etc/supervisord.conf

## config nginx
RUN apk add nginx \
    && mkdir /run/nginx \
    &&rm -f /etc/nginx/conf.d/default.conf
COPY xlmp.conf /etc/nginx/conf.d/

# COPY xlmp /etc/init.d/
# RUN chmod 755 /etc/init.d/xlmp


RUN apk add git
RUN git clone https://github.com/XenosLu/xlmp.git /opt/xlmp

COPY apple-touch-icon.png /opt/static/apple-touch-icon.png

CMD ["/usr/bin/supervisord"]
