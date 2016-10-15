$ ->
  lastScrollTop = 0
  $(window).scroll ->
    currentScrollTop = $(this).scrollTop()

    if currentScrollTop > lastScrollTop
      # Down
      $('.navbar-fixed').first().hide()
    else
      # Up
      $('.navbar-fixed').first().show()

    lastScrollTop = currentScrollTop