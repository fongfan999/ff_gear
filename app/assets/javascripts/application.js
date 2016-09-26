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
//= require_tree .

$(function() {
  // Set waves-effect on all <a> and <button> tags and 
  $('a, button').addClass("waves-effect waves-light");

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

  $("a.new").prepend('<i class="material-icons"></>');

  // Dropzone.options.attachmentsDropzone = {
  //   autoProcessQueue: false,
  //   uploadMultiple: true,
  //   parallelUploads: 20,
  //   maxFiles: 20,
  //   acceptedFiles: "image/jpg,image/jpeg,image/png,image/gif",
  //   addRemoveLinks: true,
  //   autoDiscover: false

  //   // The setting up of the dropzone
  //   init: function() {
  //     var myDropzone = this;

  //     // First change the button to actually tell Dropzone to process the queue.
  //     this.element.querySelector("button[type=submit]").addEventListener("click", function(e) {
  //       // Make sure that the form isn't actually being sent.
  //       e.preventDefault();
  //       e.stopPropagation();
  //       myDropzone.processQueue();
  //     });

  //     // Listen to the sendingmultiple event. In this case, it's the sendingmultiple event instead
  //     // of the sending event because uploadMultiple is set to true.
  //     this.on("sendingmultiple", function() {
  //       // Gets triggered when the form is actually being sent.
  //       // Hide the success button or the complete form.
  //     });
  //     this.on("successmultiple", function(files, response) {
  //       // Gets triggered when the files have successfully been sent.
  //       // Redirect user or notify of success.
  //     });
  //     this.on("errormultiple", function(files, response) {
  //       // Gets triggered when there was an error sending the files.
  //       // Maybe show form again, and notify user of error
  //     });
  //   }
  // };

  Dropzone.autoDiscover = false;

  var headlineDropzone = new Dropzone("#attachments-dropzone", {
    url: "/attachments",
    paramName: "file",
    parallelUploads: 2,
    maxFilesize: 20,
    acceptedFiles: "image/*",
    autoDiscover: false,
    // addRemoveLinks: true,
    init: function() {
      this.on("success", function(file, object) {

        // Create the remove button
        var removeButton = Dropzone.
          createElement('<a class="remove_thumb"><i class="material-icons">clear</i></a>');


        // Capture the Dropzone instance as closure.
        var _this = this;

        // Listen to the click event
        removeButton.addEventListener("click", function(e) {
          // Make sure the button click doesn't submit the form:
          e.preventDefault();
          e.stopPropagation();

          // Remove the file preview.
          _this.removeFile(file);
          // If you want to the delete the file on the server as well,
          // you can do the AJAX request here.
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
        file.previewElement.appendChild(removeButton);
      });
    }
  });



  // // headlineDropzone.removeFile(headlineDropzone.files);

  headlineDropzone.on("success", function(file, responseText) {
    // var imageUrl;
    // imageUrl = responseText.file_name.url;
    // console.log(file);
    // console.log(responseText);
    // console.log(headlineDropzone);
    // console.log("remove successfully");
  });
});
