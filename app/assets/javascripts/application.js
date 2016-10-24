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
//= require jquery.session
//= require dropzone
//= require materialize-form
//= require_tree .

$(function() {
  $(window).load(function() {
    // Animate loader off screen
    $(".se-pre-con").fadeOut("slow");;
  });
  
  // Set waves-effect on all <a> and <button> tags and 
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
  $('.modal-trigger').leanModal();

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

  // Add plus icon to new button
  $("a.new").prepend('<i class="material-icons"></>');

  // Dropzone configuration
  if ($('#attachments-dropzone').length !== 0) {

    var submitBtn = $('#submit-btn');

    Dropzone.autoDiscover = false;

    $('<div class="dz-message">Nhấn vào đây hoặc Kéo và thả để đăng ảnh</div>').appendTo($('#preview-wrapper'));

    var headlineDropzone = new Dropzone("#attachments-dropzone", {
      url: "/attachments",
      paramName: "file",
      parallelUploads: 1,
      maxFilesize: 20,
      maxFiles: 10,
      acceptedFiles: "image/jpeg,image/png,image/jpg",
      dictInvalidFileType: "Loại ảnh không phù hợp",
      dictFileTooBig: "Kích thước ảnh quá lớn. Kích thước tối đa là {{maxFilesize}}",
      dictMaxFilesExceeded: "Số lượng ảnh tối đa là 10",
      init: function() {
        if ($('#preview-wrapper .dz-preview').length == 0) {
          submitBtn.attr('disabled', true);
        }

        this.on("success", function(file, object) {
          if ($('#preview-wrapper .dz-preview').length == 0) {
            submitBtn.attr('disabled', false);
          }
          $('#preview-wrapper').contents().unwrap();
          $(".dz-preview").wrapAll("<div id='preview-wrapper'></div>");

          // Create the remove button
          var removeButton = Dropzone.
            createElement('<i class="material-icons remove_thumb">clear</i>');

          // Capture the Dropzone instance as closure.
          var _this = this;

          // Listen to the click event
          removeButton.addEventListener("click", function(e) {
            // Make sure the button click doesn't submit the form:
            e.preventDefault();
            e.stopPropagation();

            // Remove the file preview.
            _this.removeFile(file);
            if ($('#preview-wrapper').contents().length == 0) {
              $('.dz-message').appendTo($('#preview-wrapper'));
              submitBtn.attr('disabled', true);
            }

            // Get value as string from input
            rejected_ids = $("#rejected_ids").val() || "[]";
            // Parse string to array
            rejected_ids = $.parseJSON(rejected_ids);
            // Push id to array
            rejected_ids.push(object.id);
            // Set value as string back to input
            $("#rejected_ids").val(JSON.stringify(rejected_ids)); 
          });

          // Add the button to the file preview element.
          $(file.previewElement).find('.dz-image')[0].
            appendChild(removeButton);
    
        });

        this.on("error", function(file, object) {
          $('#preview-wrapper').contents().unwrap();
          $(".dz-preview").wrapAll("<div id='preview-wrapper'></div>");
        });
      }
    });
  }
});
