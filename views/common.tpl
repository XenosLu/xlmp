<div id="sidebar" class="btn-toolbar">
  <div class="btn-group">
    <button id="history" type="button" class="btn btn-default btn-lg">
      <i class="glyphicon glyphicon-th-list"></i>
    </button>
    <a id="dlna_toggle" href="/dlna" type="button" class="btn btn-default btn-lg">DLNA</a>
  </div>
  <div class="btn-group dropdown">
    <button type="button" class="btn btn-default dropdown-toggle btn-lg" data-toggle="dropdown">
      SYS<i class="glyphicon glyphicon-chevron-down"></i>
    </button>
    <ul class="dropdown-menu">
      <li><a onclick="$.get('/deploy')"><i class="glyphicon glyphicon-cog"></i>deploy</a></li>
      <li class="divider"></li>
      <li><a href="/backup"><i class="glyphicon glyphicon-cog"></i>backup</a></li>
      <li><a href="/restore"><i class="glyphicon glyphicon-cog"></i>restore</a></li>
      <li class="divider"></li>
      <li><a id="suspend"><i class="glyphicon glyphicon-off"></i>suspend</a></li>
      <li><a id="shutdown"><i class="glyphicon glyphicon-off"></i>shutdown</a></li>
      <li><a id="restart"><i class="glyphicon glyphicon-off"></i>reboot</a></li>
    </ul>
  </div>
  <!-- dlna menu -->
  <div class="dlna-show btn-group dropdown">
    <button type="button" class="btn btn-default dropdown-toggle btn-lg" data-toggle="dropdown">
      <i class="glyphicon glyphicon-chevron-down"></i>
    </button>
    <ul class="dropdown-menu">
      <li><a onclick="$.get('/dlnaseek/00:00:15')">00:15</a></li>
      <li><a onclick="$.get('/dlnaseek/00:00:30')">00:30</a></li>
      <li><a onclick="$.get('/dlnaseek/00:01:00')">01:00</a></li>
      <li><a onclick="$.get('/dlnaseek/00:01:30')">01:30</a></li>
      <!-- <li class="divider"></li> -->
      <!-- <li><a onclick="$.get('/dlnaplay/1.5')">1.5x</a></li> -->
      <!-- <li><a onclick="$.get('/dlnaplay/2')">2x</a></li> -->
      <!-- <li><a onclick="$.get('/dlnaplay/3')">3x</a></li> -->
    </ul>
  </div>
  <!-- player menu -->
  <!-- <button class="player-show btn btn-default btn-lg" id="videosize" type="button">orign</button> -->
  <div id="rate" class="player-show btn-group dropdown">
    <button type="button" class="btn btn-default dropdown-toggle btn-lg" data-toggle="dropdown">
      <i class="glyphicon glyphicon-chevron-down"></i>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#" onclick="rate(0.5)">0.5X</a></li>
      <li><a href="#" onclick="rate(0.75)">0.75X</a></li>
      <li class="divider"></li>
      <li><a href="#" onclick="rate(1)">1X</a></li>
      <li class="divider"></li>
      <li><a href="#" onclick="rate(1.5)">1.5X</a></li>
      <li><a href="#" onclick="rate(2)">2X</a></li>
      <li class="divider"></li>
      <li><a id="videosize">orign</a></li>
    </ul>
  </div><!-- #rate .btn-group .dropup -->
</div>
<!-- <div id="sidebar"> -->
  <!-- <button id="history" type="button" class="btn btn-default"> -->
    <!-- <i class="glyphicon glyphicon-list-alt"></i> -->
  <!-- </button> -->
<!-- </div> -->
<div id="dialog" class="col-xs-12 col-sm-8 col-md-8 col-lg-7">
  <div id="panel">
    <div class="bg-info panel-title">
      <button type="button" class="close">&times;</button>
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

      <button id="clear" type="button" class="btn btn-default">Clear History</button>
    </div><!-- .panel-footer -->
  </div><!-- #panel -->
</div><!-- #dialog -->
