{% extends base.tpl %}
{% block title %}DMC - Light Media Player{% end %}

    {% block main %}
    <div class="dlna-show col-xs-12 col-sm-6 col-md-4">
      <div id="dmr" class="btn-group dropdown">
        <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
          <li><a onclick="get('/searchdmr');">Search DMR</a></li>
        </ul>
      </div>
      <!-- <h3 id="src"></h3> -->
      <div><span id="src" style="font-size:1.5em"></span></div>
      <div><span id="src" style="font-size:1vw"></span></div>
      <div><span id="src" style="font-size:1.5vw"></span></div>
      <div><span id="state">No State</span></div>
      <div class="btn-group">
        <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/play')">
          <i class="glyphicon glyphicon-play"></i>
        </button>
        <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlna/pause')">
          <i class="glyphicon glyphicon-pause"></i>
        </button>
        <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlna/stop')">
          <i class="glyphicon glyphicon-stop"></i>
        </button>
        <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/next')">
          <i class="glyphicon glyphicon-step-forward"></i>
        </button>
      </div>
        <h3 id="position"></h3>
        <input type="range" id="position-bar" min="0" max="0">
        <button onclick="get('/dlnavol/down');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-minus">
        <button onclick="get('/dlnavol/up');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-plus">
      </button>
    </div>
    {% end %}

{% block script %}
<script src="{{ static_url('js/dlna.js') }}"></script>
{% end %}
