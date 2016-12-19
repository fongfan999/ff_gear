$ ->
  navWrapper =  $('#lander #nav-wrapper')
  brandLogo =  $('#lander .nav-wrapper .brand-logo')
  imageBrandLogo = $('#lander .nav-wrapper .brand-logo img')
  loginWrapper = $('#lander #login-wrapper')
  materializeNavWrapper = $('#lander .nav-wrapper')
  loginBtn = $('#lander .login-btn')

  defaultScollTopProperties = ->
    navWrapper.css
      'background-color': 'transparent'
      'height': '150px'
    brandLogo.css 
      'font-size': '3.5em'
      'top': '-20px'
    imageBrandLogo.css
      'width': '56px'
      'height': '56px'
      'margin-top': '0'
    materializeNavWrapper.css 'margin-top': '0px'

  defaultScollBottomProperties = ->
    navWrapper.css 'background-color': '#e74c3c'
    brandLogo.css
      'font-size': '31px'
      'top': '0'
    imageBrandLogo.css
      'width': '32px'
      'height': '32px'
    materializeNavWrapper.css 'margin-top': '-40px'

  onLargeScrollTopProperties = ->
    defaultScollTopProperties()
    # Right login button
    loginBtn.css
      'padding-left': '30px'
      'padding-right': '30px'
      'font-size': '1.3em'

  onLargeScrollBottomProperties = ->
    navWrapper.css 'height': '64px'
    defaultScollBottomProperties()
    # Right login button
    loginBtn.css
      'padding-left': '15px'
      'padding-right': '15px'
      'font-size': '1em'
      'margin-top': '-3px'

  offLargeScrollTopProperties = ->
    defaultScollTopProperties()
    # Block login button
    loginWrapper.css 'margin-top': '60px'

  offLargeScrollBottomProperties = ->
    navWrapper.css 'height': '125px'
    defaultScollBottomProperties()
    # Block login button
    loginWrapper.css 'margin-top': '50px'

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

  initializeScrollNav = ->
    applyProperties()
    $(window).scroll ->
      applyProperties()

  landerSlider = $('#lander .slider')
  landerSlider.slider
    full_width: true
    height: 450
  $('#lander .caption').hover (->
    landerSlider.slider 'pause'
  ), ->
    landerSlider.slider 'start'
  # End Slider

  # Scroll Spy
  $('.scrollspy').scrollSpy scrollOffset: 64
  tabsFixed = $('#lander #tabs-fixed')
  tabsFixed.css 'top', ($(window).height() - tabsFixed.height()) / 2
  # End Scroll Spy

  # Scroll Fire
  options = [
    {
      selector: '#ft-list-1'
      offset: 100
      callback: (el) ->
        Materialize.showStaggeredList $(el)
    }
    {
      selector: '#ft-list-2'
      offset: 250
      callback: (el) ->
        Materialize.showStaggeredList $(el)
    }
  ]

  Materialize.scrollFire options
  initializeScrollNav()
  $(window).resize initializeScrollNav