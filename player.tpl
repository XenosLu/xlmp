<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=0.75, maximum-scale=1.0, user-scalable=1">
<title>{{title}}</title>
<link href="static/css/bootstrap.min.css" rel="stylesheet">
<style>
/*** modified bootstrap style ***/
.glyphicon-film, .glyphicon-folder-close, .glyphicon-off, .glyphicon-remove-circle {
    font-size: 2em;
}
.nav-tabs > li.active > a, .nav-tabs > li.active > a:focus {
    background-color: #cccccc;
}
.close {
    font-size: 3em;
}
/*** modified bootstrap style ***/
html, body {
	height: 100%
}
body {
	/*background-color: #101010;*/
	cursor: default;
	-webkit-user-select: none;
	-moz-user-select: none;
	user-select: none;
	font-family: AppleSDGothicNeo-Regular;
}
article{
	left:0%;
}
/*
td{
	border-bottom: 1px solid #DDD;
}
*/
.filelist{
	min-width:14em;
}
.icono-power, .icono-trash {
	border: 2px solid;
	box-sizing: border-box;
	display: inline-block;
	vertical-align: middle;
	position: relative;
	font-style: normal;
	text-align: left;
	text-indent: -9999px;
	direction: ltr
}
[class*=icono-]:after, [class*=icono-]:before {
	content: '';
	/*pointer-events: none*/
}
.icono-trash:before {
	position: absolute;
	left: 50%;
	-webkit-transform: translateX(-50%);
	transform: translateX(-50%)
}
.icono-trash {
	color: red;
	width: 20px;
	height: 20px;
	border-radius: 0 0 3px 3px;
	border-top: none;
	margin: 9px 12px 3px
}
.icono-trash:before {
	width: 7px;
	height: 2px;
	top: -6px;
	box-shadow: inset 0 0 0 32px, -10px 3px 0 0, -6px 3px 0 0, 0 3px 0 0, 6px 3px 0 0, 10px 3px 0 0
}
video {
	clear: both;
	display: block;
	margin: auto;
}
/*
hr {
	margin: 0
}
*/
a {
	text-decoration: none;
	cursor: default;
}
/*
a:visited, a:link{
	color: blue
}
*/
span {
	width: auto;
}
@keyframes slide {
 0% {left:-8%}
 9% {left:0%}
 75% {left:0%}
 100% {left:-9%}
}
@-webkit-keyframes slide {
 0% {left:-8%}
 9% {left:0%}
 75% {left:0%}
 100% {left:-9%}
}
#output{
    z-index: 99;
    position: fixed;
    top: 50%;
    left: 50%;
	transform: translate(-50%, -50%);
	-webkit-transform: translate(-50%, -50%);
	font-size: 1.8em;
	pointer-events: none;
	border-radius: 0.2em;
    padding: 0.2em;
    opacity: 0.4;
	font-weight: 500;
}
#sidebar.sliding {
	top: 35%;
	left: 0%;
	-webkit-transform: translateX(0%);
	/*
	border-top-right-radius: 0.6em;
	border-bottom-right-radius: 0.6em;
	font-size: 1.5em;
	padding: 0.04em;
	*/
	opacity: 0.66;
	-webkit-animation-name: slide;
	-webkit-animation-duration: 5s;
	-webkit-animation-iteration-count: 1;
	-webkit-animation-delay: 0s;
	animation-name: slide;
	animation-duration: 5s;
	animation-iteration-count: 1;
	animation-delay: 0s;
}
#sidebar{
	position: fixed;
	float:top;
}
#sidebar.outside {
	left: -15%
}
#sidebar span:active {
	color: #FFFFFF
}
#sidebar span:hover {
	background-color: #1F1F1F;
	box-shadow: 1em 1em 2em #CCCCCC inset;
}
div {
	background-color: #CCCCCC;
	color: #1F1F1F;
	font-weight: 500;
	text-align: center;
	border: 2px solid #777777;
	box-shadow: 1em 1em 3em #777777 inset;
	text-shadow: 0.1em 0.1em 0.4em #444;
}
#dialog {
	float:top;
	opacity: 0.75;
    left: 50%;
	top: 48%;
	/* box-shadow: 2px 2px 5px #333333; */
	max-width:100%
}
#dialog {
	position: fixed;
	transform: translate(-50%, -50%);
	-webkit-transform: translate(-50%, -50%);
}
.btn-default{
	background: 0 0;
}
/*
.highlight {
	color: #CCCCCC;
	background-color: #333333;
	box-shadow: 1em 1em 3em #777777 inset;
}
*/
#mainframe {
	overflow:auto;
	min-height:9em;
	min-width:10em;
	width:100%;
}
</style>
</head>
<body>
%if src:
  <article>
    <video id="player" src="{{src}}" onprogress="showBuff()" onerror="out('error')" onseeking="showProgress()" ontimeupdate="saveprogress()" onloadeddata="loadprogress()" poster controls preload="meta">No video support!</video>
  </article>
