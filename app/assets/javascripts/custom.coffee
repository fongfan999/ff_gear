$ ->
  # Show/hide go to top helper
  $(window).scroll ->
    if $(this).scrollTop() > 500
      $('.go-to-top').show()
    else
      $('.go-to-top').fadeOut("slow")

  # Validate input as presence
  validatePresence = ->
    presentSubmit = $('.present-submit')
    presentField = $('.present-field')
    minLength = parseInt(presentField.attr('min')) || 1
    maxLength = parseInt(presentField.attr('max')) || 99999

    presentSubmit.attr('disabled', true)

    presentField.bind 'keyup change', ->
      currentLength = $(this).val().length

      if currentLength < minLength || currentLength > maxLength
        presentSubmit.attr('disabled', true)
      else
        presentSubmit.attr('disabled', false)

  # Without Ajax
  validatePresence()

  # With Ajax
  $( document ).ajaxComplete ->
    formValidation = $('.modal').find('form[data-validate="true"]')

    if formValidation.length
      formValidation.enableClientSideValidations()
    
    # Display character counter
    $('.present-field').characterCounter()

    validatePresence()
    
    