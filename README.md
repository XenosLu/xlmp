# xlmp - Xenos' Light media player
### xlmp is a light web based media player. Original developed in PHP, rewrote in Python3.
### it can support 
### You can play media video from other device through any html5 web browser in your LAN.

### I'm working on to add dlna playback support, and already works in an ungracefully way.
### It can achieve the DMC + DMS Roles in DLNA
## install steps:
### 1. install Python3.4.4(suggested)
### 2. run 'python player.py' as a debug demo server
### 3. use adapter.wsgi as a standard WSGI program
### 4. In OS Windows, you can use Apache and modWSGI to make it works perfectly. In other OS, there are plenty of wsgi server choices.
### 

## Filelist:
+ LICENSE         license file 	
+ README.md       readme
+ adapter.wsgi    wsgi adapter
+ xlmp.py 	      main
+ views/          html template
+ player.db       auto-generated sqlite3-db to store play history
+ static/         web static files
+ lib/            python lib