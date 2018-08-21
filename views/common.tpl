<div id="v-common">
<div id="sidebar" class="btn-toolbar">
  <b-button-group>
    <b-btn variant="outline-dark" title="browser" id="history" v-b-modal.modal_new><i class="icono-list"></i></b-btn>
    <!-- <b-button variant="outline-dark" title="browser" id="history"><i class="icono-list"></i></b-button> -->
    <b-button variant="outline-success" title="switch DLNA mode" id="dlna_toggle" onclick='window.location.href = "/dlna";'>DLNA</b-button>
    <b-dropdown right>
      <b-dropdown-item onclick="get('/sys/update')">update</b-dropdown-item>
      <b-dropdown-item onclick="get('/sys/backup')">backup</b-dropdown-item>
      <b-dropdown-divider></b-dropdown-divider>
      <b-dropdown-item onclick="get('/sys/restore')">restore</b-dropdown-item>
    </b-dropdown>
    <!-- dlna menu -->
    <b-dropdown right v-show="dlnashow">
      <b-dropdown-item onclick="get('/dlna/seek/00:00:15')">00:15</b-dropdown-item>
      <b-dropdown-item onclick="get('/dlna/seek/00:00:29')">00:30</b-dropdown-item>
      <b-dropdown-item onclick="get('/dlna/seek/00:01:00')">01:00</b-dropdown-item>
      <b-dropdown-item onclick="get('/dlna/seek/00:01:30')">01:30</b-dropdown-item>
    </b-dropdown>
    <!-- dlna menu end -->

  </b-button-group>

  <!-- player menu -->
  <div id="rate" class="btn-group dropdown">
    <button type="button" class="btn btn-default dropdown-toggle btn-lg" data-toggle="dropdown">
      <i class="glyphicon glyphicon-chevron-down"></i>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#" onclick="rate(0.5)">0.5X</a></li>
      <li><a href="#" onclick="rate(0.75)">0.75X</a></li>
      <li class="divider"></li>
      <li><a href="#" onclick="rate(1)">1X</a></li>
      <li class="divider"></li>
      <li><a href="#" onclick="rate(1.5)">1.5X</a></li>
      <li><a href="#" onclick="rate(1.75)">1.75X</a></li>
      <li><a href="#" onclick="rate(2)">2X</a></li>
      <li><a href="#" onclick="rate(2.5)">2.5X</a></li>
      <li class="divider"></li>
      <li><a id="videosize">orign</a></li>
    </ul>
  </div><!-- #rate .btn-group .dropup -->
</div>

  

  <!-- Modal Component -->
  <b-modal id="modal_new" size="lg" class="col-xs-12 col-sm-8 col-md-8 col-lg-7" centered hide-footer title-tag="h6" title="Browser">
     <b-btn onclick="history('/hist/ls')"><i class="icono-document"></i>History</b-btn>
     <b-btn onclick="filelist('/fs/ls/')"><i class="icono-home"></i>Home dir</b-btn>
     <div class="table-responsive-sm">
     <table v-show="history_show" class="table-striped table-condensed table table-hover table-sm">
       <tr v-for="item in history">
         <td @click="open(item.path, 'folder')"><i class="icono-folder"></i></td>
         <td><i class="icono-video"></i></td>
         <td @click="play(item.filename)">${ item.filename }<br>
           <small>${ item.latest_date } | ${ secondToTime(item.position) } / ${ secondToTime(item.duration) }</small>
         </td>
         <td><i class="icono-trash"></i></td>
       </tr>
     </table>
     </div>
     <div class="table-responsive-sm">
     <table v-show="!history_show" class="table-striped table-condensed table table-hover table-sm">
       <tr v-for="item in filelist">
         <td><i :class="icon[item.type]"></i></td>
         <td @click="open(item.path, item.type)">${ item.filename }<br><small>${ item.size }</small>
         </td>
         <td><i class="icono-trash"></i></td>
       </tr>
     </table>
     </div>
             <!-- td[0] = '<td><i class="glyphicon glyphicon-' + icon[n["type"]] + '"></i></td>'; -->
        <!-- td[1] = '<td class="filelist ' + n["type"] + '" title="' + n["path"] + '">' + n["filename"] + size + "</td>"; -->
        <!-- td[2] = '<td class="move" title="' + n["path"] + '">' + '<i class="glyphicon glyphicon-remove-circle"></i></td>'; -->

        
        <!-- td[0] = '<td class="folder" title="' + n["path"] + '">' + '<i class="glyphicon glyphicon-folder-close"></i></td>'; -->
        <!-- td[1] = '<td><i class="glyphicon glyphicon-film"></i></td>'; -->
        <!-- td[2] = '<td class="filelist ' + mediaType + '" title="' + n["filename"] + '">' + n["filename"] + "<br><small>" + n["latest_date"] + " | " + secondToTime(n["position"]) + "/" + secondToTime(n["duration"]) + "</small></td>"; -->
        <!-- td[3] = '<td class="remove" title="' + n["filename"] + '">' + '<i class="glyphicon glyphicon-remove-circle"></i>' + "</td>"; -->
        <!-- //td[4] = '<td class="next" title="' + n["filename"] + '"><i class="glyphicon glyphicon-step-forward"></i></td>'; -->
          <!-- <table v-show="!history_show" class="table-striped table-responsive table-condensed table table-hover table-responsive-xl table-sm"> -->
        <!-- <tbody id="list"> -->
        <!-- </tbody> -->
      <!-- </table> -->
  </b-modal>

<div id="dialog" class="col-xs-12 col-sm-8 col-md-8 col-lg-7">

  <!-- <div id="panel" class="card"> -->
    <!-- <div class="bg-info card-header"> -->
      <!-- <button type="button" class="close">&times;</button> -->
      <!-- <ul id="navtab" class="nav nav-tabs"> -->
        <!-- <li class="active" title="Show play history"> -->
          <!-- <a href="#tabFrame" data-toggle="tab" onclick="history('/hist/ls')"> -->
            <!-- <i class="icono-document"></i>History -->
          <!-- </a> -->
        <!-- </li> -->
        <!-- <li title="Browse video folder"> -->
          <!-- <a href="#tabFrame" data-toggle="tab" onclick="filelist('/fs/ls/')"> -->
            <!-- <i class="icono-home"></i>Home dir -->
          <!-- </a> -->
        <!-- </li> -->
      <!-- </ul> -->
    <!-- </div> -->
    <!-- <div id="tabFrame" class="card-body tab-pane fade in"> -->
      <!-- <table class="table-striped table-responsive table-condensed table table-hover table-responsive-xl table-sm"> -->
        <!-- <tbody id="list"> -->
        <!-- </tbody> -->
      <!-- </table> -->
    <!-- </div> -->
    <!-- <div class="card-footer"> -->
      <!-- <button id="clear" type="button" class="btn btn-default">Clear History</button> -->
    <!-- </div><!-- .panel-footer -->
  <!-- </div><!-- #panel -->
</div><!-- #dialog -->
</div>