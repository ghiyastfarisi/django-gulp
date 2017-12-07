"use strict";

jQuery(function ($) {
  $("#content")
    .mouseover(function () {
      $("#content").css("color", "red");
    })
    .mouseout(function () {
      $("#content").css("color", "black");
    });
});