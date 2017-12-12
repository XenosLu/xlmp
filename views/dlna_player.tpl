
% rebase('base.tpl', title='DMC - Light Media Player')
<body>
  % include('common.tpl')
  % include('dlna.tpl')
</body>
% include('common_script.tpl')
<script>
var reltime = 0;
var vol = 0;
var update = true;

$("#dlna_toggle").addClass("active");
$("#dlna_toggle").attr("href","/index");

get_dmr_state();
$("#dlna").show(250);
var inter = setInterval("get_dmr_state()",1200);
$("#position-bar").on("change", function() {
    $.get("/dlnaseek/" + secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = true;
}).on("input", function() {
    out(secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = false;
});
$("#volume_up").click(function() {
    //if (vol < 100)
        $.get("/dlnavolumeup/");
});
$("#volume_down").click(function() {
    //if (vol > 0)
        $.get("/dlnavolumedown/");
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
            $("#dmr ul").empty().append('<li><a href="#" onclick="$.get(\'/searchdmr\')">Search DMR</a></li>').append('<li class="divider"></li>');
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
</script>
