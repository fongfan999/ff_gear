$ ->
  shadowNav = (nav, status = false)  ->
    if status == false
      # remove shadow
      $(nav).removeClass('z-depth-2').addClass('z-depth-0')
    else
      # add shadow
      $(nav).removeClass('z-depth-0').addClass('z-depth-2')

  lastScrollTop = 0
  $(window).scroll ->
    currentScrollTop = $(this).scrollTop()

    if currentScrollTop > lastScrollTop
      # Down
      $('.nav-scroll').hide()

      # 2 navs
      shadowNav('.fo-nav', true)
    else
      # Up
      $('.nav-scroll').show()

      # 1 nav
      shadowNav('nav', true)
      # 2 navs
      shadowNav('.fo-nav', false)

      if currentScrollTop == 0
        shadowNav('nav', false)

    lastScrollTop = currentScrollTop