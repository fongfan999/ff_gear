$ ->
  # Allow user to scroll down while page is scrolling top automatically
  $("html, body").on "scroll mousedown wheel DOMMouseScroll mousewheel keyup 
    touchmove", ->
    $(this).stop()

  # Show/hide go to top helper
  $(window).scroll ->
    if $(this).scrollTop() > 500
      $('.go-to-top').show()
    else
      $('.go-to-top').fadeOut("slow")

  # Autocomplete suggestions
  inputSearch = $("#search-input")

  inputSearch.focus ->
    $('nav .input-field label.active i').css('color', '#444')
  
  inputSearch.blur ->
    $('nav .input-field label.active i').css('color', '#e9e9e9')

  inputSearch.materialize_autocomplete
    limit: 5,
    dropdown: {
      el: '#search-dropdown'
    },
    getData: (value, callback) -> 
      $.getJSON("/posts/autocomplete_post_name.json", {search: value})
        .done (data) ->
          callback(value, data)

  # With Ajax only
  $( document ).ajaxComplete ->
    # Tooltip on ajax
    $('.tooltipped').tooltip({delay: 20});

    # Fix lable on input
    $("input textarea").focus()

    # Enable form Validation
    formValidation = $('form[data-validate="true"]')

    if formValidation.length
      formValidation.enableClientSideValidations()

    # Element validation complete
    # Disable submit button when Form is not validated
    validationBtn = formValidation.find('.validation-btn')
    validationBtn.attr('disabled', true)
    if validationBtn.length
      formValidation.focusout ->
        failureForm = $('.input-field.has-error')

        if failureForm.length
          validationBtn.attr('disabled', true)
        else
          validationBtn.attr('disabled', false)
      

    
    