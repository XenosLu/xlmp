<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1.0, user-scalable=0, minimal-ui">
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="{{ static_url('css/common.css') }}" rel="stylesheet">
    <title>{% block title %}Light Media Player{% end %}</title>
  </head>
  <body>
    <!-- test -->
        <!-- <div id="contents" style="height:500px;overflow:auto;"></div> -->
    <!-- <div> -->
        <!-- <textarea id="msg"></textarea> -->
        <!-- <a href="javascript:;" onclick="sendMsg()">发送</a> -->
    <!-- </div> -->
    <!-- test -->
    {% block main %}
      {% include common.tpl %}
    {% end %}
    {% block footer %}
    <footer class="text-center"><small>&copy;2016-2018 Xenos' Light Media Player</small></footer>
    {% end %}
  </body>
  <script src="/static/js/jquery-3.2.1.min.js"></script>
  <script src="/static/js/bootstrap.min.js"></script>
  <script src="{{ static_url('js/common.js') }}"></script>
  <!-- test -->
      <script type="text/javascript">
      /*
        var ws = new WebSocket("ws://" + window.location.host + "/test/");
        ws.onmessage = function(e) {
            console.log(e.data);
            console.log($.parseJSON(e.data));
            console.log($.parseJSON(e.data)["xx"]);
            $("#contents").append("<p>" + $.parseJSON(e.data)["xx"] + "</p>");
        }
        function sendMsg() {
            var msg = $("#msg").val();
            ws.send(msg);
            $("#msg").val("");
        }
        */
    </script>
    <!-- test -->
    {% block script %}
    {% end %}
</html>
