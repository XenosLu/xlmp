"use strict";
/**
 * Convert Time format to seconds
 *
 * @method timeToSecond
 * @param {String} time
 * @return {Integer}
 */
function timeToSecond(time) {
    var t = String(time).split(":");
    return (parseInt(t[0]) * 3600 + parseInt(t[1]) * 60 + parseInt(t[2]));
}

/**
 * Convert Second to Time Format
 *
 * @method secondToTime
 * @param {Integer} time
 * @return {String}
 */
function secondToTime(time) {
    return ("0" + Math.floor(time / 3600)).slice(-2) + ":" +
    ("0" + Math.floor(time % 3600 / 60)).slice(-2) + ":" + (time % 60 / 100).toFixed(2).slice(-2);
}
