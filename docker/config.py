# -*-coding:utf-8 -*-

# 监听本机的8081端口  
bind = '0.0.0.0:8081'  

preload_app = True  

# 开启进程 
workers = 1  

# 每个进程的开启线程  
threads = 2  

backlog = 2048  

timeout = 60

#工作模式为meinheld  
worker_class = "egg:meinheld#gunicorn_worker"  

# debug=True

# 如果不使用supervisord之类的进程管理工具可以是进程成为守护进程，否则会出问题  
daemon = False

# 进程名称
proc_name = 'xlmp'

# 进程pid记录文件
pidfile = 'app.pid'

loglevel = 'debug'
logfile = 'debug.log'
accesslog = 'access.log'
errorlog = 'error.log'
access_log_format = '%(h)s %(t)s %(U)s %(q)s'
