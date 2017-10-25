# lwmps - Light web mp4 play system
### lwmps is a light web media play system based on WSGI. Original developed in PHP, now rewrited in Python3.
### You can play mp4 video from other device through any html5 web browser in your LAN.

### I'm working on to add dlna playback support, and already works in an ungracefully way.
### It can achieve the DMC + DMS Roles in DLNA
## install steps:
### 1. install Python3.4.4(suggested)
### 2. run 'python player.py' as a debug demo server
### 3. use adapter.wsgi as a standard WSGI program
### 4. In OS Windows, you can use Apache and modWSGI to make it works perfectly. In other OS, there are plenty of wsgi server choices.

## Filelist:
+ LICENSE         license file 	
+ README.md       readme
+ adapter.wsgi    wsgi adapter
+ player.py 	  main
+ player.tpl      html template
+ player.db       auto-generated sqlite3 db to store play history
+ player.css      CSS file
+ dlnap.py        dlna playback support, original by cherezov and ttopholm