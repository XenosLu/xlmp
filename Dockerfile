## xlmp
FROM python:3.8.13-alpine3.14
LABEL maintainer="xenos <xenos.lu@gmail.com>"

            # runit \
# supervisor 3.3.4 not support python3
RUN apk add --no-cache \
            git \
            nginx \
            s6 &&\
    pip3 install tornado==5.1.1 &&\
    pip3 install xmltodict==0.11.0 &&\
    mkdir -p /run/nginx &&\
    rm -f /etc/nginx/http.d/default.conf

# copy nginx config file
COPY docker/xlmp.conf /etc/nginx/http.d/

# deploy script
COPY docker/deploy /usr/local/bin

# git clone
RUN git clone https://github.com/XenosLu/xlmp.git /xlmp

EXPOSE 80

# media folder:
VOLUME /xlmp/media

# CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
CMD ["/bin/s6-svscan", "/xlmp/docker/s6/"]
