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
//= require dropzone
//= require materialize-form
//= require jquery.mCustomScrollbar.concat.min
//= require rails.validations
//= require rails.validations.simple_form
//= require sweetalert2
//= require_tree .


$(function() {
  // Sweet alert configuration
  //Override the default confirm dialog by rails
  $.rails.allowAction = function(link){
    if (link.data("confirm") == undefined){
      return true;
    }
    $.rails.showConfirmationDialog(link);
    return false;
  }

  //User click confirm button
  $.rails.confirmed = function(link){
    link.data("confirm", null);
    link.trigger("click.rails");
  }

  //Display the confirmation dialog
  $.rails.showConfirmationDialog = function(link){
    var message = link.data("confirm");
    swal({
      title: message,
      type: 'warning',
      confirmButtonText: 'Đồng ý',
      cancelButtonText: 'Huỷ bỏ',
      confirmButtonColor: '#26a69a',
      showCancelButton: true,
      reverseButtons: true
    }).then(function(e){
      $.rails.confirmed(link);
    }, function(dismiss) {
      return
    });
  };

  // Animate loader off screen
  $(window).load(function() {
    $(".se-pre-con").fadeOut("slow");
  });

  // Scroll to top of page
  $('.go-to-top').click(function() {
    $("html, body").animate({ scrollTop: 0 }, "slow");
  });

  // Pushpin category nav
  if ($('.nav-pushpin-wrapper').length) {
    $('.nav-pushpin-wrapper').pushpin({
      top: $('.nav-pushpin-wrapper').offset().top
    });
  }

  // Display character counter 
  $('input').characterCounter();
  // Display character counter with ajax
  $(document).ajaxComplete(function() {
    $('input').characterCounter();
  });
 
  // Set waves-effect on all <a> and <button> tags
  $('a, button').not('.non-waves-effect').addClass("waves-effect waves-light");

  // Set material design for textarea
  $('textarea').addClass('materialize-textarea');

  // Make collapsible navbar
  $(".button-collapse").sideNav();

  // Auto resize textarea rows
  $('textarea').trigger('autoresize');

  // Make image parallax
  $('.parallax').parallax();

  // Hide dismiss button
  $(".dismiss").on("click", function() {
    $(this).parent().fadeOut("slow");
  });

  // Clear input
  $('i.clear-input').on('click', function() {
    $(this).parent().find('input').val('');
  });

  // Set delay tooltip time
  $('.tooltipped').tooltip({delay: 20});

  // Make dialog boxes working
  $('.modal-trigger').leanModal({
    ready: function() { $('ul.tabs').tabs(); }
  });

  // Caroulsel config
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

  // Zoom image on hover
  $('.zoom-in').loupe({
    width: 240, // width of magnifier
    height: 240, // height of magnifier
    loupe: 'loupe' // css class for magnifier
  });

  // Persist page for redirecting
  $(".persistent").click(function(event) {
    event.preventDefault();
  });

  // Dropzone configuration
  if ($('#attachments-dropzone').length !== 0) {

    var submitBtn = $('.submit-btn');

    var shouldDisableSubmitBtn = function() {
      if ($('#preview-wrapper .dz-success').length == 0) {
        submitBtn.attr('disabled', true);
        $('.dz-message').show();
      }
    };

    var shouldEnableSubmitBtn = function() {
      if ($('#preview-wrapper .dz-success').length > 0) {
        submitBtn.attr('disabled', false);
        $('.dz-message').hide();
      }
    };

    Dropzone.autoDiscover = false;

    var headlineDropzone = new Dropzone("#attachments-dropzone", {
      url: "/attachments",
      paramName: "file",
      clickable: ['#preview-wrapper'],
      parallelUploads: 1,
      maxFilesize: 2,
      maxFiles: 5 - $('#preview-wrapper .dz-preview').length,
      dictDefaultMessage: "Nhấn vào đây hoặc Kéo và thả để đăng ảnh",
      acceptedFiles: "image/jpeg,image/png,image/jpg",
      dictInvalidFileType: "Loại ảnh không phù hợp",
      dictFileTooBig: "Kích thước ảnh quá lớn. Kích thước tối đa là {{maxFilesize}}",
      dictMaxFilesExceeded: "Số lượng ảnh tối đa là 5",
      init: function() {
        $('.dz-message').prependTo('#preview-wrapper');

        if ($('#preview-wrapper .dz-preview').length) {
          $('.dz-message').hide();
        }
        shouldDisableSubmitBtn();

        this.on("addedfile", function(file) {
          // Append new elenment to wrapper
          $(file.previewElement).appendTo('#preview-wrapper')
        });

        this.on("success", function(file, object) {
          // Should enable submit
          shouldEnableSubmitBtn();
          
          // Capture the Dropzone instance as closure.
          var _this = this;

          // Create the remove button and add to the file
          var removeButton = Dropzone.
            createElement('<i class="material-icons remove_thumb">clear</i>');
          $(file.previewElement).find(".dz-image").append(removeButton);

          // Listen to the click event
          removeButton.addEventListener("click", function(e) {
            // Make sure the button click doesn't submit the form
            e.preventDefault();
            e.stopPropagation();

            // Remove the file preview.
            _this.removeFile(file);
            // Should disable submit
            shouldDisableSubmitBtn();

            // Update hidden field
            // Get value as string from input
            rejected_ids = $("#rejected_ids").val() || "[]";
            // Parse string to array
            rejected_ids = $.parseJSON(rejected_ids);
            // Push id to array
            rejected_ids.push(object.id);
            // Set value as string back to input
            $("#rejected_ids").val(JSON.stringify(rejected_ids)); 
          });
        });

        this.on("error", function(file, object) {
          $(file.previewElement).appendTo('#preview-wrapper')
        });
      }
    });
  }
});
