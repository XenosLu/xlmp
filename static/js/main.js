"use strict";
var icon = {
    "folder": "oi-folder",
    "mp4": "oi-video",
    "video": "oi-video",
    "other": "oi-file"
};

window.appView = new Vue({
        delimiters: ['${', '}'],
        el: '#v-common',
        data: {
            video: {
                lastplaytime: 0,
                position: 0,
                extraText: '',
                sizeBtnText: 'origin',
            },
            icon: icon,
            vmodel: '',
            swipeState: 0, // modal touch state
            mode: '', // mode of player, switch between empty/DLNA/WebPlayer
            uiState: {
                modalShow: false, // true if the modal is show
                historyShow: true, // ture if modal is history, false if modal content is file list
                fixBarShow: true,
            },
            wp_src: '', // web player source, not used
            history: [], // updated by ajax
            filelist: [], // updated by ajax
            positionBar: { // for dlna player
                min: 0,
                max: 0,
                val: 0,
                update: true,
            },
            dlnaInfo: { // updated by websocket
                CurrentDMR: 'no DMR',
                CurrentTransportState: '',
                TrackURI: '',
            },
        },
        computed: {
            dlnaOn: function () { // check if dlna dmr is exist
                return this.dlnaInfo.CurrentDMR !== 'no DMR';
            },
            dlnaMode: function () { // check if in dlna mode
                return this.mode === 'DLNA';
            },
            wpMode: function () { // check if in web player mode
                return this.mode === 'WebPlayer';
            },
        },
        methods: {
            test: function (obj) {
                console.log("test " + obj);
            },
            dlnaToogle: function () {
                this.mode = this.mode !=='DLNA' ? 'DLNA' : '';
                localStorage.mode = this.mode;
            },
            videoSizeToggle: function () {
                if (this.video.sizeBtnText == 'auto')
                    adapt();
                else {
                    this.video.sizeBtnText = 'auto';
                    if (this.$refs.video.width < $(window).width() && this.$refs.video.height < $(window).height()) {
                        this.$refs.video.style.width = this.$refs.video.videoWidth + "px";
                        this.$refs.video.style.height = this.$refs.video.videoHeight + "px";
                    }
                }
            },
            showModal: function () {
                this.uiState.modalShow = true;
                if (this.uiState.historyShow)
                    this.showHistory();
            },
            showHistory: function () {
                getHistory("/hist/ls");
            },
            showFs: function (path) {
                $.ajax({
                    url: encodeURI(path),
                    dataType: "json",
                    timeout: 1999,
                    type: "get",
                    success: function (data) {
                        window.appView.uiState.historyShow = false;
                        window.appView.filelist = data.filesystem;
                    },
                    error: function (xhr) {
                        out(xhr.statusText);
                    }
                });
            },
            clearHistory: function () { // clear history button
                if (confirm("Clear all history?"))
                    getHistory("/hist/clear");
            },
            play: function (obj) {
                this.open(obj, 'mp4');
            },
            remove: function (obj) {
                if (confirm("Clear history of " + obj + "?"))
                    getHistory("/hist/rm/" + obj.replace(/\?/g, "%3F")); //?to%3F #to%23
            },
            move: function (obj) {
                if (confirm("Move " + obj + " to .old?")) {
                    this.showFs("/fs/move/" + obj);
                }
            },
            open: function (obj, type) {
                switch (type) {
                case "folder":
                    this.showFs("/fs/ls/" + obj + "/");
                    break;
                case "mp4":
                    if (this.dlnaMode)
                        get("/dlna/load/" + obj);
                    else {
                        // this.wp_src = obj;
                        window.location.href = "/wp/play/" + obj;
                        // this.mode = "WebPlayer";
                    }
                    break;
                case "video":
                    if (this.dlnaMode)
                        get("/dlna/load/" + obj);
                    break;
                default:
                }
            },
            setDmr: function (dmr) {
                $.get("/dlna/setdmr/" + dmr);
            },
            positionSeek: function () {
                $.get("/dlna/seek/" + secondToTime(offset_value(timeToSecond(this.dlnaInfo.RelTime), this.positionBar.val, this.positionBar.max)));
                this.positionBar.update = true;
            },
            positionShow: function () {
                console.log(this.positionBar.val);
                out(secondToTime(offset_value(timeToSecond(this.dlnaInfo.RelTime), this.positionBar.val, this.positionBar.max)));
                this.positionBar.update = false;
            },
            get: function (url) {
                $.get(url, out);
            },
            rate: function (x) {
                out(x + "X");
                this.$refs.video.playbackRate = x;
            },
            videosave: function () {
                this.video.lastplaytime = new Date().getTime(); //to detect if video is playing
                if (this.$refs.video.readyState == 4 && Math.floor(Math.random() * 99) > 70) { //randomly save play position
                    $.ajax({
                        url: "/wp/save/" + window.appView.wp_src,
                        data: {
                            position: this.$refs.video.currentTime,
                            duration: this.$refs.video.duration
                        },
                        timeout: 999,
                        type: "POST",
                        error: function (xhr) {
                            out("save: " + xhr.statusText);
                        }
                    });
                }
            },
            videoload: function () {
                this.$refs.video.currentTime = Math.max(this.video.position - 0.5, 0);
                this.video.extraText = "<small>Play from</small><br>";
            },
            videoseek: function () { //show position when changed
                out(this.video.extraText + secondToTime(this.$refs.video.currentTime) + '/' + secondToTime(this.$refs.video.duration));
                this.video.extraText = "";
            },
            videoerror: function() {
                out("error");
            },
            videoprogress: function() { //show buffered when hanged
                var str = "";
                if (new Date().getTime() - this.video.lastplaytime > 1000) {
                    for (var i = 0, t = this.$refs.video.buffered.length; i < t; i++) {
                        if (this.$refs.video.currentTime >= this.$refs.video.buffered.start(i) && this.$refs.video.currentTime <= this.$refs.video.buffered.end(i)) {
                            str = secondToTime(this.$refs.video.buffered.start(i)) + "-" + secondToTime(this.$refs.video.buffered.end(i)) + "<br>";
                            break;
                        }
                    }
                    out(str + "<small>buffering...</small>");
                }
            },
            
        },
        updated: function () {
            this.$nextTick(function () {
                if (this.dlnaMode)
                    dlnaTouch();
            })
        },
    });


