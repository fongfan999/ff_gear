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

    $('.present-field').keyup ->
      if $(this).val() == ''
        $(presentSubmit).attr('disabled', true)
      else
        $(presentSubmit).attr('disabled', false)

  $( document ).ajaxComplete ->
    validatePresence()
    
    