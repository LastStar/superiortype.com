//= require jquery/dist/jquery.min
//= require velocity/velocity.min
//= require awesomplete/awesomplete.min

on_screen = ->
  $('.offscreen').addClass('onscreen').removeClass('offscreen')
  $('.contracted').addClass('expanded').each (i, el) ->
    $(el).addClass('bouncing')


off_screen = ->
  $('.onscreen').addClass('offscreen').removeClass('onscreen').removeClass('initial')


jQuery ->
  if $('section.show-room').size() > 0
    $('section.show-room span.initial').each (i, el) ->
      $(el).mouseenter (e) ->
        $(this).removeClass('initial')
        if $('section.show-room span.initial').size() == 0
          on_screen()

    $('#reset').click (e) ->
      $('section.show-room span').each((i, el) ->
        $(el).addClass('initial'))
      off_screen()

    $('#play').click (e) ->
      $('section.show-room span').each((i, el) ->
        $(el).removeClass('initial'))
      on_screen()


  if $('form#search').size() > 0
    $(this).on('submit', (e) ->
      font = $('input:first').val()
      window.location.href = "/fonts/" + font.toLowerCase().split(' ').join('-')
      return false
    )

