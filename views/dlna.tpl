{% extends base.tpl %}
{% block title %}DMC - Light Media Player{% end %}

    {% block main %}
    <div id="v-dlna">
      <div class="card text-center col-sm-12 col-md-8 col-lg-6 col-xl-5">
        <div class="card-head">
          <h2 class="card-title">&nbsp;</h2><!-- placeholder -->
          <b-btn-group>
            <b-dropdown variant="outline-dark" right split :text="currentDMR">
              <b-dropdown-item onclick="get('/dlna/searchdmr');">Search DMR</b-dropdown-item>
              <b-dropdown-divider></b-dropdown-divider>
              <b-dropdown-item v-for="item in DMRs" @click="set_dmr(item)">${ item }</b-dropdown-item>
            </b-dropdown>
          </b-btn-group>


        </div>
        <div class="card-body">
          <h5 class="card-title">${ src }</h5>
          <h6 class="card-subtitle mb-2 text-muted">${ state }</h6>
        </div>
        <div class="card-body">
          <b-btn-group>
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
          </b-btn-group>
          <!-- <h3 class="card-title">${ position }</h3> -->
          <h3 v-show="dlnaInfo.RelTime" class="card-title">${ dlnaInfo.RelTime} / ${ dlnaInfo.TrackDuration }</h3>
          <!-- <input type="range" id="position-bar" min="0" max="0"> -->
          <input id="position-bar"
                 v-model.number="positionBar.val"
                 type="range"
                 :min="positionBar.min"
                 :max="positionBar.max"
                 @change="positionSeek"
                 @input="positionShow">
        </div>
        <div class="card-footer">
          <b-btn-group class="my-3">
            <button onclick="get('/dlna/vol/down');" type="button" class="mx-5 volume btn btn-warning btn-lg">
              <i class="oi oi-volume-low"></i>
            </button>
            <button onclick="get('/dlna/vol/up');" type="button" class="mx-5 volume btn btn-warning btn-lg">
              <i class="oi oi-volume-high"></i>
            </button>
          </b-btn-group>
        </div>
      </div>
    </div>
    {% end %}

{% block script %}
<script src="{{ static_url('js/dlna.js') }}"></script>
{% end %}
