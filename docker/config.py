# -*-coding:utf-8 -*-

bind = '0.0.0.0:8081'

preload_app = True

workers = 1
threads = 2
backlog = 2048

timeout = 60

# meinheld
worker_class = "egg:meinheld#gunicorn_worker"

debug=True
 
daemon = False

# 进程名称
proc_name = 'xlmp'

# 进程pid记录文件
pidfile = '/var/run/xlmp.pid'

loglevel = 'debug'
logfile = '/var/log/debug.log'
accesslog = '/var/log/access.log'
errorlog = '/var/log/error.log'
access_log_format = '%(h)s %(t)s %(U)s %(q)s'
