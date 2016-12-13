$ ->
  if $('#posts-infinite-scrolling').length > 0
    # Initialize view more button
    viewMore = $('.pagination .next_page a')
                .attr('data-remote', true)
                .addClass('view-more-btn btn')
                .html("<i class='material-icons'>sync</i>")
    $("#posts-infinite-scrolling").append(viewMore.clone())

    progressPreloader = 
      '<div class="progress"><div class="indeterminate"></div></div>'
    # Execute on scrolling
    $(window).on 'scroll', ->
      morePostsUrl = $('.pagination .next_page a').attr('href')
      scrollBottom = $(document).height() - $(window).height() - $(window).scrollTop()

      if morePostsUrl && scrollBottom < 200
        $('#posts-infinite-scrolling').html(progressPreloader)
        $.getScript morePostsUrl

    # Render preloader for inital button
    $('#posts-infinite-scrolling > .view-more-btn').click ->
      $('#posts-infinite-scrolling').html(progressPreloader)