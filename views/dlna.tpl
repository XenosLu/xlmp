{% extends base.tpl %}
{% block title %}DMC - Light Media Player{% end %}

    {% block main %}
    <div id="v-dlna">
      <div class="card text-center col-sm-12 col-md-8 col-lg-6 col-xl-5">
        <div class="card-head">
          <!-- <h2 class="card-title">&nbsp;</h2> -->
          <!-- placeholder -->
          <b-btn-group class="mt-5">
            <b-dropdown variant="outline-dark" right split :text="currentDMR">
              <b-dropdown-item onclick="get('/dlna/searchdmr');">Search DMR</b-dropdown-item>
              <b-dropdown-divider></b-dropdown-divider>
              <b-dropdown-item v-for="item in DMRs" @click="setDmr(item)">${ item }</b-dropdown-item>
            </b-dropdown>
          </b-btn-group>
        </div>
        <div class="card-body">
          <h5 class="card-title" id="src">${ src }</h5>
          <h6 class="card-subtitle text-muted">${ state }</h6>
        </div>
        <div class="card-body">
          <b-btn-group>
            <b-btn class="mx-1" variant="outline-success" size="lg" onclick="get('/dlna/play')">
                <i class="oi oi-media-play"></i>
            </b-btn>
            <b-btn class="mx-1" variant="outline-danger" size="lg" onclick="get('/dlna/pause')">
                <i class="oi oi-media-pause"></i>
            </b-btn>
            <b-btn class="mx-1" variant="outline-danger" size="lg" onclick="get('/dlna/stop')">
                <i class="oi oi-media-stop"></i>
            </b-btn>
            <b-btn class="mx-1" variant="outline-success" size="lg" onclick="get('/dlna/next')">
                <i class="oi oi-media-step-forward"></i>
            </b-btn>
          </b-btn-group>
          <!-- <h3 class="card-title">${ position }</h3> -->
          <h3 v-show="dlnaInfo.RelTime" class="card-title mt-3">
            ${ dlnaInfo.RelTime} / ${ dlnaInfo.TrackDuration }
          </h3>
          <input class="position-bar my-4"
                 v-model.number="positionBar.val"
                 type="range"
                 :min="positionBar.min"
                 :max="positionBar.max"
                 @change="positionSeek"
                 @input="positionShow">
        </div>
        <div class="card-footer">
          <b-btn-group class="my-3">
            <b-btn class="mx-5" variant="outline-warning" size="lg" onclick="get('/dlna/vol/down')">
                <i class="oi oi-volume-low"></i>
            </b-btn>
            <b-btn class="mx-5" variant="outline-warning" size="lg" onclick="get('/dlna/vol/up')">
                <i class="oi oi-volume-high"></i>
            </b-btn>
          </b-btn-group>
        </div>
      </div>
    </div>
    {% end %}

{% block script %}
<script src="{{ static_url('js/dlna.js') }}"></script>
{% end %}
