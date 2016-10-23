$ ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      scrollBottom = $(document).height() - $(window).height() - $(window).scrollTop()
      
      if more_posts_url && scrollBottom - 200 < 0
        $('#infinite-scrolling').html('<img src="/assets/ring.gif"/>')
        $.getScript more_posts_url

      $('.view-more-btn').on "click", ->
        $('#infinite-scrolling').html('<img src="/assets/ring.gif"/>')