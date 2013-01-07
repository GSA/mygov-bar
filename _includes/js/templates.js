this["JST"] = this["JST"] || {};

this["JST"]["feedback"] = function(obj){
var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};
with(obj||{}){
__p+='<div class="rating">\n\n  <h3>Was this page helpful?</h3>\n  <div id="stars" class="group">\n    <input name="rating" type="radio" class="star" value="1"/>\n    <input name="rating" type="radio" class="star" value="2"/>\n    <input name="rating" type="radio" class="star" value="3"/>\n    <input name="rating" type="radio" class="star" value="4"/>\n    <input name="rating" type="radio" class="star" value="5"/>\n  </div>\n\n</div>\n \n<div class="comments">\n\n    <div class="feeback" id="comment_submitted">\n       Thanks for the feedback! We\'ve got your comment.\n    </div>\n\n<form id="feedback">\n\n    <h3>Give us your thoughts</h3>\n    <textarea id="comment" name="comment" style="width: 100%;"></textarea>\n    <input type="submit" class="btn" value="Send" />\n\n</form>\n\n</div>\n';
}
return __p;
};

this["JST"]["notifications"] = function(obj){
var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};
with(obj||{}){
__p+='';
}
return __p;
};

this["JST"]["related"] = function(obj){
var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};
with(obj||{}){
__p+='<ul class="content-links"> \n  ';
 _.each(related, function(page) { 
;__p+='\n    <li id="related-'+
( page.id )+
'"><a class="title" href="'+
( page.url )+
'" target="_blank">'+
( page.title )+
'\n    <span class="domain">'+
( page.domain.hostname.replace("www.","") )+
'</span></a>\n    </li>\n  ';
 }) 
;__p+='\n</ul>';
}
return __p;
};

this["JST"]["search"] = function(obj){
var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};
with(obj||{}){
__p+='<form id="search" method="get" action="http://search.usa.gov/search?affiliate='+
( MyGovBar.config.search_affiliate )+
'&" target="_blank" >\n  <label for"search_query">Search</label> <input type="search" name="query" placeholder="Search the Federal Government" id="search_query" x-webkit-speech />\n  <input type="submit" value="search" class="btn search" />\n</form>';
}
return __p;
};

this["JST"]["search_result"] = function(obj){
var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};
with(obj||{}){
__p+='<h3>Results for <em>'+
( query )+
'</em> <a href="http://search.usa.gov/search?affiliate='+
( MyGovBar.config.search_affiliate )+
'&query='+
( query )+
'" class="more-results" target="_blank">More results</a></h3>\n\n<ul class="content-links search">\n';
 results.forEach( function(result) { 
;__p+='\n  <li class="result">\n    <a class="title" href="'+
( result.unescapedUrl )+
'">'+
( result.title )+
'\n    <span class="excerpt">'+
( result.content )+
'</span></a>\n  </li>\n';
 }) 
;__p+='\n</ul>\n';
}
return __p;
};

this["JST"]["tags"] = function(obj){
var __p='';var print=function(){__p+=Array.prototype.join.call(arguments, '')};
with(obj||{}){
__p+='<div class="tags">\n\n<h3>Tag this page</h3>\n<p class="info">(Help make this page more findable for all)</p>\n<ul>\n  ';
 _.each( tags, function(tag) { 
;__p+='\n    <li class="tag" id="tag-'+
( tag.id )+
'">'+
( tag.name )+
'</li>\n  ';
 }) 
;__p+='\n  <li>\n</ul>\n<form id="tag_form">\n  <textarea id="tag_list" placeholder="Tag this page..." row="1"></textarea>\n</form>\n\n</div>';
}
return __p;
};