%end
<div id="sidebar" class="outside">
  <div class="btn-group-vertical btn-group-lg">
  <button id="auto" onClick="adapt()" type="button" class="btn btn-default">auto</button>
  <button id="orign" onClick="orign()" type="button" class="btn btn-default">orign</button>
  <button id="playrate" onClick="playrate()" type="button" class="btn btn-default">1.8X</button>
  <button onClick="tabshow('?action=list',0);document.getElementById('dialog').style.display = '';" type="button" class="btn btn-default">history</button>
  </div>
</div>
<div id="dialog" style="display:none">
  <!-- <div class="panel-heading"> -->
  <div>
  <button onClick="$('#dialog').hide();" type="button" class="close">×</button> <!-- &#10060; -->
      <ul id="myTab" class="nav nav-tabs">
      <li class="active">
        <a href="#mainframe" data-toggle="tab" onclick="tabshow('?action=list', 0)"><i class="glyphicon glyphicon-list-alt"></i>History</a>
      </li>
      <li>
        <a href="#mainframe" data-toggle="tab" onclick="tabshow('/', 1)"><i class="glyphicon glyphicon-home"></i>Home dir</a>
      </li>
    </ul>
  </div>
  <div id="mainframe" class="tab-pane fade in">
  <!-- <div id="mainframe"> -->
    <table class="table">
      <tbody id="list">
	  </tbody>
    </table>
  </div>
  <div class="panel-footer">
    <button type="button" class="btn btn-default" onClick="if(confirm('Are you sure you want to suspend?'))$.get('/suspend.php');"><i class="glyphicon glyphicon-off"></i></button>

    <!-- <div class="btn-group" style="font-size:2em;"> -->
      <!-- <button type="button" class="btn btn-default btn-xs" onClick="if(confirm('Are you sure you want to suspend?'))$.get('/suspend.php');"><i class="glyphicon glyphicon-off"></i></button> -->
      <!-- <button type="button" class="btn btn-default dropdown-toggle btn-xs" data-toggle="dropdown"> -->
        <!-- <span class="caret"></span> -->
      <!-- </button> -->
      <!-- <ul class="dropdown-menu" role="menu"> -->
        <!-- <li><a onClick="if(confirm('Are you sure you want to suspend?'))$.get('/suspend.php');"><i class="glyphicon glyphicon-off"></i>suspend</a></li> -->
        <!-- <li><a onClick="if(confirm('Are you sure you want to shutdown?'))$.get('/shutdown.php');"><i class="glyphicon glyphicon-off"></i>shutdown</a></li> -->
      <!-- </ul> -->
    <!-- </div> -->

  </div>
</div>
</body>
<script src="static/js/jquery-3.2.1.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script language="javascript">
window.addEventListener('load', onload, false);
window.addEventListener('resize', adapt, false);
window.addEventListener('mousemove', showsidebar, false);
//$(document).ready(onload());
//$(window).load(onload());
//$(window).resize(adapt());
var range = 12; //minimum move range in pxs
var video = document.getElementsByTagName("video");//$("video")
var text="";
var lastsavetime = 0;//in seconds
var lastplaytime = 0;//in seconds

document.getElementById("mainframe").onclick = function (event) {
	event = event || window.event;
	var target = event.target || event.srcElement;
	if (target.className == "filelist folder")
		tabshow(target.title, 1);
	else if (target.className == "icono-trash del")
		tabshow('?action=del&src=' + target.innerHTML, 0);
	else if (target.className == "icono-trash move")
	{
		if (confirm('Would you want to move ' + target.innerHTML + ' to old?'))
			tabshow('?action=move&src=' + target.innerHTML, 1);
	}
	else if (target.id == "clear")
	{
		if (confirm('Are you sure you want to clear all history?'))
			showhis('?action=clear');
	}
}

