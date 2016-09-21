// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require materialize-sprockets
//= require jquery.flexslider-min
//= require jquery.loupe.min
//= require_tree .

$(function() {
  // Set waves-effect on all <a> and <button> tags and 
  $('a, button').addClass("waves-effect waves-light");

  // Fix Textarea
  $('textarea').addClass("materialize-textarea");

  // Make collapsible navbar
  $(".button-collapse").sideNav();

  // Hide dismiss button
  $(".dismiss").on("click", function() {
    $(this).parent().fadeOut("slow");
  });

  $('#carousel').flexslider({
    animation: "slide",
    controlNav: false,
    animationLoop: false,
    slideshow: false,
    itemWidth: 210,
    itemMargin: 5,
    asNavFor: '#slider'
  });
 
  $('#slider').flexslider({
    animation: "slide",
    controlNav: false,
    animationLoop: false,
    slideshow: false,
    sync: "#carousel"
  });

  $('.zoom-in').loupe();

  $("a.new, a.edit, a.delete").prepend('<i class="material-icons"></>');
});
