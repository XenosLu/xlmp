<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1.0, user-scalable=0, minimal-ui">
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/css/common.css?v=1" rel="stylesheet">
    <title>{% block title %}Light Media Player{% end %}</title>
  </head>
  {% block body %}
  <body>
    {% block main %}
      {% include common.tpl %}
    {% end %}
    {% block footer %}
    <footer class="text-center"><small>&copy;2016-2018 Xenos' Light Media Player</small></footer>
    {% end %}
  </body>
{% include common_script.tpl %}
    {% block script %}
    {% end %}
  {% end %}
  
</html>
