# xlmp - Xenos' Light media player
### xlmp is a light web based media player. Original developed in PHP, rewrote in Python3.
### it can support 
### You can play media video from other device through any html5 web browser in your LAN.

### I'm working on to add dlna playback support, and already works in an ungracefully way.
### It can achieve the DMC + DMS Roles in DLNA
###  I already put it in docker container, and works good. I'll try publish it by docker as next step.


## Suggestted install steps:
    docker pull xenocider/xlmp
### make sure your 80 port is not occupied    
    docker run -itd --net="host" /home/user/media:/opt/xlmp/static/media/ xenocider/xlmp
### /home/user/meida should be replace by your own media folder


## Filelist:
+ LICENSE         license file 	
+ README.md       readme
+ adapter.wsgi    wsgi adapter
+ xlmp.py 	      main
+ views/          html template
+ player.db       auto-generated sqlite3-db to store play history
+ static/         web static files
+ lib/            python lib
