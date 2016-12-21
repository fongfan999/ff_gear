$ ->
  # Allow user to scroll down while page is scrolling top automatically
  $("html, body").on "scroll mousedown wheel DOMMouseScroll mousewheel keyup 
    touchmove", ->
    $(this).stop()

  # Show/hide go to top helper
  $(window).scroll ->
    if $(this).scrollTop() > 500
      $('.go-to-top').show()
    else
      $('.go-to-top').fadeOut("slow")

  # Autocomplete suggestions
  inputSearch = $("#search-input")

  inputSearch.focus ->
    $('nav .input-field label.active i').css('color', '#444')
  
  inputSearch.blur ->
    $('nav .input-field label.active i').css('color', '#e9e9e9')

  # Highlight function
  highlight = (text, value) ->
    rgxp = new RegExp(value, 'gi')
    repl = '<span class="highlight">' + value + '</span>'

    text.replace(rgxp, repl).toLowerCase()

  $("#search-input").materialize_autocomplete
    dropdown: {
      el: '#search-dropdown',
      itemTemplate: '<li class="ac-item" data-id="<%= item.id %>" data-text="<%= item.text %>"><a href="/<%= item.href %>/<%= item.id %>"><img src="<%= item.img %>"><%= item.htmlStr %></a></li>',
      noItem: '<li class="ac-item"><a>Nhấn Enter để tìm kiếm</a></li>'
    },
    getData: (value, callback) -> 
      $.getJSON("/search.json?q=" + value)
        .done (data) ->
          userSearch = value.match(/\A@/)

          if userSearch
            for i, item of data
              item.htmlStr = item.text
              item.text = '@' + item.text
              item.href = 'users'
          else
            # Highlight
            for i, item of data
              item.htmlStr = highlight(item.text, value.toLowerCase())
              item.href = 'posts'
  
          callback(value, data)

  # Autocomplete for mobile only
  $("#search-input-m").materialize_autocomplete
    dropdown: {
      el: '#search-dropdown-m',
      itemTemplate: '<li class="ac-item" data-id="<%= item.id %>" data-text="<%= item.text %>"><a href="/<%= item.href %>/<%= item.id %>"><img src="<%= item.img %>"><%= item.htmlStr %></a></li>',
      noItem: '<li class="ac-item"><a>Nhấn Enter để tìm kiếm</a></li>'
    },
    getData: (value, callback) -> 
      $.getJSON("/search.json?q=" + value)
        .done (data) ->
          userSearch = value.match(/\A@/)

          if userSearch
            for i, item of data
              item.htmlStr = item.text
              item.text = '@' + item.text
              item.href = 'users'
          else
            # Highlight
            for i, item of data
              item.htmlStr = highlight(item.text, value.toLowerCase())
              item.href = 'posts'
  
          callback(value, data)

  # Search when enter is pressed
  $("#search-input, #search-input-m").keydown (e) ->
    if e.which == 13
      $(this).closest("form").submit()
    
  # Accept number only
  $(".number").bind "keydown change", (e) ->
    # Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) != -1 ) 
      # let it happen, don't do anything
      return

    # Ensure that it is a number and stop the keypress
    if (e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && 
      (e.keyCode < 96 || e.keyCode > 105)
        e.preventDefault()

  # separate large number by whitespace
  $('.number').bind "keyup change", ->
    this.value = this.value.replace(/ /g,"")
    this.value = this.value.replace(/\B(?=(\d{3})+(?!\d))/g, " ")

  # Submit form on change
  $('.field-change').change ->
    $(".hide-on-change").hide()
    $("#preloader-nav" ).css('margin-top', '100px').show()
    formChange = $(this).closest("form")
    formChange.css("opacity", 0.5)
    formChange.click (e) ->
      e.preventDefault()
    formChange.submit()

  # Number to currency as text helper
  $('#post_price').bind "keyup change", ->
    $('#read-currency').text( DOCSO.doc($(this).val()) + " đồng" )
    
  # With Ajax only
  $( document ).ajaxComplete ->
    # Tooltip on ajax
    $('.tooltipped').tooltip({delay: 20});

    # Render preloader on market page
    progressPreloader = 
      '<div class="progress"><div class="indeterminate"></div></div>'
    $('#posts-infinite-scrolling > .view-more-btn').click ->
      $('#posts-infinite-scrolling').html(progressPreloader)

    # Fix lable on input
    $("input textarea").focus()

    # Enable form Validation with ajax
    formValidation = $('form[data-validate="true"]')

    if formValidation.length
      formValidation.enableClientSideValidations()

    # Element validate completely
    # Disable submit button when Form is not validated
    validationBtn = formValidation.find('.validation-btn')
    if validationBtn.length
      validationBtn.attr('disabled', true)
      formValidation.focusout ->
        failureForm = $('.input-field.has-error')

        if failureForm.length
          validationBtn.attr('disabled', true)
        else
          validationBtn.attr('disabled', false)
      

    
    