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
            currentDMR: 'no DMR',
            DMRs: [],
            positionBar:{
                min: 0,
                max: 1,
                val: 0,
            },
            dlnaInfo: {},
        },
        methods: {
            set_dmr: function(dmr){
                set_dmr(dmr);
            },
            positionSeek: function(){
                $.get("/dlna/seek/" + secondToTime(offset_value(reltime, this.positionBar.val, this.positionBar.max)));
                update = true;
            },
            positionShow: function(){
                console.log(this.positionBar.val);
                out(secondToTime(offset_value(reltime, this.positionBar.val, this.positionBar.max)));
                update = false;
            },
            test: function(){
                console.log(this.positionBar.val);
            },
        }
});

window.commonView.dlnaShow = true;

/*
$("#position-bar").on("change", function () {
    $.get("/dlna/seek/" + secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = true;
}).on("input", function () {
    out(secondToTime(offset_value(reltime, $(this).val(), $(this).attr("max"))));
    update = false;
});
*/
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
    if ($.isEmptyObject(data)) {
        window.commonView.dlnaOn = false;
        window.dlnaView.DMR = 'No DMR';
    } else {
        window.commonView.dlnaOn = true;
        reltime = timeToSecond(data.RelTime);
        if (update) {
            // $("#position-bar").attr("max", timeToSecond(data["TrackDuration"])).val(reltime);
            window.dlnaView.positionBar.max = timeToSecond(data.TrackDuration);
            window.dlnaView.positionBar.val = reltime;
        }
        window.dlnaView.position = data.RelTime + "/" + data.TrackDuration;//
        window.dlnaView.src = decodeURI(data.TrackURI); //
        window.dlnaView.currentDMR = data.CurrentDMR;
        window.dlnaView.DMRs = data.DMRs;
        window.dlnaView.state = data.CurrentTransportState;
        window.dlnaView.dlnaInfo = data;
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
