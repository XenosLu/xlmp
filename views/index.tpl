<!doctype html>
<html>
  <head>
    % include('commonhead.tpl')
    <title>{{!title}}</title>
  </head>
  <body>
    % include('common.tpl')
  </body>
  % include('commonscript.tpl')
  <script> 

history("/list");
$("#dialog").show(250);

  </script>
</html>
