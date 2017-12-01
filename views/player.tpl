
% rebase('base.tpl')
<body>
  % include('common.tpl')
  <video src="/video/{{src}}" poster controls preload="meta">No video support!</video>
</body>
% include('common_script.tpl')
<script>
var lastplaytime = 0;  //in seconds
var text = "";  //temp output text

$("#videosize").show();
$("#rate").show();
$("video").on("error", function () {
    out("error");
}).on("loadeddata", function () {  //auto load position
    this.currentTime = Math.max({{position}} - 0.5, 0);
    text = "<small>Play from</small><br>";
}).on("seeking", function () {  //show position when changed
    out(text + secondToTime(this.currentTime) + '/' + secondToTime(this.duration));
    text = "";
}).on("timeupdate", function () {  //auto save play position
    lastplaytime = new Date().getTime();  //to detect if video is playing
    if (this.readyState == 4 && Math.floor(Math.random() * 99) > 80) {  //randomly save play position
        $.ajax({
            url: "/save/{{src}}",
            data: {
                position: this.currentTime,
                duration: this.duration
            },
            timeout: 999,
            type: "POST",
            error: function (xhr) {
                out("save: " + xhr.statusText);
            }
        });
    }
}).on("progress", function () {  //show buffered
    var str = "";
    if (new Date().getTime() - lastplaytime > 1000) {
        for (i = 0, t = this.buffered.length; i < t; i++) {
            if (this.currentTime >= this.buffered.start(i) && this.currentTime <= this.buffered.end(i))
                str = secondToTime(this.buffered.start(i)) + "-" + secondToTime(this.buffered.end(i)) + "<br>";
        }
        out(str + "<small>buffering...</small>");
    }
});

$("#videosize").click(function () {
    if ($(this).text() == "auto")
        adapt();
    else {
        $(this).text("auto");
        if ($("video").get(0).width < $(window).width() && $("video").get(0).height < $(window).height()) {
            $("video").get(0).style.width = $("video").get(0).videoWidth + "px";
            $("video").get(0).style.height = $("video").get(0).videoHeight + "px";
        }
    }
});

/* touch for ipad start */
$(document).on("touchstart", function (e) {
    var x0 = e.originalEvent.touches[0].screenX;
    var y0 = e.originalEvent.touches[0].screenY;
    
});
$(document).on("touchmove", function (e) {
    var x = e.changedTouches[0].screenX - x0;
    var y = e.changedTouches[0].screenY - y0;
    if (Math.abs(y / x) < 0.25) {
        if (Math.abs(x) > RANGE) {
            time = Math.floor(x / 11);
            //out(time);
            if (!isNaN($("video").get(0).duration)) {
                if (time > 0) {
                    time = Math.min(60, time);
                } else if (time < 0) {
                    time = Math.max(-60, time);
                }
            }
        }
    }
});
$(document).on("touchend", function (e) {
    var x = e.changedTouches[0].screenX - x0;
    var y = e.changedTouches[0].screenY - y0;
    if (Math.abs(y / x) < 0.25) {
    out('test');
        if (Math.abs(x) > RANGE) {
            time = Math.floor(x / 11);
            if (!isNaN($("video").get(0).duration)) {
                if (time > 0) {
                    time = Math.min(60, time);
                    text = time + "S>><br>";
                } else if (time < 0) {
                    time = Math.max(-60, time);
                    text = "<<" + -time + "S<br>";
                }
                $("video").get(0).currentTime += time;
            }
        }
    }
});
/***********************************************************/

/**
 * Set play rate
 *
 * @method rate
 * @param {Number} x
 */
function rate(x) {
    out(x + "X");
    $("video").get(0).playbackRate = x;
}
</script>
