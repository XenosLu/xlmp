{% extends base.tpl %}
{% block title %}DMC - Light Media Player{% end %}

    {% block main %}
    <div class="dlna-show col-xs-12 col-sm-8 col-md-6">
      <div id="dmr" class="btn-group dropdown">
        <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
          <li><a onclick="get('/dlna/searchdmr');">Search DMR</a></li>
        </ul>
      </div>
     <h3 id="src"></h3>
      <div><span id="state">No State</span></div>
      <div class="btn-group">
        <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/play')">
          <i class="icono-play"></i>
        </button>
        <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlna/pause')">
          <i class="icono-pause"></i>
        </button>
        <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlna/stop')">
          <i class="icono-stop"></i>
        </button>
        <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/next')">
          <i class="icono-next"></i>
        </button>
      </div>
        <h3 id="position"></h3>
        <input type="range" id="position-bar" min="0" max="0">
        <button onclick="get('/dlna/vol/down');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-minus"><i class="icono-volumeDecrease"></i>
        </button>
        <button onclick="get('/dlna/vol/up');" type="button" class="volume btn btn-warning btn-lg glyphicon glyphicon-plus">
        <i class="icono-volumeIncrease"></i>
        </button>
    </div>
    {% end %}

{% block script %}
<script src="{{ static_url('js/dlna.js') }}"></script>
{% end %}
