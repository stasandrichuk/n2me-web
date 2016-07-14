jQuery(document).ready ->
  $('.search-icon').click ->
    $('.search-bar').css('top', '48px')

  $('#page_content_inner, #Carousel, section, .bg-dark').click ->
      $('.search-bar').css('top', '-53px')
