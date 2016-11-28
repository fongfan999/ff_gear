$ ->
  $('.nav-tabs .tab').click ->
    # Hide infinite preloader if present
    $('#posts-infinite-scrolling').hide()

    # Scroll to top
    page = $("html, body")
    page.animate {
      scrollTop: 0
      abc: 5
    }, 'slow'

    # Allow user to scroll down while page is scrolling top automatically
    page.on "scroll mousedown wheel DOMMouseScroll mousewheel keyup 
    touchmove", ->
      page.stop()

    $("#posts").html("")
    $("#preloader-nav" ).show()

  $('#sort').change ->
    $(this).closest("form").submit()
