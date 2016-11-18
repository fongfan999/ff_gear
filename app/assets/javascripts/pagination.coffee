$ ->
  if $('#posts-infinite-scrolling').length > 0
    $(window).on 'scroll', ->
      morePostsUrl = $('.pagination .next_page a').attr('href')
      scrollBottom = $(document).height() - $(window).height() - $(window).scrollTop()
      
      progressPreloader = 
        '<div class="progress"><div class="indeterminate"></div></div>';

      if morePostsUrl && scrollBottom - 300 < 0
        $('#posts-infinite-scrolling').html(progressPreloader)
        $.getScript morePostsUrl

      $('.view-more-btn').on "click", ->
        $('#posts-infinite-scrolling').html(progressPreloader)