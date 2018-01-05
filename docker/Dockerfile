## xlmp
# FROM alpine:3.7 164.6MB
# 168.2MB
FROM alpine:3.5

LABEL maintainer="xenos <xenos.lu@gmail.com>"
ENV TZ 'Asia/Shanghai'

RUN apk add tzdata --update \
    && apk add python3 \
    && apk add gcc libc-dev python3-dev \
    && pip3 install meinheld==0.6.1 \
    && pip3 install pycrypto \
    # && pip3 install pycryptodome==3.4.7 \
    && pip3 install you-get \
    && apk add ffmpeg \
    && apk add curl \
    # && pip3 install gunicorn \
    && apk del gcc libc-dev python3-dev \
    && apk add git \
    && apk add supervisor \
    && apk add nginx \
    && mkdir /run/nginx \
    && rm -f /etc/nginx/conf.d/default.conf \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN apk add py3-bottle

# copy nginx config file
COPY xlmp.conf /etc/nginx/conf.d/

# web icon for IOS used by nginx
# COPY apple-touch-icon.png /static/apple-touch-icon.png

# deploy script
COPY deploy /bin
RUN chmod +x /bin/deploy

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp

# VOL /xlmp/media

CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
