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
//= require materialize/extras/nouislider
//= require jquery.flexslider
//= require jquery-zoom
//= require dropzone
//= require materialize-form
//= require malihu-custom-scrollbar-plugin
//= require rails.validations
//= require rails.validations.simple_form
//= require sweetalert2
//= require materialize-autocomplete
//= require docso
//= require Chart
//= require_tree .

enableValidations = function() {
  var formValidation, validationBtn;

  formValidation = $('form[data-validate="true"]');

  if (formValidation.length) {
    formValidation.enableClientSideValidations();
  }

  // Element validate completely
  // Disable submit button when Form is not validated
  validationBtn = formValidation.find('.validation-btn');

  if (validationBtn.length) {
    validationBtn.attr('disabled', true);
    formValidation.focusout(function() {
      var failureForm;
      failureForm = $('.input-field.has-error');
      if (failureForm.length) {
        return validationBtn.attr('disabled', true);
      } else {
        return validationBtn.attr('disabled', false);
      }
    });
  }
}

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

  // Chart js configuration
  Chart.defaults.global.defaultFontColor = "#96a2b4";

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
  $(".button-collapse").sideNav({
    draggable: true
  });

  // Auto resize textarea rows
  $('textarea').trigger('autoresize');

  // Hide dismiss button
  $(".dismiss").on("click", function() {
    $(this).parent().fadeOut("slow");
  });

  // Zoom in image on hover
  $('.zoom-in').zoom({
    magnify: 1.5,
  });

  // // Enable material box
  $('.materialboxed').materialbox();

  // Clear input
  $('i.clear-input').on('click', function() {
    $(this).parent().find('input').val('');
    $('#search-dropdown').hide();
  });

  // Set delay tooltip time
  $('.tooltipped').tooltip({delay: 20});

  // Make dialog boxes working with tabs
  $('.modal-trigger').leanModal({
    ready: function() {
      $('ul.tabs').tabs();
      enableValidations();
    }
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
        if (!$('#preview-wrapper .dz-error').length) {
          $('.dz-message').show();
        }
      }
    };

    var shouldEnableSubmitBtn = function() {
      if ($('#preview-wrapper .dz-success').length > 0) {
        submitBtn.attr('disabled', false);
        $('.dz-message').hide();
      }
    };

    var updateAttachmentIds = function(attachment_id) {
      var rejected_ids;
      // Get value as string from input
      rejected_ids = $('#rejected_ids').val() || '[]';
      // Parse string to array
      rejected_ids = $.parseJSON(rejected_ids);
      // Push id to array
      rejected_ids.push(parseInt(attachment_id));
      // Set value as string back to input
      $('#rejected_ids').val(JSON.stringify(rejected_ids));
    };

    var handleRemoveThumb = function(object, e, attachmentId) {
      // Make sure page doesn't submit
      e.preventDefault();
      e.stopPropagation();

      // Increase maxFiles by 1
      headlineDropzone.options.maxFiles += 1;
      
      // Find dz-preview block
      var block = $(object).parent().parent();
     
      block.remove();
      attachmentId = attachmentId || block.attr('id');
      updateAttachmentIds(attachmentId);

      shouldDisableSubmitBtn();
    };

    Dropzone.autoDiscover = false;
    // Dropzone.options.attachmentsDropzone = false;

    var headlineDropzone = new Dropzone("#attachments-dropzone", {
      url: "/attachments",
      paramName: "file",
      clickable: ['#preview-wrapper'],
      parallelUploads: 1,
      maxFilesize: 2,
      maxFiles: 5 - $('#preview-wrapper .dz-success').length,
      dictDefaultMessage: "Nhấn vào đây hoặc Kéo và thả để đăng ảnh",
      acceptedFiles: "image/jpeg,image/png,image/jpg",
      dictInvalidFileType: "Loại ảnh không phù hợp",
      dictFileTooBig: "Kích thước ảnh quá lớn. Kích thước tối đa là {{maxFilesize}}",
      dictMaxFilesExceeded: "Số lượng ảnh tối đa là 5",
      init: function() {
        $(this.element).addClass("dropzone");
        var dzMessage = "<div class='dz-message'>Nhấn vào đây hoặc Kéo và thả để đăng ảnh</div>"

        $(dzMessage).prependTo('#preview-wrapper');

        if ($('#preview-wrapper .dz-preview').length) {
          $('.dz-message').hide();
        }
        shouldDisableSubmitBtn();

        this.on("addedfile", function(file) {
          // Append new elenment to wrapper
          $(file.previewElement).appendTo('#preview-wrapper');
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
          $(removeButton).on("click", function(e) {
            handleRemoveThumb(this, e, object.id);
          });
        });

        this.on("error", function(file, object) {
          $(file.previewElement).appendTo('#preview-wrapper')
        });
      }
    });

    $(".remove_thumb.persisted").on("click", function(e) {
      handleRemoveThumb(this, e);
    });
  }

   
});


$(window).on('load', function() {
  // Animate loader off screen
  $(".se-pre-con").fadeOut("slow");

  // Apply custom scrollbar to notifications box
  $('#notice-content').mCustomScrollbar({
    theme: "light-thin",
    autoHideScrollbar: true
  });

  // Enable flexslider
  $('.flexslider').flexslider({
    animation: "slide",
    slideshow: false,
    prevText: '',
    nextText: '',
  });

  // Enable form Validation
  enableValidations();
  
});
