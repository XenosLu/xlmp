var RANGE = 12;  //minimum touch move range in px
var text="";
var lastplaytime = 0;  //in seconds


function rate(x) {
    out(x + "X");
    $("video").get(0).playbackRate = x;
}
function secondToTime(time) {
    return ("0" + Math.floor(time / 3600)).slice(-2) + ":" + ("0" + Math.floor(time %3600 / 60)).slice(-2) + ":" + (time % 60 / 100).toFixed(2).slice(-2);
}
function timeToSecond(time) {
    var t = String(time).split(":");
    return parseInt(t[0]) * 3600 + parseInt(t[1]) * 60 + parseInt(t[2]);
}

$(document).on('touchstart', function (e) {
    var x0 = e.originalEvent.touches[0].screenX;
    var y0 = e.originalEvent.touches[0].screenY;
});
$(document).on('touchmove', function (e) {
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
$(document).on('touchend', function (e) {
    var x = e.changedTouches[0].screenX - x0;
    var y = e.changedTouches[0].screenY - y0;
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
    else
        showSidebar();
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
$("#clear").click(function () {
    if (confirm("Clear all history?"))
        history("/clear");
});


function filelist(str) {
    $.ajax({
            url: encodeURI(str),
            dataType: "json",
            timeout : 999,
            type: "get",
            success: function (data) {
                if ($('#navtab li:eq(1)').attr('class') != 'active')
                    $("#navtab li:eq(1) a").tab("show");
                $("#clear").hide();
                var html = "";
                var icon = {"folder": "folder-close", "mp4": "film", "video": "film", "other": "file"};
                $.each(data, function (i, n) {
                    size = "";
                    if(n["size"])
                        size = "<br><small>" + n["size"] +"</small>";
                    dlna = "";
                    if(icon[n["type"]]=="film")
                        dlna = " class='dlna' title='" + n["path"] + "'";
                    html += "<tr>" +
                              "<td" + dlna + "><i class='glyphicon glyphicon-" + icon[n["type"]] + "'></i></td>" +
                              "<td class='filelist " + n["type"] + "' title='" + n["path"] + "'>" + n["filename"] + size + "</td>" +
                              "<td class='move' title='" + n["path"] + "'>" +
                                "<i class='glyphicon glyphicon-remove-circle'></i>" +
                              "</td>" +
                            "</tr>"
                });
                $('#list').empty().append(html);
            },
            error: function(xhr){
                out(xhr.statusText);
            }
    });
}
function history(str) {
    $.ajax({
            url: encodeURI(str),
            dataType: "json",
            timeout : 999,
            type: "get",
            success: function (data) {
                if ($('#navtab li:eq(0)').attr('class') != 'active')
                    $("#navtab li:eq(0) a").tab("show");
                $("#clear").show();
                var html = "";
                $.each(data, function (i, n) {
                    html += "<tr><td class='folder' title='/" + n["path"] + "'>" +
                                "<i class='glyphicon glyphicon-folder-close'></i>" +
                              "</td>" +
                              "<td class='dlna' title='" + n["filename"] + "'>" +
                                "<i class='glyphicon glyphicon-film'></i>" +
                              "</td>" +
                              "<td class='filelist mp4' title='" + n["filename"] + "'>" + n["filename"] + 
                                "<br><small>" + n["latest_date"] + " | " + 
                                secondToTime(n["position"]) + "/" + secondToTime(n["duration"]) + "</small>" + 
                              "</td>" + 
                              "<td class='remove' title='" + n["filename"] + "'>" +
                                "<i class='glyphicon glyphicon-remove-circle'></i>" + 
                              "</td></tr>";
                });
                $('#list').empty().append(html);
            },
            error: function(xhr){
                out(xhr.statusText);
            }
    });
}
