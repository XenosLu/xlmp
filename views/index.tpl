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
  </body>
  % include('script.tpl')
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
