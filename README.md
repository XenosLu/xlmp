# xlmp - Xenos' Light media player

[![](https://images.microbadger.com/badges/version/xenocider/xlmp.svg)](https://microbadger.com/images/xenocider/xlmp "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/xenocider/xlmp.svg)](https://microbadger.com/images/xenocider/xlmp "Get your own image badge on microbadger.com")

[![Docker Pulls](https://img.shields.io/docker/pulls/xenocider/xlmp.svg)](https://hub.docker.com/r/xenocider/xlmp/ "Docker Pulls")
[![Docker Stars](https://img.shields.io/docker/stars/xenocider/xlmp.svg)](https://hub.docker.com/r/xenocider/xlmp/ "Docker Stars")
[![Docker Automated](https://img.shields.io/docker/automated/xenocider/xlmp.svg)](https://hub.docker.com/r/xenocider/xlmp/ "Docker Automated")

Updated in 2018.02.08


### xlmp is a light web based media player.
### It can do two things: 
+ Let you play mp4 files in your computer on your web browser(in my case it's a pad)
+ Let you play video files through TV by DLNA, you can control it through web browser(mostly it's your phone)
## features
+ save your watch history, so you can easily start it from last. And because it based on web, which means you can share your play history across all your home device.


### It can achieve the DMC + DMS Roles in DLNA
## Now you can easily deploy it through docker
## Suggested install steps:
### make sure you have a docker environment and your 80 port is not occupied, and type follow command:
    docker run -itd --net=host -v /home/user/media:/xlmp/media/ xenocider/xlmp
### /home/user/meida should be replace by your own media folder


Python3 + tornado + vue.js + bootstrap4 + bootstrap-vue + hammer.js + velocity.js + axios.js

## Filelist:
+ LICENSE         license file 	
+ README.md       readme
+ xlmp.py 	      main
+ views/          html templates
+ static/         web static files
+ lib/            python lib
+ docker/         docker build files
+ media/          media folder
+ media/.history.db      auto-generated sqlite3-db to store play history
