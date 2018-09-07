#!/bin/sh
set -e

# exec something
exec /usr/sbin/nginx -g 'daemon off;' &
exec /usr/bin/python3 /xlmp/xlmp.py

exec "$@"

while true
    do echo waiting...
    sleep 1
done
