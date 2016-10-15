$ ->
  defaultScollTopProperties = ->
    $('#nav-wrapper').css
      'background-color': 'transparent'
      'height': '150px'
    $('.nav-wrapper .brand-logo').css 'font-size': '3.5em'
    $('.nav-wrapper ').css 'margin-top': '0px'
    return

  defaultScollBottomProperties = ->
    $('#nav-wrapper').css 'background-color': '#ea4a4f'
    $('.nav-wrapper .brand-logo').css 'font-size': '31px'
    $('.nav-wrapper ').css 'margin-top': '-40px'
    return

  onLargeScrollTopProperties = ->
    defaultScollTopProperties()
    # Right login button
    $('.login-btn').css
      'padding-left': '30px'
      'padding-right': '30px'
      'font-size': '1.3em'
    return

  onLargeScrollBottomProperties = ->
    $('#nav-wrapper').css 'height': '64px'
    defaultScollBottomProperties()
    # Right login button
    $('.login-btn').css
      'padding-left': '15px'
      'padding-right': '15px'
      'font-size': '1em'
      'margin-top': '-3px'
    return

  offLargeScrollTopProperties = ->
    defaultScollTopProperties()
    # Block login button
    $('#login-wrapper').css 'margin-top': '60px'
    return

  offLargeScrollBottomProperties = ->
    $('#nav-wrapper').css 'height': '125px'
    defaultScollBottomProperties()
    # Block login button
    $('#login-wrapper').css 'margin-top': '50px'
    return

  applyProperties = ->
    windowWidth = $(window).width()
    scrollPosition = $(this).scrollTop()
    if windowWidth > 992
      if scrollPosition == 0
        onLargeScrollTopProperties()
      else
        onLargeScrollBottomProperties()
    else
      if scrollPosition == 0
        offLargeScrollTopProperties()
      else
        offLargeScrollBottomProperties()
    return

  initializeScrollNav = ->
    applyProperties()
    $(window).scroll ->
      applyProperties()
      return
    return

  $('.slider').slider
    full_width: true
    height: 450
  $('.caption').hover (->
    $('.slider').slider 'pause'
    return
  ), ->
    $('.slider').slider 'start'
    return
  # End Slider

  # Scroll Spy
  $('.scrollspy').scrollSpy scrollOffset: 0
  tabsFixed = $('#tabs-fixed')
  tabsFixed.css 'top', ($(window).height() - tabsFixed.height()) / 2
  # End Scroll Spy

  # Scroll Fire
  options = [
    {
      selector: '#ft-list-1'
      offset: 100
      callback: (el) ->
        Materialize.showStaggeredList $(el)
        return

    }
    {
      selector: '#ft-list-2'
      offset: 250
      callback: (el) ->
        Materialize.showStaggeredList $(el)
        return

    }
  ]

  Materialize.scrollFire options
  initializeScrollNav()
  $(window).resize initializeScrollNav
  console.log "Bybye"
