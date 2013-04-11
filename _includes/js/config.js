window.MyGovBar={
  Models: {},
  Collections: {},
  Views: {},
  Router: {},
  Templates: {},
  config:{
    url: '{{ site.url }}',
    api_url: '{{ site.api_url }}',
    version: '{{ site.version }}',
    tabs: [{% for tab in site.tabs %}'{{tab}}'{%if forloop.rindex0 > 0 %},{%endif%}{%endfor%}],
    search_affiliate: '{{ site.search_affiliate }}',
    animation_speed: {{ site.animation_speed }},
    width_minimized: {{ site.width_minimized }},
    parent_url: ''
  }
};
