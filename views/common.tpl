<div id="v-common">
  <div id="sidebar" class="btn-toolbar">
    <b-button-group>
      <!-- <b-btn variant="outline-dark" title="browser" id="history" v-b-modal.modal_new> -->
      <b-btn variant="outline-dark" title="browser" id="history" @click="showModal">
        <i class="oi oi-list"></i>
      </b-btn>
      <b-button variant="outline-success" title="switch DLNA mode" id="dlna_toggle" onclick='window.location.href = "/dlna";'>
        DLNA <i v-show="dlnaOn" class="oi oi-monitor"></i>
      </b-button>
      <b-dropdown right text="Maintain">
        <b-dropdown-item onclick="get('/sys/update')">update</b-dropdown-item>
        <b-dropdown-item onclick="get('/sys/backup')">backup</b-dropdown-item>
        <b-dropdown-divider></b-dropdown-divider>
        <b-dropdown-item onclick="get('/sys/restore')">restore</b-dropdown-item>
      </b-dropdown>
      <!-- dlna menu -->
      <b-dropdown right v-show="dlnaShow" text="Jump">
        <b-dropdown-item onclick="get('/dlna/seek/00:00:15')">00:15</b-dropdown-item>
        <b-dropdown-item onclick="get('/dlna/seek/00:00:29')">00:30</b-dropdown-item>
        <b-dropdown-item onclick="get('/dlna/seek/00:01:00')">01:00</b-dropdown-item>
        <b-dropdown-item onclick="get('/dlna/seek/00:01:30')">01:30</b-dropdown-item>
      </b-dropdown>
       <b-dropdown right class="oi oi-video" v-show="rateMenu" text="Rate">
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
        <b-dropdown-item id="videosize">orign</b-dropdown-item>
      </b-dropdown>
      <!-- dlna menu end -->

    </b-button-group>
  </div>

    <!-- Modal Component -->
    <!-- <b-modal v-model="modalShow" id="modal_new" size="lg" class="col-xs-12 col-sm-12 col-md-8 col-lg-7" centered hide-footer title-tag="h6" title="Browser"> -->
    <b-modal modal-class="'card'" v-model="modalShow" size="lg" centered hide-footer hide-header>
      <!-- <div class="card"> -->
        <div class="card-header">
          <b-btn @click="showHistory" :pressed="historyShow" variant="outline-dark">
            <i class="oi oi-book"></i>History
          </b-btn>
          <b-btn onclick="filelist('/fs/ls/')" :pressed="!historyShow" variant="outline-dark">
            <i class="oi oi-home"></i>Home dir
          </b-btn>
          <b-btn @click="modalShow=false" class="close">&times;</b-btn>
        </div>
        <div id="test" class="table-responsive-sm">
          <table v-show="historyShow" class="table table-striped table-sm">
            <tr v-for="item in history">
              <td :class="[folder_class]" class="icon d-sm-block bg-info" @click="open(item.path, 'folder')">
                <i class="text-white oi oi-folder"></i>
                <br>
                <small class="text-white">Open Dir</small>
              </td>
              <!-- <td><i class="oi oi-video"></i></td> -->
              <td @click="play(item.filename)">
                <span :class="item.exist ? 'mp4' : 'other'">${ item.filename }</span>
                <br>
                <small class="text-muted">
                  ${ item.latest_date } | ${ secondToTime(item.position) } / ${ secondToTime(item.duration) }
                </small>
              </td>
              <td :class="[remove_class]" class="icon d-sm-block bg-danger" @click="remove(item.filename)">
                <i class="text-white oi oi-trash"></i>
                <br>
                <small class="text-white">Remove</small>
              </td>
            </tr>
          </table>
          <table v-show="!historyShow" class="table table-striped table-sm">
            <tr v-for="item in filelist">
              <td class="icon"><i :class="icon[item.type]"></i></td>
              <td :class="item.type" @click="open(item.path, item.type)">
                ${ item.filename }
                <br>
                <small class="text-muted">${ item.size }</small>
              </td>
              <td :class="[remove_class]" class="icon d-sm-block bg-danger" @click="move(item.filename)">
                <i class="text-white oi oi-trash"></i><br>
                <small class="text-white">Move</small>
              </td>
            </tr>
          </table>
        </div>
           <!-- td[1] = '<td class="filelist ' + n["type"] + '" title="' + n["path"] + '">' + n["filename"] + size + "</td>"; -->
           <!-- td[2] = '<td class="move" title="' + n["path"] + '">' + '<i class="glyphicon glyphicon-remove-circle"></i></td>'; -->
        
        
           <!-- td[0] = '<td class="folder" title="' + n["path"] + '">' + '<i class="glyphicon glyphicon-folder-close"></i></td>'; -->
           <!-- td[1] = '<td><i class="glyphicon glyphicon-film"></i></td>'; -->
           <!-- td[2] = '<td class="filelist ' + mediaType + '" title="' + n["filename"] + '">' + n["filename"] + "<br><small>" + n["latest_date"] + " | " + secondToTime(n["position"]) + "/" + secondToTime(n["duration"]) + "</small></td>"; -->
           <!-- td[3] = '<td class="remove" title="' + n["filename"] + '">' + '<i class="glyphicon glyphicon-remove-circle"></i>' + "</td>"; -->
      <!-- <div> -->
    </b-modal>
  
  <!-- <div id="dialog" class="col-xs-12 col-sm-8 col-md-8 col-lg-7"> -->
  <!-- </div> -->
</div>