window.alertBox = new Vue({
        delimiters: ['${', '}'],
        el: "#v-alert",
        data() {
            return {
                dismissCountDown: 0,
                content: '',
                title: '',
                class_style: 'success'
            }
        },
        methods: {
            countDownChanged(dismissCountDown) {
                this.dismissCountDown = dismissCountDown
            },
            show(type, content) {
                var title_map = {
                    "info": "Info",
                    "danger": "Error!",
                    "success": "Success!",
                    "warning": "dealing...",
                };
                this.class_style = type;
                this.title = title_map[type];
                this.content = content;
                if (type === "warning")
                    this.dismissCountDown = 999;
                else if (type === 'danger')
                    this.dismissCountDown = 9;
                else
                    this.dismissCountDown = 3;
            }
        }
    });

modalTouch();

var hide_sidebar = 0;

if (typeof(localStorage.mode) !== "undefined")
    window.appView.mode = localStorage.mode;

window.onload = adapt;
window.onresize = adapt;
var isiOS = !!navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
if (!isiOS) {
    window.appView.uiState.fixBarShow = false;
    $(document).mousemove(showSidebar);
}

function showSidebar() {
    window.appView.uiState.fixBarShow = true;
    clearTimeout(hide_sidebar);
    hide_sidebar = setTimeout('window.appView.uiState.fixBarShow = false;', 3000);
}

//window.appView.showModal();  // show modal at start

/**
 * Ajax get and out result
 *
 * @method get
 * @param {String} url
 */
function get(url) {
    console.log('get');
    $.get(url, out);
}

function out2(str) {
    window.alertBox.show("success", str);
}

/**
 * Auto adjust video size
 *
 * @method adapt
 */
function adapt() {
    if (window.appView.wpMode) {
        // document.body.clientWidth
        // document.body.clientHeight
        window.appView.video.sizeBtnText = "orign";
        var video_ratio = window.appView.$refs.video.videoWidth / window.appView.$refs.video.videoHeight;
        var page_ratio = $(window).width() / $(window).height();
        if (page_ratio < video_ratio) {
            var width = $(window).width() + "px";
            var height = Math.floor($(window).width() / video_ratio) + "px";
        } else {
            var width = Math.floor($(window).height() * video_ratio) + "px";
            var height = $(window).height() + "px";
        }
        window.appView.$refs.video.style.width = width;
        window.appView.$refs.video.style.height = height;
    }
}