function onload() {
%if not src:
    tabshow("?action=list", 0);
    $("#dialog").show();
%end
	adapt();
	document.addEventListener('touchstart', touch, false);
	document.addEventListener('touchend', touch, false);
}
function touch(event) {
	var event = event || window.event;
	switch (event.type) {
	case "touchstart":
		x0 = event.touches[0].clientX;
		y0 = event.touches[0].clientY;
		break;
	case "touchend":
		x = event.changedTouches[0].clientX - x0;
		y = event.changedTouches[0].clientY - y0;

		if (Math.abs(y / x) < 0.25) {
			if (x > range)
				playward(Math.floor(x / 11));
			else if (x < -range)
				playward(Math.floor(x / 11));
		} else
			showsidebar();
		break;
	}
}
function out(str) {
    if(str=="")return;
    $("#output").remove();
    $(document.body).append("<div id='output'>"+str+"</div>");
    $("#output").fadeTo(250,0.7).delay(1625).fadeOut(625);
}
function showsidebar() {
	var sidebar = document.getElementById('sidebar');
	sidebar.className = "sliding";
	sidebar.addEventListener('animationend', resetsidebar);
	sidebar.addEventListener('webkitAnimationEnd', resetsidebar);
}
function resetsidebar() {
	document.getElementById('sidebar').className = "outside";
}
function playrate() {
	var rate = document.getElementById('playrate');
	if (video[0].playbackRate != 1.0) {
		video[0].playbackRate = 1.0;
		rate.innerHTML = "1.8X";
	} else {
		video[0].playbackRate = 1.8;
		rate.innerHTML = "1.0X";
	}
}
function format_time(time) {
	return Math.floor(time / 60) + ":" + (time % 60 / 100).toFixed(2).slice(-2);
}
function playward(time) {
	if (isNaN(video[0].duration))return;
	if (time > 60)time = 60;
	else if (time < -60)time = -60;
	video[0].currentTime += time;
	if (time > 0)text=time + "S>><br>";
	else if (time < 0)text="<<" + -time + "S<br>";	
}
function loadprogress() {
	var marktime = {{progress}} - 1;
	//if (marktime > 0) {
	if (!!marktime) {
		video[0].currentTime = marktime;
		text="Back to<br>";
	}
}
function showProgress(){
	out(text+format_time(video[0].currentTime)+ '/' + format_time(video[0].duration));
	//out(text+format_time($("video").currentTime)+ '/' + format_time($("video").duration));
	text="";
}
function saveprogress(){
	lastplaytime = new Date().getTime();
	if (video[0].readyState == 4 && video[0].currentTime < video[0].duration + 1)
	{
		if (Math.abs(video[0].currentTime - lastsavetime) > 3)//save play progress in every 3 seconds
		{
			lastsavetime = video[0].currentTime;
			//ajax("?action=save&src={{src}}&time=" + video[0].currentTime + "&duration=" + video[0].duration);
			$.get("?action=save&src={{src}}&time=" + video[0].currentTime + "&duration=" + video[0].duration);
            //to be test
		}
	}
}
function adapt() {
	document.getElementById('orign').style.display = '';
	document.getElementById('auto').style.display = 'none';
	document.getElementById("mainframe").style.maxHeight=document.body.clientHeight*.8 + "px";
	video_ratio = video[0].videoWidth / video[0].videoHeight;
	page_ratio = document.body.clientWidth / document.body.clientHeight;
	if (page_ratio < video_ratio) {
		video[0].style.width = document.body.clientWidth + "px";
		video[0].style.height = Math.floor(document.body.clientWidth / video_ratio) + "px";
	} else {
		video[0].style.width = Math.floor(document.body.clientHeight * video_ratio) + "px";
		video[0].style.height = document.body.clientHeight + "px";
	}
}
function orign() {
	document.getElementById('auto').style.display = '';
	document.getElementById('orign').style.display = 'none';
	if (video[0].width < document.body.clientWidth && video[0].height < document.body.clientHeight) {
		video[0].style.width = video[0].videoWidth + "px";
		video[0].style.height = video[0].videoHeight + "px";
	}
}
function showBuff() {
	var str="";
	for(i=0;i<video[0].buffered.length;i++)
	//for(i=0,t=video[0].buffered.length; i<t; i++)
	{
		if (video[0].currentTime>=video[0].buffered.start(i) && video[0].currentTime<=video[0].buffered.end(i))
			str +=format_time(video[0].buffered.start(i))+"-"+format_time(video[0].buffered.end(i))+"<br>";
	}
	if (new Date().getTime()-lastplaytime > 1000)
		out(str+"<small>buffering...</small>");
}
function tabshow(str, n) {
    $("#list").load(str);
    $("#myTab li:eq(" + n + ") a").tab("show");
}
</script>
</html>