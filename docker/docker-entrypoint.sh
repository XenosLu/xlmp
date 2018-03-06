#!/bin/sh

set -e

# exec something

exec /usr/bin/python3 /xlmp/xlmp.py &
exec /usr/sbin/nginx -g 'daemon off;'

exec "$@"
