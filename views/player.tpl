<!doctype html>
<html>
  <head>
    % include('commonhead.tpl')
    <title>{{title}}</title>
  </head>
  <body>
    % include('common.tpl')
    % include('dlna.tpl')
  </body>
  % include('commonscript.tpl')
  <script>
var reltime = 0;
var vol = 0;
var update = true;  
  
if ("{{mode}}" == "dlna") {
    get_dmr_state();
    $("#dlna").show(250);
    var inter = setInterval("get_dmr_state()",1000);
    $("#position-bar").on("change", function() {
        $.get("/dlnaseek/" + secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
        update = true;
    }).on("input", function() {
        out(secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
        update = false;
    });
    $("#volume_up").click(function() {
        if (vol < 100)
            $.get("/dlnavolume/" + (vol + 1));
    });
    $("#volume_up").click(function() {
        if (vol > 0)
            $.get("/dlnavolume/" + (vol - 1));
    });
    $("#volume-bar").on("change",function() {
        //$.get("/dlnavolume/" + $(this).val());
        $.get("/dlnavolume/" + offset_value(vol, $(this).val(), $(this).attr("max")));
        update = true;
    }).on("input", function() {
        //out($(this).val());
        out(offset_value(vol, $(this).val(), $(this).attr("max")));
        update = false;
    });
} else if ("{{mode}}" == "player") {
    $("#videosize").show();
    $("#rate").show();
    $(document.body).append("<video poster controls preload='meta'>No video support!</video>");
    $("video").attr("src", "/video/{{src}}").on("error", function () {
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
}
function get_dmr_state(){
    $.ajax({
        url: "/dlnainfo",
        dataType: "json",
        timeout: 999,
        type: "GET",
        success: function (data) {
            reltime = timeToSecond(data["RelTime"]);
            vol = Number(data["CurrentVolume"]);
            if(update) {
                $("#position-bar").attr("max", timeToSecond(data["TrackDuration"])).val(reltime);
                //$("#volume-bar").val(data["CurrentVolume"]);
                $("#volume-bar").val(vol);
            }
            $("#position").text(data["RelTime"] + "/" + data["TrackDuration"]);
            $('#src').text(decodeURI(data["TrackURI"]));
            
            $("#dmr button").text(data["CurrentDMR"]);
            $("#dmr ul").empty();
            for (x in data["DMRs"]) {
                $("#dmr ul").append('<li><a href="#" onclick="set_dmr(\'' + data["DMRs"][x] + '\')">' + data["DMRs"][x] + "</a></li>")
            }
            
            $("#state").text(data["CurrentTransportState"]);
            /*
            if ($("#state").text() == "PLAYING") {
                $(".glyphicon-play").hide();
                $(".glyphicon-pause").show();
            } else {
                $(".glyphicon-play").show();
                $(".glyphicon-pause").hide();
            }
            */
            if(reltime >= 90)
                $(".glyphicon-chevron-down").hide();
            else
                $(".glyphicon-chevron-down").show();
        },
        error: function(xhr, err) {
            if(err != "parsererror")
                out("DLNAINFO: " + xhr.statusText);
        }
    });
}
function set_dmr(dmr) {
    //window.location.href = "setdmr/" + dmr;
    $.get("setdmr/" + dmr);
}
function offset_value(current, value, max) {
    if (value < current)
        relduration = current;
    else
        relduration = max - current;
    var s = Math.sin((value - current) / relduration * 1.5707963267948966192313216916);
    return Math.round(current + Math.abs(Math.pow(s, 3)) * (value - current));
}

  </script>
</html>
