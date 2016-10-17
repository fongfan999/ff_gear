$ ->
  lastScrollTop = 0
  $(window).scroll ->
    currentScrollTop = $(this).scrollTop()

    if currentScrollTop > lastScrollTop
      # Down
      $('.nav-scroll').hide()
      $('nav').removeClass('z-depth-0').addClass('z-depth-1')
    else
      # Up
      $('.nav-scroll').show()
      $('nav').removeClass('z-depth-1').addClass('z-depth-0')
      $('.main-nav').removeClass('z-depth-0').addClass('z-depth-1')

    lastScrollTop = currentScrollTop