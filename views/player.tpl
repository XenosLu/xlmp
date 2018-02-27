{% extends base.tpl %}
{% block title %}{{src}} - Light Media Player{% end %}
    {% block main %}
      <video src="/video/{{src}}" poster controls preload="meta">No video support!</video>
    {% end %}
    {% block footer %}{% end %}
{% block script %}
<script src="{{ static_url('js/player.js') }}"></script>
{% end %}