# lwmps - Light web mp4 play system
### lwmps is a light web media play system based on python bottle. Original developed by PHP, now rewrited in WSGI.
### You can play mp4 video from other device through any html5 web browser in your LAN.

### I'm working on to add dlna playback support.

## install steps:
### 1. install Python3.4.4(suggested)
### 2. run 'python player.py' as a debug demo server
### 3. use adapter.wsgi as a standard wsgi program

## Filelist:
+ LICENSE         license file 	
+ README.md       readme
+ adapter.wsgi    wsgi adapter
+ player.py 	    main
+ player.tpl      template
+ player.db       auto-generated play history list db
+ dlnap.py        dlna playback support, original by cherezov and ttopholm