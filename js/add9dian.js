// ==UserScript==
// @include http://www.douban.com/*
// by vvoody ;-)
// ==/UserScript==

function add9dian() {
    navbar = document.getElementById("nav");
    jiudian = document.createElement("a");
    jiudian.href = "http://9.douban.com/";
    jiudian.text = "9";
    navbar.appendChild(jiudian);
}

window.addEventListener('load', add9dian, false);
