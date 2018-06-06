var reltime = 0;
var update = true;
var wait = 0;

$("#dlna_toggle").addClass("active");
// $("#dlna_toggle").attr("href", "/");
$("#dlna_toggle").attr("onclick", 'window.location.href = "/";');

// get_dmr_state();
$(".dlna-show").show();
// var inter = setInterval("get_dmr_state()", 1100);
$("#position-bar").on("change", function() {
    $.get("/dlna/seek/" + secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = true;
}).on("input", function() {
    out(secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = false;
});
var ws;
ws = dlnalink();

function CheckLink(){
    if(ws.readyState == 3)
        ws = dlnalink();
    console.log(ws);
    //ws.send('test');
}
setInterval("CheckLink()", 1800);
function dlnalink(){
    var ws = new WebSocket("ws://" + window.location.host + "/dlnalink");
    ws.onmessage = function(e) {
        data = $.parseJSON(e.data);
        console.log(data);
        ws.send('got');
        if ($.isEmptyObject(data)) {
            $("#state").text('No DMR');
            $("#dlna_toggle").removeClass("btn-success");
        } else {
            $("#dlna_toggle").addClass("btn-success");
            reltime = timeToSecond(data["RelTime"]);
            if (update)
                $("#position-bar").attr("max", timeToSecond(data["TrackDuration"])).val(reltime);

            $("#position").text(data["RelTime"] + "/" + data["TrackDuration"]);
            $('#src').text(decodeURI(data["TrackURI"]));

            $("#dmr button").text(data["CurrentDMR"]);
            $("#dmr ul").empty().append('<li><a onclick="$.get(\'/searchdmr\')">Search DMR</a></li>').append('<li class="divider"></li>');
            for (x in data["DMRs"]) {
                $("#dmr ul").append('<li><a onclick="set_dmr(\'' + data["DMRs"][x] + '\')">' + data["DMRs"][x] + "</a></li>")
            }

            $("#state").text(data["CurrentTransportState"]);
        }
    }
    ws.onclose = function () {
        $("#state").text('disconnected');
    };
    ws.onerror = function () { 
        console.log('error');
    }; 
    return ws;
}
function get_dmr_state(){
    if (wait > 0) {
        wait -= 1;
    } else {
        $.ajax({
            url: "/dlnainfo",
            dataType: "json",
            timeout: 999,
            type: "GET",
            success: function (data) {
                if ($.isEmptyObject(data)) {
                    $("#state").text('No DMR');
                    console.log('set wait to 3 for empty');
                    wait = 3;
                } else {
                    reltime = timeToSecond(data["RelTime"]);
                    if (update)
                        $("#position-bar").attr("max", timeToSecond(data["TrackDuration"])).val(reltime);

                    $("#position").text(data["RelTime"] + "/" + data["TrackDuration"]);
                    $('#src').text(decodeURI(data["TrackURI"]));

                    $("#dmr button").text(data["CurrentDMR"]);
                    $("#dmr ul").empty().append('<li><a onclick="$.get(\'/searchdmr\')">Search DMR</a></li>').append('<li class="divider"></li>');
                    for (x in data["DMRs"]) {
                        $("#dmr ul").append('<li><a onclick="set_dmr(\'' + data["DMRs"][x] + '\')">' + data["DMRs"][x] + "</a></li>")
                    }

                    $("#state").text(data["CurrentTransportState"]);
                }
            },
            error: function (xhr, err) {
                if (err != "parsererror")
                    $("#state").text(xhr.statusText);
                else
                    $("#state").text(err);
                console.log('set wait to 3 for error');
                wait = 3;
            }
        });
    }
}
function set_dmr(dmr) {
    $.get("/setdmr/" + dmr);
}
function offset_value(current, value, max) {
    if (value < current)
        relduration = current;
    else
        relduration = max - current;
    var s = Math.sin((value - current) / relduration * 1.5707963267948966192313216916);
    return Math.round(current + Math.abs(Math.pow(s, 3)) * (value - current));
}
