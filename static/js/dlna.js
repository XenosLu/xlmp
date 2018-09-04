window.dlnaView.mode = "DLNA";
window.commonView.uiState.dlnaShow = true;


var ws_link = dlnalink();
setInterval("ws_link.check()", 1200);
function dlnalink() {
    var ws = new WebSocket("ws://" + window.location.host + "/link");
    ws.onmessage = function (e) {
        var data = JSON.parse(e.data);
        console.log(data);
        renderUI(data);
    }
    ws.onclose = function () {
        window.dlnaView.dlnaInfo.CurrentTransportState = 'disconnected';
    };
    ws.onerror = function () {
        console.log('error');
    };
    ws.check = function () {
        if (this.readyState == 3)
        ws_link = dlnalink();
    };
    return ws;
}

function renderUI(data) {
    if ($.isEmptyObject(data)) {
        window.commonView.uiState.dlnaOn = false;
        window.dlnaView.dlnaInfo.CurrentDMR = 'no DMR';
        window.dlnaView.dlnaInfo.CurrentTransportState = '';
    } else {
        window.commonView.uiState.dlnaOn = true;
        if (window.dlnaView.positionBar.update) {
            window.dlnaView.positionBar.max = timeToSecond(data.TrackDuration);
            window.dlnaView.positionBar.val = timeToSecond(data.RelTime);
        }
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
