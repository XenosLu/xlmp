<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1.0, user-scalable=1">
    <title>{{title}}</title>
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/css/player.css" rel="stylesheet">
  </head>
  <body>
  % include('common.tpl')

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
  <script> 
if ("{{mode}}" == "index") {
    history("/list");
    $("#dialog").show(250);
}


$("#tabFrame").on("click", ".folder", function () {
    filelist("/fs" + this.title + "/");
}).on("click", ".move", function () {
    if (confirm("Move " + this.title + " to old?")) {
        filelist("/move/" + this.title);
    }
}).on("click", ".remove", function () {
    if (confirm("Clear " + this.title + "?"))
        history("/remove/" + this.title);
}).on("click", ".mp4", function () {
    window.location.href = "/play/" + this.title;
}).on("click", ".dlna", function () {
    $.get("/dlnaload/" + this.title, function(){
        if("{{mode}}" != "dlna")
            window.location.href = "/";
            //window.location.href = "/dlna";
        else
            $("#dialog").hide(250);
    });
});

  </script>
</html>
