$ ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      morePostsUrl = $('.pagination .next_page').attr('href')
      scrollBottom = $(document).height() - $(window).height() - $(window).scrollTop()
      
      if morePostsUrl && scrollBottom - 300 < 0
        $('#infinite-scrolling').html('<img src="/assets/ring.gif"/>')
        $.getScript morePostsUrl

      $('.view-more-btn').on "click", ->
        $('#infinite-scrolling').html('<img src="/assets/ring.gif"/>')