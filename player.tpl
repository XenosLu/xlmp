<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1.0, user-scalable=1">
    <title>{{title}}</title>
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/css/player.css?v=5" rel="stylesheet">
  </head>
  <body>
    <div class="col-xs-12 col-sm-6 col-md-5" id="dlna">
      <div id="dmr" class="btn-group dropdown">
        <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu">
          <li class="divider"></li>
          <!-- <li><a href="#" onclick="">test</a></li> -->
        </ul>
      </div>
      <h2 id="src"></h2>
      <span id="state"></span>
      <br>
      <button type="button" class="btn btn-success btn-lg glyphicon glyphicon-play" onclick="$.get('/dlnaplay')">
      </button>
      <button type="button" class="btn btn-danger btn-lg glyphicon glyphicon-pause" onclick="$.get('/dlnapause')">
      </button>
      <!-- <button type="button" class="btn btn-danger btn-lg glyphicon glyphicon-stop" onclick="$.get('/dlnastop')"></button> -->
      <div class="btn-group dropdown">
        <button type="button" class="btn btn-info btn-lg dropdown-toggle glyphicon glyphicon-chevron-down" data-toggle="dropdown">
        </button>
        <ul class="dropdown-menu" role="menu">
          <li><a href="#" onclick="$.get('/dlnaseek/00:00:15')">00:15</a></li>
          <li><a href="#" onclick="$.get('/dlnaseek/00:00:30')">00:30</a></li>
          <li><a href="#" onclick="$.get('/dlnaseek/00:01:00')">01:00</a></li>
          <li class="divider"></li>
          <li><a href="#" onclick="$.get('/dlnaseek/00:01:30')">01:30</a></li>
        </ul>
      </div>
        <h3 id="position"></h3>
        <input type="range" id="position-bar" min="0" max="0">
        <input type="range" id="volume-bar" min="0" max="100">
        <button id="volume_down" type="button" class="btn btn-warning btn-lg glyphicon glyphicon-minus">
        <button id="volume_up" type="button" class="btn btn-warning btn-lg glyphicon glyphicon-plus">
      </button>
    </div>
    <div id="sidebar">
      <button id="history" type="button" class="btn btn-default">
        <i class="glyphicon glyphicon-list-alt"></i>
      </button>
    </div>
    <div id="dialog" class="col-xs-12 col-sm-8 col-md-8 col-lg-7">
      <div id="panel">
        <div class="bg-info panel-title">
          <button onClick="$('#dialog').hide(250);" type="button" class="close">&times;</button>
          <ul id="navtab" class="nav nav-tabs">
            <li class="active">
              <a href="#tabFrame" data-toggle="tab" onclick="history('/list')">
                <i class="glyphicon glyphicon-list"></i>History
              </a>
            </li>
            <li>
              <a href="#tabFrame" data-toggle="tab" onclick="filelist('/fs/')">
                <i class="glyphicon glyphicon-home"></i>Home dir
              </a>
            </li>
          </ul>
        </div>
        <div id="tabFrame" class="tab-pane fade in">
          <table class="table-striped table-responsive table-condensed">
            <tbody id="list">
            </tbody>
          </table>
        </div>
        <div class="panel-footer">
          <button id="videosize" type="button" class="btn btn-default">orign</button>
          <div id="rate" class="btn-group dropup">
            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
              Rate<span class="caret"></span>
            </button>
            <ul class="dropdown-menu" role="menu">
              <li><a href="#" onclick="rate(0.5)">0.5X</a></li>
              <li><a href="#" onclick="rate(0.75)">0.75X</a></li>
              <li class="divider"></li>
              <li><a href="#" onclick="rate(1)">1X</a></li>
              <li class="divider"></li>
              <li><a href="#" onclick="rate(1.5)">1.5X</a></li>
              <li><a href="#" onclick="rate(2)">2X</a></li>
            </ul>
          </div>
          <button id="clear" type="button" class="btn btn-default">Clear History</button>
          <div class="btn-group dropup">
            <button type="button" class="btn btn-default" onClick="if(confirm('Suspend ?'))$.post('/suspend');">
              <i class="glyphicon glyphicon-off"></i>
            </button>
            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
              <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" role="menu">
              <li>
                <a onClick="if(confirm('Shutdown ?'))$.post('/shutdown');">
                <i class="glyphicon glyphicon-off"></i>shutdown</a>
              </li>
              <li>
                <a onClick="if(confirm('Restart ?'))$.post('/restart');">
                <i class="glyphicon glyphicon-off"></i>restart</a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </body>
  <script src="/static/js/jquery-3.2.1.min.js"></script>
  <script src="/static/js/bootstrap.min.js"></script>
  <script src="/static/js/player.js"></script>
</html>
