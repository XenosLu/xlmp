var reltime = 0;

window.dlnaView = new Vue({
        delimiters: ['${', '}'],
        el: '#v-dlna',
        data: {
            state: 'No State',
            src: '',
            currentDMR: 'no DMR',
            DMRs: [],
            positionBar:{
                min: 0,
                max: 0,
                val: 0,
                update: true,
            },
            dlnaInfo: {},
        },
        methods: {
            setDmr: function(dmr){
                $.get("/dlna/setdmr/" + dmr);
            },
            positionSeek: function(){
                $.get("/dlna/seek/" + secondToTime(offset_value(reltime, this.positionBar.val, this.positionBar.max)));
                this.positionBar.update = true;
            },
            positionShow: function(){
                console.log(this.positionBar.val);
                out(secondToTime(offset_value(reltime, this.positionBar.val, this.positionBar.max)));
                this.positionBar.update = false;
            },
            test: function(){
                console.log(this.positionBar.val);
            },
        }
});

window.commonView.uiState.dlnaShow = true;


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
        var data = JSON.parse(e.data);
        console.log(data);
        // ws.send('got');
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
        window.commonView.uiState.dlnaOn = false;
        window.dlnaView.DMR = 'No DMR';
    } else {
        window.commonView.uiState.dlnaOn = true;
        reltime = timeToSecond(data.RelTime);
        if (window.dlnaView.positionBar.update) {
            window.dlnaView.positionBar.max = timeToSecond(data.TrackDuration);
            window.dlnaView.positionBar.val = reltime;
        }
        window.dlnaView.src = decodeURI(data.TrackURI); //
        window.dlnaView.currentDMR = data.CurrentDMR;
        window.dlnaView.DMRs = data.DMRs;
        window.dlnaView.state = data.CurrentTransportState;
        window.dlnaView.dlnaInfo = data;
    }
}

function offset_value(current, value, max) {
    if (value < current)
        relduration = current;
    else
        relduration = max - current;
    var s = Math.sin((value - current) / relduration * 1.5707963267948966192313216916);
    return Math.round(current + Math.abs(Math.pow(s, 3)) * (value - current));
}
