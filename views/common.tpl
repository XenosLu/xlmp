<div id="v-common">
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
        <!-- dlna menu end -->
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
            <td class="iconOnly"><i :class="icon[item.type]"></i></td>
            <td :class="item.type" @click="open(item.path, item.type)">
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