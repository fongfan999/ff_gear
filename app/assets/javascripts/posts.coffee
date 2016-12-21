$ ->
  # Insert icon before input
  iconsList = $('i.prefix')
  i = 0
  while i < iconsList.length
    $(iconsList[i]).parent().prepend iconsList[i]
    i++

  # Toggle display comments
  $('.comments-btn').click (event)->
    event.preventDefault()
 
    if $('.load-comments').length
      $('.load-comments').click()
    else
      $('.thread_span').slideToggle().css('display', 'block')

  anchorComment = window.location.hash
  santitizedAnchorComment = anchorComment.replace(/[^a-z0-9]*/i, '')

  # Open thread box to scroll to anchor
  if santitizedAnchorComment.match(/^comment_\d+_div$/)
      $(".comments-btn").click()

  # Scroll once
  scrolled = false
  # Trigger rendering comments is completed
  $( document ).ajaxComplete (event, xhr, settings) ->
    threadBox = $(".comments_list")

    if threadBox.length && !scrolled 
      scrolled = true

      # Change scrollbar style and scroll to anchor
      threadBox.mCustomScrollbar(
        autoHideScrollbar: true,
        theme: "light-thin"
      )
      
      # Users click on notification box
      if settings.type == "GET"
        # Scroll to threadBox
        $('html, body').animate {
          scrollTop: $('#comments').offset().top - 64
        }, 2000

        threadBox.mCustomScrollbar("scrollTo", anchorComment || "bottom")

  # Update icon favorite
  $('a.favorite').click ->
    iconTag = $('.favorite i')
    if (iconTag.html().trim() == 'favorite')
      iconTag.html('favorite_border').css('color', '#26a69a')
    else
      iconTag.html('favorite').css('color', '#E74C3C')

  # Swal thankyou after rerporting
  $("#report-post-form button[type='submit']").click ->
    $('#report-post-form').closeModal()

    swal {
      title: "Cảm ơn sự phản hồi của bạn",
      text: "Những phản hồi của bạn giúp chúng tôi hoàn thiện hơn",
      type: 'success',
      confirmButtonText: 'Đóng',
      confirmButtonColor: '#26a69a'
    }
