$ ->
  update_attachment_ids = (attachment_id) ->
    # Get value as string from input
    rejected_ids = $('#rejected_ids').val() or '[]'
    # Parse string to array
    rejected_ids = $.parseJSON(rejected_ids)
    # Push id to array
    rejected_ids.push parseInt(attachment_id)
    # Set value as string back to input
    $('#rejected_ids').val JSON.stringify(rejected_ids)

  $(".remove_thumb").on "click", (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    block = $(this).parent().parent()
    update_attachment_ids block.attr('id')
    block.fadeOut()
    block.remove()
    if $('#preview-wrapper .dz-preview').length == 0
        $('#submit-btn').attr 'disabled', true


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
  if santitizedAnchorComment.length > 0
    $(".comments-btn").click()

  # Trigger rendering comments is completed
  $( document ).ajaxComplete (event, xhr, settings) ->
    threadBox = $(".comments_list")

    if threadBox.length
      # Change scrollbar style and scroll to anchor
      threadBox.mCustomScrollbar( autoHideScrollbar: true )
      
      # Users click on notification box
      if settings.type == "GET"
        # Scroll to threadBox
        $('html, body').animate {
          scrollTop: $('#comments').offset().top
        }, 2000

        threadBox.mCustomScrollbar("scrollTo", anchorComment || "bottom")

  # Update icon favorite
  $('a.favorite').click ->
    iconTag = $('.favorite i')
    if (iconTag.html().trim() == 'favorite')
      iconTag.html('favorite_border').css('color', '#039be5')
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
