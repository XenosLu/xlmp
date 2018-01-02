## xlmp
FROM alpine:3.6
LABEL maintainer="xenos <xenos.lu@gmail.com>"
ENV TZ 'Asia/Shanghai'

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add tzdata --update \
    && apk add python3 \
    && apk add gcc libc-dev python3-dev \
    && pip3 install meinheld \
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
    && rm -rf /var/cache/apk/* /tmp/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
    
# RUN apk add py3-bottle
# supervisord config file
# COPY supervisord.conf /etc/supervisord.conf
# nginx config file
COPY xlmp.conf /etc/nginx/conf.d/
# web icon for IOS used by nginx
COPY apple-touch-icon.png /static/apple-touch-icon.png
# deploy script
COPY deploy /bin
RUN chmod +x /bin/deploy

# COPY xlmp /etc/init.d/
# RUN chmod +x /etc/init.d/xlmp

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp
# VOL /xlmp/media

CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
