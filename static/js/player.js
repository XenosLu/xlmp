
$("#rate").show();

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
    x0 = e.originalEvent.touches[0].screenX;
    y0 = e.originalEvent.touches[0].screenY;
});
$(document).on("touchmove", function (e) {
    x = e.changedTouches[0].screenX - x0;
    y = e.changedTouches[0].screenY - y0;
    time = Math.floor(x / 11);
    if (!isNaN($("video").get(0).duration))
        out(time);
});
$(document).on("touchend", function (e) {
    x1 = e.changedTouches[0].screenX;
    x = e.changedTouches[0].screenX - x0;
    y = e.changedTouches[0].screenY - y0;
    if (Math.abs(y / x) < 0.25) {
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
