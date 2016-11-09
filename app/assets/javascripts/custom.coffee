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
    $(presentSubmit).attr('disabled', true)

    $('.present-field').bind 'keyup change', ->
      minLength = parseInt($(this).attr('min')) || 1
      maxLength = parseInt($(this).attr('max')) || 99999

      currentLength = $(this).val().length

      if currentLength < minLength || currentLength > maxLength
        $(presentSubmit).attr('disabled', true)
      else
        $(presentSubmit).attr('disabled', false)

  # Without Ajax
  validatePresence()

  # With Ajax
  $( document ).ajaxComplete ->
    validatePresence()
    
    