{% extends base.tpl %}
    {% block main %}
    <div id="result"></div>
    {% end %}
{% block script %}
  <script>
  toggleDialog();
  /*
  var source = new EventSource("/test");
source.onmessage = function(event) {
    document.getElementById("result").innerHTML += event.data + "<br />";
};*/
  </script>
{% end %}
