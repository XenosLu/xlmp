# xlmp - Xenos' Light media player
xlmp是一个基于web的媒体播放器，最初用php开发，之后改用了python3。
xlmp诞生的主要目的是为了方便通过其他设备来观看电脑中的视频。起初，是为了在ipad和手机里，之后，则还包括了带DLNA投屏功能的电视机（或电视盒子）。
> 目前，我使用xlmp作为我的家庭影院的控制系统。我将其打包成了docker，方便将其部署在我的支持容器的NAS上。（BTW，我的NAS虽然已经自带了DLNA投屏功能，但无法跟我的电视机兼容）
### xlmp is a light web based media player. Original developed in PHP, rewrote in Python3.
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
