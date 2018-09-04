{% extends base.html %}
{% block title %}{{src}} - Light Media Player{% end %}
    {% block main %}
      <video src="/video/{{src}}" poster controls preload="meta">No video support!</video>
    {% end %}
    {% block footer %}{% end %}
{% block script %}
<script>

$("video").on("error", function () {
    out("error");
}).on("loadeddata", function () {  //auto load position
    this.currentTime = Math.max({{position}} - 0.5, 0);
    text = "<small>Play from</small><br>";
}).on("seeking", function () {  //show position when changed
    out(text + secondToTime(this.currentTime) + '/' + secondToTime(this.duration));
    text = "";
}).on("timeupdate", function () {  //auto save play position
    lastplaytime = new Date().getTime();  //to detect if video is playing
    if (this.readyState == 4 && Math.floor(Math.random() * 99) > 80) {  //randomly save play position
        $.ajax({
            url: "/wp/save/{{src}}",
            data: {
                position: this.currentTime,
                duration: this.duration
            },
            timeout: 999,
            type: "POST",
            error: function (xhr) {
                out("save: " + xhr.statusText);
            }
        });
    }
}).on("progress", function () { //show buffered
    var str = "";
    if (new Date().getTime() - lastplaytime > 1000) {
        for (i = 0, t = this.buffered.length; i < t; i++) {
            if (this.currentTime >= this.buffered.start(i) && this.currentTime <= this.buffered.end(i)) {
                str = secondToTime(this.buffered.start(i)) + "-" + secondToTime(this.buffered.end(i)) + "<br>";
                break;
            }
        }
        out(str + "<small>buffering...</small>");
    }
});
</script>
<script src="{{ static_url('js/player.js') }}"></script>
{% end %}