$ ->
  # Trigger tabs on clicking
  $('.nav-tabs .tab').click ->
    # Hide infinite preloader if present
    $('#posts-infinite-scrolling').hide()

    # Scroll to top
    $("html, body").animate {
      scrollTop: 0
    }, 'slow'

    $("#posts").html("")
    $("#preloader-nav").show()
