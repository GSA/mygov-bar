MyGovBar.url = '{{ site.url }}'
MyGovBar.api_url = '{{ site.api_url }}'
new MyGovBar.Views.Index { model: new MyGovBar.Models.Page, el: $("#bar") }