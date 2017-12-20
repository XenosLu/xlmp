# xlmp - Xenos' Light media player

[![](https://images.microbadger.com/badges/version/xenocider/xlmp.svg)](https://microbadger.com/images/xenocider/xlmp "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/xenocider/xlmp.svg)](https://microbadger.com/images/xenocider/xlmp "Get your own image badge on microbadger.com")

[![Docker Pulls](https://img.shields.io/docker/pulls/xenocider/xlmp.svg)](https://hub.docker.com/r/xenocider/xlmp/ "Docker Pulls")
[![Docker Stars](https://img.shields.io/docker/stars/xenocider/xlmp.svg)](https://hub.docker.com/r/xenocider/xlmp/ "Docker Stars")
[![Docker Automated](https://img.shields.io/docker/automated/xenocider/xlmp.svg)](https://hub.docker.com/r/xenocider/xlmp/ "Docker Automated")

Updated in 2017.12.19
xlmp是一个基于web的媒体播放器，最初用php开发，之后改用了python3。
xlmp诞生的主要目的是为了方便通过其他设备来观看电脑中的视频。起初，是为了在ipad和手机里，之后，则还包括了带DLNA投屏功能的电视机（或电视盒子）。
> 
### xlmp is a light web based media player. Original developed in PHP, rewrote in Python3.
### You can play media video from other device through any html5 web browser in your LAN.

### I'm working on to add dlna playback support, and already works in an ungracefully way.
### It can achieve the DMC + DMS Roles in DLNA
###  I already put it in docker container, and works good. I'll try publish it by docker as next step.


## Suggestted install steps:
[>_<]:
    docker pull xenocider/xlmp
### make sure your 80 port is not occupied    
    docker run -itd --net=host -v /home/user/media:/xlmp/media/ xenocider/xlmp
### /home/user/meida should be replace by your own media folder


## Filelist:
+ LICENSE         license file 	
+ README.md       readme
+ adapter.wsgi    wsgi adapter
+ xlmp.py 	      main
+ views/          html templates
+ history.db      auto-generated sqlite3-db to store play history
+ static/         web static files
+ lib/            python lib
+ docker/         docker build files
+ media/          media folder