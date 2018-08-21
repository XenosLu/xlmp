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
    <!-- <b-modal id="modal_new" size="lg" class="col-xs-12 col-sm-8 col-md-8 col-lg-7" centered hide-footer title-tag="h6" title="Browser"> -->
    <b-modal id="modal_new" v-model="modalShow" size="lg" centered hide-footer hide-header>
       <b-btn @click="showHistory" :pressed="historyShow" variant="outline-dark">
         <i class="oi oi-book"></i>History
       </b-btn>
       <b-btn onclick="filelist('/fs/ls/')" :pressed="!historyShow" variant="outline-dark">
         <i class="oi oi-home"></i>Home dir
       </b-btn>
       <b-btn @click="modalShow=false" class="close">&times;</b-btn>
       <div class="table-responsive-sm">
         <table v-show="historyShow" class="table table-striped table-hover table-sm">
           <tr v-for="item in history">
             <!-- <td class="d-none d-sm-block" @click="open(item.path, 'folder')"><i class="oi oi-folder"></i></td> -->
             <td @click="open(item.path, 'folder')"><i class="oi oi-folder"></i></td>
             <td><i class="oi oi-video"></i></td>
             <td @click="play(item.filename)">
               <span :class="item.exist ? 'mp4' : 'other'">${ item.filename }</span>
               <small>${ item.latest_date } | ${ secondToTime(item.position) } / ${ secondToTime(item.duration) }</small>
             </td>
             <td @click="remove(item.filename)"><i class="oi oi-trash"></i></td>
           </tr>
         </table>
         <!-- <table v-show="!historyShow" class="table table-striped table-hover table-sm"> -->
         <table v-show="!historyShow" class="table table-striped table-hover">
           <tr v-for="item in filelist">
             <td><i :class="icon[item.type]"></i></td>
             <td :class="item.type" @click="open(item.path, item.type)">
               ${ item.filename }<br><small>${ item.size }</small>
             </td>
             <td @click="move(item.filename)"><i class="oi oi-trash"></i></td>
           </tr>
         </table>
       </div>
          <!-- td[1] = '<td class="filelist ' + n["type"] + '" title="' + n["path"] + '">' + n["filename"] + size + "</td>"; -->
          <!-- td[2] = '<td class="move" title="' + n["path"] + '">' + '<i class="glyphicon glyphicon-remove-circle"></i></td>'; -->


          <!-- td[0] = '<td class="folder" title="' + n["path"] + '">' + '<i class="glyphicon glyphicon-folder-close"></i></td>'; -->
          <!-- td[1] = '<td><i class="glyphicon glyphicon-film"></i></td>'; -->
          <!-- td[2] = '<td class="filelist ' + mediaType + '" title="' + n["filename"] + '">' + n["filename"] + "<br><small>" + n["latest_date"] + " | " + secondToTime(n["position"]) + "/" + secondToTime(n["duration"]) + "</small></td>"; -->
          <!-- td[3] = '<td class="remove" title="' + n["filename"] + '">' + '<i class="glyphicon glyphicon-remove-circle"></i>' + "</td>"; -->

    </b-modal>
  
  <!-- <div id="dialog" class="col-xs-12 col-sm-8 col-md-8 col-lg-7"> -->
  <!-- </div> -->
</div>