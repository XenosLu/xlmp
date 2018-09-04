<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=0.8, user-scalable=0, minimal-ui">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="shortcut icon" href="/static/favicon.ico" />
    <link rel="apple-touch-icon" sizes="200x200" href="/static/apple-touch-icon.png" />
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/css/bootstrap-vue.css" rel="stylesheet">
    <link href="/static/css/open-iconic-bootstrap.css" rel="stylesheet">
    <link href="{{ static_url('css/common.css') }}" rel="stylesheet">
    <script src="/static/js/vue.min.js"></script>
    <script src="/static/js/bootstrap-vue.js"></script>
    <title>{% block title %}Light Media Player{% end %}</title>
  </head>
  <body>
  <!-- alert box -->
  <div id="v-alert" class="fixed-top">
    <b-container>
      <b-alert :show="dismissCountDown" :variant="class_style" @dismissed="dismissCountDown=0" @dismiss-count-down="countDownChanged" dismissible>
         <strong>${ title }</strong> ${ content }
      </b-alert>
  </b-container>
  </div>
  <!-- alert box end -->
  <!-- output box -->
  <!-- <div id="v-output">test</div> -->
  <!-- output box end-->
    <div class="container">
      
      <div id="v-common">
        <video v-if="wp_src!==''" :key="wp_src" :src="'/video/' + wp_src" poster controls preload="meta">No video support!</video>
        <b-btn-toolbar v-show="uiState.fixBarShow" class="fixed-top" style="opacity: 0.8;">
          <b-container>
            <b-btn-group>
              <b-btn variant="outline-dark" title="browser" @click="showModal">
                <i class="oi oi-list"></i>
              </b-btn>
              <b-btn variant="outline-success"
                     title="switch DLNA mode"
                     :pressed="uiState.dlnaShow"
                     @click="window.location.href = uiState.dlnaShow ? '/' : '/dlna'">
                DLNA <i v-show="uiState.dlnaOn" class="oi oi-monitor"></i>
              </b-btn>
              <b-dropdown variant="outline-dark" right text="Maintain">
                <b-dropdown-item onclick="get('/sys/update')">update</b-dropdown-item>
                <b-dropdown-item onclick="get('/sys/backup')">backup</b-dropdown-item>
                <b-dropdown-divider></b-dropdown-divider>
                <b-dropdown-item onclick="get('/sys/restore')">restore</b-dropdown-item>
                <b-dropdown-item onclick="get('/test')">test</b-dropdown-item>
              </b-dropdown>
            <b-btn-group class="mx-1">
            </b-btn-group>
              <!-- dlna menu -->
              <b-dropdown variant="outline-dark" right v-show="uiState.dlnaShow" text="Seek">
                <b-dropdown-item onclick="get('/dlna/seek/00:00:15')">00:15</b-dropdown-item>
                <b-dropdown-item onclick="get('/dlna/seek/00:00:29')">00:30</b-dropdown-item>
                <b-dropdown-item onclick="get('/dlna/seek/00:01:00')">01:00</b-dropdown-item>
                <b-dropdown-item onclick="get('/dlna/seek/00:01:30')">01:30</b-dropdown-item>
              </b-dropdown>
              <!-- dlna menu end -->
              <!-- wp menu -->
               <b-dropdown variant="outline-dark" right v-show="uiState.rateMenu" text="Rate">
                <b-dropdown-item onclick="rate(0.5)">0.5X</b-dropdown-item>
                <b-dropdown-item onclick="rate(0.75)">0.75X</b-dropdown-item>
                <b-dropdown-divider></b-dropdown-divider>
                <b-dropdown-item onclick="rate(1)">1X</b-dropdown-item>
                <b-dropdown-divider></b-dropdown-divider>
                <b-dropdown-item onclick="rate(1.5)">1.5X</b-dropdown-item>
                <b-dropdown-item onclick="rate(1.75)">1.75X</b-dropdown-item>
                <b-dropdown-item onclick="rate(2)">2X</b-dropdown-item>
                <b-dropdown-item onclick="rate(2.5)">2.5X</b-dropdown-item>
                <b-dropdown-divider></b-dropdown-divider>
                <b-dropdown-item id="videosize">${ uiState.videoBtnText }</b-dropdown-item>
              </b-dropdown>
              <!-- wp menu end -->
            </b-btn-group>
          </b-container>
        </b-btn-toolbar>
        
        <!-- Modal Component -->
        <!-- <b-modal v-model="modalShow" size="lg" class="col-xs-12 col-sm-12 col-md-8 col-lg-7" centered hide-footer hide-header> -->
        <b-modal modal-class="['card']" v-model="uiState.modalShow" size="lg" centered hide-footer hide-header>
          <div class="card-header" style="background-color: #C3E6CB;">
            <b-btn @click="showHistory" :pressed="uiState.historyShow" variant="outline-dark">
              <i class="oi oi-book"></i>History
            </b-btn>
            <b-btn onclick="filelist('/fs/ls/')" :pressed="!uiState.historyShow" variant="outline-dark">
              <i class="oi oi-home"></i>Home dir
            </b-btn>
            <b-btn @click="uiState.modalShow=false" class="close">&times;</b-btn>
          </div>
          <div id="ModalTouch" class="table-responsive-sm text-center">
            <table v-show="uiState.historyShow" class="table table-striped table-sm">
              <tr v-for="item in history">
                <td :class="[swipeState > 0 ? '' : 'd-none']"
                    class="icon d-sm-block bg-info"
                    @click="open(item.path, 'folder')">
                  <i class="text-white oi oi-folder"></i>
                  <br>
                  <small class="text-white">go Dir</small>
                </td>
                <td class="iconOnly"><i class="oi oi-video"></i></td>
                <td @click="play(item.filename)" :data-target="item.path">
                  <span :class="item.exist ? 'mp4' : 'other'">${ item.filename }</span>
                  <br>
                  <small class="text-muted">
                    ${ item.latest_date } |
                    ${ secondToTime(item.position) } /
                    ${ secondToTime(item.duration) }
                  </small>
                </td>
                <td :class="[swipeState < 0 ? '' : 'd-none']"
                    class="icon d-sm-block bg-danger"
                    @click="remove(item.filename)">
                  <i class="text-white oi oi-trash"></i>
                  <br>
                  <small class="text-white">Remove</small>
                </td>
              </tr>
            </table>
            <table v-show="!uiState.historyShow" class="table table-striped table-sm">
              <tr v-for="item in filelist">
                <td class="iconOnly"><i :class="icon[item.type]" class="oi"></i></td>
                <!-- <td :class="item.type" @click="open(item.path, item.type)" :data-type="item.type" :data-open="item.path"> -->
                <td :class="item.type" :data-type="item.type" :data-path="item.path">
                  ${ item.filename }
                  <br>
                  <small class="text-muted">${ item.size }</small>
                </td>
                <td :class="[swipeState < 0 ? '' : 'd-none']"
                    class="icon d-sm-block bg-danger"
                    @click="move(item.path)">
                  <i class="text-white oi oi-trash"></i><br>
                  <small class="text-white">Move</small>
                </td>
              </tr>
            </table>
          </div>
          <div v-show="uiState.historyShow" class="card-footer text-center">
            <b-btn @click="clearHistory" variant="outline-dark">
              Clear
            </b-btn>
          </div>
        </b-modal>
      </div>
      {% block main %}
      {% end %}
    </div>
    {% block footer %}
    <footer class="text-center">
      <small class="text-muted">&copy;2016-2018 Xenos' Light Media Player</small>
    </footer>
    {% end %}
  </body>
  <script src="/static/js/jquery-3.2.1.min.js"></script>
  <!-- <script src="/static/js/bootstrap.min.js"></script> -->
  <script src="/static/js/hammer.min.js"></script>
  <script src="{{ static_url('js/common.js') }}"></script>
    {% block script %}{% end %}
</html>
