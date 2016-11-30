$ ->
  # Trigger tabs on clicking
  $('.nav-tabs .tab').click ->
    # Hide infinite preloader if present
    $('#posts-infinite-scrolling').hide()

    # Scroll to top
    $("html, body").animate {
      scrollTop: 0
      abc: 5
    }, 'slow'

    $("#posts").html("")
    $("#preloader-nav").show()

  # Sorting
  $('#sort').change ->
    $("#posts").html("")
    $("#preloader-nav" ).show()
    $(this).closest("form").submit()
