var reltime = 0;
var update = true;
var wait = 0;


window.dlnaView = new Vue({
        delimiters: ['${', '}'],
        el: '#v-dlna',
        data: {
            state: 'No State',
            src: '',
            position: '',
            currentDMR: '',
            DMRs: [],
        },
        methods: {
            set_dmr: function(dmr){
                set_dmr(dmr);
            }
        }
});

window.commonView.dlnaShow = true;


$("#position-bar").on("change", function () {
    $.get("/dlna/seek/" + secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = true;
}).on("input", function () {
    out(secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = false;
});
var ws_link;
ws_link = dlnalink();

function CheckLink() {
    if (ws_link.readyState == 3)
        ws_link = dlnalink();
}
setInterval("CheckLink()", 1200);
function dlnalink() {
    var ws = new WebSocket("ws://" + window.location.host + "/dlna/link");
    ws.onmessage = function (e) {
        data = $.parseJSON(e.data);
        console.log(data);
        ws.send('got');
        renderUI(data);
    }
    ws.onclose = function () {
        window.dlnaView.state = 'disconnected';
    };
    ws.onerror = function () {
        console.log('error');
    };
    return ws;
}
function renderUI(data) {
    if ($.isEmptyObject(data))
    {
        window.commonView.dlnaOn = false;
        window.dlnaView.state = 'No DMR';
        // $("#state").text('No DMR');
    }
    else {
        window.commonView.dlnaOn = true;
        reltime = timeToSecond(data["RelTime"]);
        if (update)
            $("#position-bar").attr("max", timeToSecond(data["TrackDuration"])).val(reltime);
        window.dlnaView.position = data["RelTime"] + "/" + data["TrackDuration"];
        // $("#position").text(data["RelTime"] + "/" + data["TrackDuration"]);
        window.dlnaView.src = decodeURI(data["TrackURI"]);
        // $('#src').text(decodeURI(data["TrackURI"]));
        window.dlnaView.currentDMR = data.CurrentDMR;
        window.dlnaView.DMRs = data.DMRs;
        
        // $("#dmr button").text(data["CurrentDMR"]);
        // $("#dmr ul").empty().append('<li><a onclick="$.get(\'/dlna/searchdmr\')">Search DMR</a></li>').append('<li class="divider"></li>');
        // for (x in data["DMRs"]) {
            // $("#dmr ul").append('<li><a onclick="set_dmr(\'' + data["DMRs"][x] + '\')">' + data["DMRs"][x] + "</a></li>")
        // }

        // $("#state").text(data["CurrentTransportState"]);
        window.dlnaView.state = data.CurrentTransportState;
    }
}
function set_dmr(dmr) {
    $.get("/dlna/setdmr/" + dmr);
}

function offset_value(current, value, max) {
    if (value < current)
        relduration = current;
    else
        relduration = max - current;
    var s = Math.sin((value - current) / relduration * 1.5707963267948966192313216916);
    return Math.round(current + Math.abs(Math.pow(s, 3)) * (value - current));
}
