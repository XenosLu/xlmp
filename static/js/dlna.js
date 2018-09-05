// window.document.title = "DMC - Light Media Player";

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
        window.commonView.dlnaInfo.CurrentTransportState = 'disconnected';
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
        window.commonView.dlnaInfo.CurrentDMR = 'no DMR';
        window.commonView.dlnaInfo.CurrentTransportState = '';
    } else {
        window.commonView.uiState.dlnaOn = true;
        if (window.commonView.positionBar.update) {
            window.commonView.positionBar.max = timeToSecond(data.TrackDuration);
            window.commonView.positionBar.val = timeToSecond(data.RelTime);
        }
        window.commonView.dlnaInfo = data;
    }
}
