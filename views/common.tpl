<!-- <nav class="navbar navbar-default navbar-fixed-top"> -->
<!-- <nav class="navbar navbar-default"> -->
<!-- <nav class="navbar-default navbar-light bg-faded"> -->
  <!-- <div class="container-fluid"> -->
    <!-- <!-- Brand and toggle get grouped for better mobile display -->
    <!-- <div class="navbar-header"> -->
      <!-- <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-1" aria-expanded="false"> -->
        <!-- <span class="icon-bar"></span> -->
        <!-- <span class="icon-bar"></span> -->
        <!-- <span class="icon-bar"></span> -->
      <!-- </button> -->
      <!-- <a class="navbar-brand" href="/">XLMP</a> -->
      <!-- <!-- <button class="navbar-brand btn btn-default" id="history"><i class="glyphicon glyphicon-list-alt"></i></button> -->
      <!-- <!-- <a class="navbar-brand btn btn-default" id="dlna_toggle" href="/dlna">DLNA</a> -->
      <!-- <!-- <ul class="nav navbar-nav navbar-left"> -->
        <!-- <!-- <li id="history"><a><i class="glyphicon glyphicon-th-list"></i></a></li> -->
        <!-- <!-- <li id="dlna_toggle"><a href="/dlna">DLNA</a></li> -->
      <!-- <!-- </ul> -->
        <!-- <div class="btn-group" role="group" aria-label="..."> -->
          <!-- <!-- <button id="history" type="button" class="navbar-brand btn btn-default"><i class="glyphicon glyphicon-th-list"></i></button> -->
          <!-- <!-- <a id="dlna_toggle" href="/dlna" type="button" class="navbar-brand  btn btn-default">DLNA</a> -->
        <!-- </div> -->
    <!-- </div> -->

    <!-- <div class="collapse navbar-collapse" id="navbar-collapse-1"> -->
      <!-- <ul class="nav navbar-nav navbar-right"> -->
        <!-- <li class="dropdown"> -->
          <!-- <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="glyphicon glyphicon-off"></i><span class="caret"></span></a> -->
          <!-- <ul class="dropdown-menu"> -->
            <!-- <li> -->
              <!-- <a onClick="if(confirm('Suspend ?'))$.post('/suspend');"> -->
              <!-- <i class="glyphicon glyphicon-off"></i>suspend</a> -->
            <!-- </li> -->
            <!-- <li> -->
              <!-- <a onClick="if(confirm('Shutdown ?'))$.post('/shutdown');"> -->
              <!-- <i class="glyphicon glyphicon-off"></i>shutdown</a> -->
            <!-- </li> -->
            <!-- <li> -->
              <!-- <a onClick="if(confirm('Restart ?'))$.post('/restart');"> -->
              <!-- <i class="glyphicon glyphicon-off"></i>reboot</a> -->
            <!-- </li> -->
          <!-- </ul> -->
        <!-- </li> -->
      <!-- </ul> -->
    <!-- </div><!-- /.navbar-collapse -->
  <!-- </div><!-- /.container-fluid -->
<!-- </nav> -->

<div id="sidebar" class="btn-toolbar" role="toolbar">
  <div class="btn-group" role="group">
    <button id="history" type="button" class="btn btn-default"><i class="glyphicon glyphicon-th-list"></i></button>
    <a id="dlna_toggle" href="/dlna" type="button" class="btn btn-default">DLNA</a>
  </div>
  <div class="btn-group dropdown">
    <button type="button" class="btn btn-default dropdown-toggle collapsed"  data-toggle="dropdown">
      more
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
      <li><a href='/backup'><i class="glyphicon glyphicon-cog"></i>backup</a></li>
      <li><a href='/restore'><i class="glyphicon glyphicon-cog"></i>restore</a></li>
      <li role="separator" class="divider"></li>
      <li>
        <a onClick="if(confirm('Suspend ?'))$.post('/suspend');">
        <i class="glyphicon glyphicon-off"></i>suspend</a>
      </li>
      <li>
        <a onClick="if(confirm('Shutdown ?'))$.post('/shutdown');">
        <i class="glyphicon glyphicon-off"></i>shutdown</a>
      </li>
      <li>
        <a onClick="if(confirm('Restart ?'))$.post('/restart');">
        <i class="glyphicon glyphicon-off"></i>reboot</a>
      </li>
    </ul>
  </div>
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
      </div><!-- #rate .btn-group .dropup -->
      <button id="clear" type="button" class="btn btn-default">Clear History</button>
      <!-- <div class="btn-group dropup"> -->
        <!-- <button type="button" class="btn btn-default" onClick="if(confirm('Suspend ?'))$.post('/suspend');"> -->
          <!-- <i class="glyphicon glyphicon-off"></i> -->
        <!-- </button> -->
        <!-- <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"> -->
          <!-- <span class="caret"></span> -->
        <!-- </button> -->
        <!-- <ul class="dropdown-menu" role="menu"> -->
          <!-- <li> -->
            <!-- <a onClick="if(confirm('Shutdown ?'))$.post('/shutdown');"> -->
            <!-- <i class="glyphicon glyphicon-off"></i>shutdown</a> -->
          <!-- </li> -->
          <!-- <li> -->
            <!-- <a onClick="if(confirm('Restart ?'))$.post('/restart');"> -->
            <!-- <i class="glyphicon glyphicon-off"></i>reboot</a> -->
          <!-- </li> -->
        <!-- </ul> -->
      <!-- </div> -->
      <!-- .btn-group .dropup -->
    </div>
  </div><!-- #panel -->
</div><!-- #dialog -->
