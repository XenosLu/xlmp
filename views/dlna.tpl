<div class="col-xs-12 col-sm-6 col-md-5" id="dlna">
  <div id="dmr" class="btn-group dropdown">
    <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
    </ul>
  </div>
  <h3 id="src"></h3>
  <div><span id="state"></span></div>
  <div class="btn-group" role="group">
    <button type="button" class="btn btn-success btn-lg glyphicon glyphicon-play" onclick="$.get('/dlnaplay')"></button>
    <button type="button" class="btn btn-danger btn-lg glyphicon glyphicon-pause" onclick="$.get('/dlnapause')"></button>
    <button type="button" class="btn btn-danger btn-lg glyphicon glyphicon-stop" onclick="$.get('/dlnastop')"></button>
  </div>
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
    <!-- <input type="range" id="volume-bar" min="0" max="100"> -->
    <button id="volume_down" type="button" class="btn btn-warning btn-lg glyphicon glyphicon-minus">
    <button id="volume_up" type="button" class="btn btn-warning btn-lg glyphicon glyphicon-plus">
  </button>
</div>
