<div class="dlna-show col-xs-12 col-sm-6 col-md-5">
  <div id="dmr" class="btn-group dropdown">
    <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a onclick="get('/searchdmr');">Search DMR</a></li>
    </ul>
  </div>
  <h3 id="src"></h3>
  <div><span id="state"></span></div>
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
  </div>
  <!-- <div class="btn-group dropdown"> -->
    <!-- <button id="position_menu" type="button" class="btn btn-info btn-lg dropdown-toggle" data-toggle="dropdown"> -->
      <!-- <i class="glyphicon glyphicon-chevron-down"></i> -->
    <!-- </button> -->
    <!-- <ul class="dropdown-menu"> -->
      <!-- <li><a onclick="$.get('/dlnaseek/00:00:15')">00:15</a></li> -->
      <!-- <li><a onclick="$.get('/dlnaseek/00:00:30')">00:30</a></li> -->
      <!-- <li><a onclick="$.get('/dlnaseek/00:01:00')">01:00</a></li> -->
      <!-- <li class="divider"></li> -->
      <!-- <li><a onclick="$.get('/dlnaseek/00:01:30')">01:30</a></li> -->
    <!-- </ul> -->
  <!-- </div> -->
    <h3 id="position"></h3>
    <input type="range" id="position-bar" min="0" max="0">
    <button  onclick="get('/dlnavol/down');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-minus">
    <button onclick="get('/dlnavol/up');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-plus">
  </button>
</div>
