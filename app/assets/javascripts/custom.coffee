$ ->
  # Show/hide go to top helper
  $(window).scroll ->
    if $(this).scrollTop() > 500
      $('.go-to-top').show()
    else
      $('.go-to-top').fadeOut("slow")

  # With Ajax only
  $( document ).ajaxComplete ->
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
      

    
    