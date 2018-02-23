<script src="/static/js/jquery-3.2.1.min.js"></script>
<script src="/static/js/bootstrap.min.js"></script>
<%
from binascii import crc32
with open('static/js/common.js', 'rb') as f:
    checksum = '%08X' % crc32(f.read())
%>
<!-- <script src="/static/js/common.js?v=2"></script> -->
<script src="/static/js/common.js?v={{checksum}}"></script>

