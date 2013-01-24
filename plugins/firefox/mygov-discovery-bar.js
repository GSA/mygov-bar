// ==UserScript==
// @name        MyGov Discovery Bar
// @namespace   MyGov
// @description MyGov Discovery Bar
// @include     http://*.gov/*
// @include     http://*.mil/*
// @include     http://*.fed.us/*
// @include     http://*.si.edu/*
// @version     2
// @grant       none
// ==/UserScript==

// to compile: https://arantius.com/misc/greasemonkey/script-compiler.php
(function(){var e;e=document.createElement("script"),e.src="http://gsa-ocsit.github.com/mygov-bar/mygov-bar.js",document.body.appendChild(e)}).call(this);