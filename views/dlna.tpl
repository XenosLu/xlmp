{% extends base.tpl %}
{% block title %}DMC - Light Media Player{% end %}

    {% block main %}
    <div id="v-dlna">
      <div class="card text-center col-xs-12 col-sm-8 col-md-6">
        <div class="card-head">
          <h2 class="card-title">&nbsp;</h2>
          <b-btn-group>
            <b-btn onclick="get('/dlna/searchdmr');">Search DMR</b-btn>
            <b-dropdown v-for="item in DMRs" right split :text="currentDMR">
              <b-dropdown-item @click="set_dmr(item)">${ item }</b-dropdown-item>
              <!-- <b-dropdown-divider></b-dropdown-divider> -->
            </b-dropdown>
          </b-btn-group>

        
        
          <!-- <div id="dmr" class="btn-group dropdown"> -->
            <!-- <button type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown"><span class="caret"></span> -->
            <!-- </button> -->
            <!-- <ul class="dropdown-menu"> -->
              <!-- <li><a onclick="get('/dlna/searchdmr');">Search DMR</a></li> -->
            <!-- </ul> -->
          <!-- </div> -->
          <!-- <h3 id="src"></h3> -->
          <!-- <div><span>${ state }</span></div> -->
        </div>
        <div class="card-body">
          <h5 class="card-title">${ src }</h5>
          <h6 class="card-subtitle mb-2 text-muted">${ state }</h6>
        
          <div class="btn-group">
            <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/play')">
              <i class="oi oi-media-play"></i>
            </button>
            <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlna/pause')">
              <i class="oi oi-media-pause"></i>
            </button>
            <button class="btn btn-danger btn-lg" type="button" onclick="get('/dlna/stop')">
              <i class="oi oi-media-stop"></i>
            </button>
            <button class="btn btn-success btn-lg" type="button" onclick="get('/dlna/next')">
              <i class="oi oi-media-step-forward"></i>
            </button>
          </div>
          <h3 class="card-title" id="position">${ position }</h3>
          <input type="range" id="position-bar" min="0" max="0">
          <button onclick="get('/dlna/vol/down');" type="button" class="volume btn btn-warning btn-lg">
          <i class="oi oi-volume-low"></i>
          </button>
          <button onclick="get('/dlna/vol/up');" type="button" class="volume btn btn-warning btn-lg">
          <i class="oi oi-volume-high"></i>
          </button>
        </div>
        <div class="card-footer"></div>
      </div>
    </div>
    {% end %}

{% block script %}
<script src="{{ static_url('js/dlna.js') }}"></script>
{% end %}
