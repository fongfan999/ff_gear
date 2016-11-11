$ ->
  if $('#infinite-scrolling').length > 0
    $(window).on 'scroll', ->
      console.log "Hihi"
      morePostsUrl = $('.pagination .next_page a').attr('href')
      scrollBottom = $(document).height() - $(window).height() - $(window).scrollTop()
      
      if morePostsUrl && scrollBottom - 300 < 0
        $('#infinite-scrolling').html('<img src="/assets/preloader.gif"/>')
        $.getScript morePostsUrl

      $('.view-more-btn').on "click", ->
        $('#infinite-scrolling').html('<img src="/assets/preloader.gif"/>')