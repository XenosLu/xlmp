{% extends base.tpl %}
{% block title %}DMC - Light Media Player{% end %}

    {% block main %}
    <div id="v-dlna">
      <div class="text-center col-sm-12 col-md-8 col-lg-6 col-xl-5">
        <div class="card-head">
          <b-btn-group class="mt-5">
            <b-dropdown variant="outline-dark" right split :text="dlnaInfo.CurrentDMR">
              <b-dropdown-item onclick="get('/dlna/searchdmr');">Search DMR</b-dropdown-item>
              <b-dropdown-divider></b-dropdown-divider>
              <b-dropdown-item v-for="item in dlnaInfo.DMRs" @click="setDmr(item)">${ item }</b-dropdown-item>
            </b-dropdown>
          </b-btn-group>
        </div>
        <b-card bg-variant="light" :title="dlnaInfo.TrackURI ? decodeURI(dlnaInfo.TrackURI) : ''" class="my-4 title" id="DlnaTouch">
        </b-card>
      </div>

      <div class="container fixed-bottom text-center">
        <div class="card-footer col-sm-12 col-md-8 col-lg-6 col-xl-5">
          <h6 class="card-subtitle text-muted">${ dlnaInfo.CurrentTransportState }</h6>
          <h6 v-show="dlnaInfo.RelTime" class="card-title mt-3">
            ${ dlnaInfo.RelTime} / ${ dlnaInfo.TrackDuration }
          </h6>
          <input class="position-bar my-3"
                 v-model.number="positionBar.val"
                 type="range"
                 :min="positionBar.min"
                 :max="positionBar.max"
                 @change="positionSeek"
                 @input="positionShow">
          <b-btn-toolbar justify class="my-3 text-center">
            <b-btn-group>
              <b-btn class="mx-1" variant="outline-warning" size="lg" onclick="get('/dlna/vol/down')">
                  <i class="oi oi-volume-low"></i>
              </b-btn>
            </b-btn-group>
            <b-btn-group>
              <b-btn class="" variant="outline-success" size="lg" onclick="get('/dlna/play')">
                  <i class="oi oi-media-play"></i>
              </b-btn>
              <b-btn class="" variant="outline-danger" size="lg" onclick="get('/dlna/pause')">
                  <i class="oi oi-media-pause"></i>
              </b-btn>
              <b-btn class="" variant="outline-danger" size="lg" onclick="get('/dlna/stop')">
                  <i class="oi oi-media-stop"></i>
              </b-btn>
              <b-btn class="" variant="outline-success" size="lg" onclick="get('/dlna/next')">
                  <i class="oi oi-media-step-forward"></i>
              </b-btn>
            </b-btn-group>
            <b-btn-group>
              <b-btn class="mx-1" variant="outline-warning" size="lg" onclick="get('/dlna/vol/up')">
                <i class="oi oi-volume-high"></i>
              </b-btn>
            </b-btn-group>
           </b-btn-toolbar>
          </div>
      </div>
    </div>
    {% end %}

{% block script %}
<script src="{{ static_url('js/dlna.js') }}"></script>
{% end %}