/**
 * Render history list box from ajax
 *
 * @method history
 * @param {String} str
 */
function getHistory(str) {
    $.ajax({
        url: encodeURI(str),
        dataType: "json",
        timeout: 1999,
        type: "get",
        success: function (data) {
            window.appView.uiState.historyShow = true;
            window.appView.history = data.history;
        },
        error: function (xhr) {
            out(xhr.statusText);
        }
    });
}

/**
 * Made an output box to show some text notification
 *
 * @method out
 * @param {String} str
 */
function out(str) {
    if (str != "") {
        $("#output").remove();
        $(document.body).append('<div id="output">' + JSON.stringify(str) + "</div>");
        $("#output").fadeTo(250, 0.7).delay(1800).fadeOut(625);
    };
}

function dlnaTouch() {
    var hammertimeDlna = new Hammer(document.getElementById("DlnaTouch"));
    hammertimeDlna.on("panleft panright swipeleft swiperight", function (ev) {
        var newtime = window.appView.positionBar.val + ev.deltaX / 4;
        newtime = Math.max(newtime, 0);
        newtime = Math.min(newtime, window.appView.positionBar.max);
        out(secondToTime(newtime));
        if (ev.type.indexOf("swipe") != -1)
            $.get("/dlna/seek/" + secondToTime(newtime));
        console.log(ev);
        console.log(ev.type);
    });
}

// window.document.title = "DMC - Light Media Player";

var ws_link = dlnalink();
setInterval("ws_link.check()", 1200);
function dlnalink() {
    var ws = new WebSocket("ws://" + window.location.host + "/link");
    ws.onmessage = function (e) {
        var data = JSON.parse(e.data);
        console.log(data);
        renderDlna(data);
    }
    ws.onclose = function () {
        window.appView.dlnaInfo.CurrentTransportState = 'disconnected';
    };
    ws.onerror = function () {
        console.log('error');
    };
    ws.check = function () {
        if (this.readyState == 3)
            ws_link = dlnalink();
    };
    return ws;
}

function renderDlna(data) {
    if (window.appView.positionBar.update) {
        window.appView.positionBar.max = timeToSecond(data.TrackDuration);
        window.appView.positionBar.val = timeToSecond(data.RelTime);
    }
    window.appView.dlnaInfo = data;
}

function modalTouch() {
    var hammertimeModal = new Hammer(document.getElementById("ModalTouch"));

    hammertimeModal.on("swipeleft", function (ev) {
        window.appView.swipeState -= 1;
        if (window.appView.swipeState < -1)
            window.appView.swipeState = -1;
    });
    hammertimeModal.on("swiperight", function (ev) {
        window.appView.swipeState += 1;
        if (window.appView.swipeState > 1)
            window.appView.swipeState = 1;
    });
    // var press = new Hammer.Press({time: 500});
    // press.requireFailure(new Hammer.Tap());
    // hammertimeModal.add(press);
    hammertimeModal.on("press", function (ev) {
        console.log(ev)
        var target = ev.target.tagName == 'TD' ? ev.target : ev.target.parentNode;
        if (target.hasAttribute("data-target"))
            window.appView.open(target.getAttribute('data-target'), 'folder');
        console.log(target.getAttribute('data-target'));
    });
    hammertimeModal.on("tap", function (ev) {
        console.log(ev)
        var target = ev.target.tagName == 'TD' ? ev.target : ev.target.parentNode;
        if (target.hasAttribute("data-type"))
            window.appView.open(target.getAttribute('data-path'), target.getAttribute('data-type'));
        console.log(target.getAttribute('data-target'));
    });
}

function touchWebPlayer() {
    var hammertimeVideo = new Hammer(document);
    hammertimeVideo.on("panleft panright swipeleft swiperight", function (ev) {
        var deltaTime = ev.deltaX / 4;
        if (ev.type.indexOf("swipe") != -1)
            $("video").get(0).currentTime += deltaTime;
        else
            out(secondToTime($("video").get(0).currentTime + deltaTime));
        console.log(ev);
        console.log(ev.type);
    });
}
