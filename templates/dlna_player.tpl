{% extends "base.tpl" %}

{% block title %}DMC - Light Media Player{% endblock %}

{% block morebody %}
<div class="dlna-show col-xs-12 col-sm-6 col-md-5">
  <div id="dmr" class="btn-group dropdown">
    <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a onclick="get('/searchdmr');">Search DMR</a></li>
    </ul>
  </div>
  <h3 id="src"></h3>
  <div><span id="state">No State</span></div>
  <div class="btn-group">
    <button class="btn btn-success btn-lg" type="button" onclick="get('/dlnaplay')">
      <i class="glyphicon glyphicon-play"></i>
    </button>
    <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlnapause')">
      <i class="glyphicon glyphicon-pause"></i>
    </button>
    <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlnastop')">
      <i class="glyphicon glyphicon-stop"></i>
    </button>
    <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/next')">
      <i class="glyphicon glyphicon-step-forward"></i>
    </button>
  </div>
    <h3 id="position"></h3>
    <input type="range" id="position-bar" min="0" max="0">
    <button  onclick="get('/dlnavol/down');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-minus">
    <button onclick="get('/dlnavol/up');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-plus">
  </button>
</div>
{% endblock %}

{% block script %}
<script>
var reltime = 0;
var update = true;
var wait = 0;

$("#dlna_toggle").addClass("active");
$("#dlna_toggle").attr("href", "/index");

get_dmr_state();
$(".dlna-show").show();
var inter = setInterval("get_dmr_state()", 1100);
$("#position-bar").on("change", function() {
    $.get("/dlnaseek/" + secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = true;
}).on("input", function() {
    out(secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = false;
});

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
</script>
{% endblock %}
