//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min
//= require jquery.scrollTo/jquery.scrollTo.min
//= require jQuery-Storage-API/jquery.storageapi.min.js
//= require jquery-waypoints/lib/jquery.waypoints.min.js
//= require jquery-waypoints/lib/shortcuts/inview.js

likedSpan = $('#liked span')
likedClose = $('.close')
likedBox = $('.liked-box')

emailIsValid = (email) ->
  pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i)
  pattern.test(email)

clearMessage = ->
  $('.message').html('')

hideLikedBox = ->
  likedClose.off 'click'
  likedBox.hide('slow')
  $('main').removeClass('faded')
  $('body').removeClass('faded')
  $('header.main').removeClass('faded')
  likedSpan.show()
  likedSpan.on 'click', showLikedBox
  clearMessage()

showLikedBox = ->
  likedSpan.hide().off 'click'
  likedBox.show('fast')
  $('main').addClass('faded')
  $('body').addClass('faded')
  $('header.main').addClass('faded')
  likedClose.on 'click', hideLikedBox
  $('.contact-form').on 'submit', (e) ->
    email = $(this).children("input[type='email']").val()
    if email != '' and emailIsValid(email)
      e.stopPropagation()
      $('.message').html('<h2>Thank you! Check your email soon.</h2>')
      setTimeout hideLikedBox, 2500
    else
      $('.message').html('<h2>Please provide email in valid format!</h2>')
      setTimeout clearMessage, 2500
    false

refreshLiked = (liked) ->
  size = liked.length
  if size > 0
    content = 'Liked '
    if size == 1
      content += '1 item'
    else
      content += "#{size} items"
    likedSpan.html content
    likedSpan.removeClass 'empty'
    likedSpan.on 'click', showLikedBox

    hideHelp = ->
      $('.faq').hide()
      $('.items').show()
      $('.contact-form').show()
      $(this).html('What\'s this')
      $(this).on 'click', showHelp

    showHelp = ->
      $('.items').hide()
      $('.faq').show()
      $('.contact-form').hide()
      $(this).html('Got it!')
      $(this).on 'click', hideHelp

    $('a.help').on 'click', showHelp
  else
    likedSpan.html ''
    likedSpan.addClass 'empty'
    $('.like').show()

currentLiked = ->
  $.localStorage.get 'liked'

inLiked = (name) ->
  if $.inArray(name, currentLiked()) == -1
    false
  else
    true

addToLiked = (name) ->
  tempLiked = currentLiked()
  tempLiked.push(name)
  tempLiked = $.unique tempLiked
  $.localStorage.set 'liked', tempLiked

removeFromLiked = (name) ->
  tempLiked = currentLiked()
  tempLiked.splice($.inArray(name, currentLiked()), 1)
  $.localStorage.set 'liked', tempLiked

renderLiked = ->
  items = []
  $.each currentLiked(), (index, item) ->
    items.push $("<li><div class='name'>#{item}</div><a class='remover' data-name='#{item}'>Remove</a></li>")
  $('ul.items').html items
  $('.remover').on 'click', ->
    name = $(this).data 'name'
    removeFromLiked name
    $(this).parent('li').fadeOut()
    $(".like[data-name='#{name}']").removeClass('pushed')
    if currentLiked().length > 0
      refreshLiked(currentLiked())
      renderLiked()
    else
      refreshLiked(currentLiked())
      hideLikedBox()

if $.localStorage.get('liked') == null
  $.localStorage.set 'liked', []
else
  $.each $('.like'), (index, button) ->
    if inLiked($(button).data('name'))
      $(button).addClass('pushed')
  refreshLiked currentLiked()

showSlideShow = ->
  return false if $('#show-room').size() == 0
  svg = $('svg')
  height = $(window).height() - 53
  width = svg.width()
  svg.css({ height: height })

  snap = Snap "#show-room"
  snap.clear()

  zero = 'translate(0, 0)'
  scale = { initial: 0.0001, final: $(window).height()/550 }
  halfCircle = 110*scale.final

  config = {
    hrot: {
      id: 'hrot',
      initial: [(width/2) - 5, 0],
      final: [(width/2) - halfCircle, height/7],
      speed: 900
    }
    kundaBook: {
      id: 'kunda-book'
      initial: [(width+90), height]
      final: [(width/2), height/2]
      speed: 800
      showRoom: '/assets/images/kunda-book-show-room.svg'
      preSlide: (show) ->
        show.selectAll('g#slide-1 > g').attr(transform: 'translate(-'+width+', 0)')
        show.select('g#slide-2').attr(opacity: 0)
        show.select('g#background rect').attr { width: width, height: height, opacity: 0 }

      showSlide: (show) ->
        slides = show.selectAll('g#canvas > g#slide-1 > g').attr(transform: 'translate(-'+width+', 0)')
        $.each(slides, (index, slide) ->
          slide.animate { transform: 'translate(80, '+(index*250-80)+')' }, 150+index*250
        )

      changeSlide: (show) ->
        $.each(show.selectAll('g#slide-1 > g'), (index, slide) ->
          slide.animate { transform: 'translate(80, -80)' }, index*250, mina.easeout, ->
            setTimeout(
              ->
                slide.animate { transform: 'translate('+(index*850-80)+', -80)' }, 150+index*250
              , 550)

        )
        show.select('g#slide-2').animate { opacity: 1, transform: 'translate(100, 439) scale(1.05)' }, 3000, mina.bounce
        show.select('g#background rect').animate { opacity: 1 }, 8000, mina.bounce
    }
    veganSans: {
      id: 'vegan-sans',
      initial: [0, height],
      final: [(width/2) - 2*halfCircle, height/2],
      speed: 700
      showRoom: '/assets/images/vegan-sans-show-room.svg'
      color: '#ff0'
      preSlide: (show) ->
        show.select('g#slide-1').attr(transform: 'translate(-'+width/2+', 0)')
        show.select('g#slide-2').attr(transform: 'translate(80, '+height+')')

      showSlide: (show) ->
        show.select('g#slide-1').animate { transform: 'translate(80, 10)' }, 1000, mina.bounce

      changeSlide: (show) ->
        show.select('g#slide-1').animate { transform: 'translate(80, -'+height+')' }, 750, mina.easein
        show.select('g#slide-2').animate { transform: 'translate(80, 120)' }, 750, mina.easein, ->
          setTimeout(
            ->
              show.selectAll('g#slide-2 path')[1].animate { transform: 'translate(80, '+height+')' }, 350
              show.selectAll('g#slide-2 path')[0].animate { transform: 'scale(2)', fill: '#ff0' }, 350
            , 750)
    }
  }
  console.log config

  restartDelay = 3000

  buttons = null

  Snap.load '/assets/images/buttons.svg', (canvas) ->
    buttons = canvas.select 'g#Buttons'
    snap.append buttons

    $.each config, (name, item) ->
      group = buttons.select 'g#'+item.id
      group.attr { transform: zero }
      buttons.selectAll('g#'+item.id+' > g').attr { transform: 'translate('+item.initial+') scale('+scale.initial+')' }
      moveButton item, 0

  moveButton = (item, index) ->
    index = 0 if index > 11

    elementToMove = buttons.selectAll('g#'+item.id+' > g')[index]

    elementToMove.animate { transform: 'translate('+item.final+') scale('+scale.final+')' }, item.speed, mina.bounce

    restart = ->
      ++index
      restartDelay += 100
      returnButtons elementToMove, item, ->
        moveButton item, index

    timeout = setTimeout restart, restartDelay

    elementToMove.click ->
      Snap.load '/assets/images/'+item.id+'-show-room.svg', (canvas) ->
        show = canvas.select 'g#'+item.id

        item.preSlide(show)

        buttons.selectAll('g#canvas > g').animate { opacity: 0 }, 150, mina.easeout, ->
          snap.clear()
          snap.append show

          changeSlide = ->
            item.changeSlide(show)
            show.click ->
              document.location = '/fonts/'+item.id

          item.showSlide(show)
          setTimeout changeSlide, 4000

  returnButtons = (element, item, callback) ->
    element.animate { transform: 'translate('+item.initial+') scale('+scale.initial+')' }, item.speed/2, mina.easeout, ->
      setTimeout callback, 1500 - item.speed

if $('#show-room').size() > 0
  showSlideShow()

$(window).resize ->
  showSlideShow()


if $('section.fonts').size() > 0
  family = (el) ->
    el.parent().parent().siblings('h3')
  styles = (el) ->
    el.parent().parent().siblings('.styles').children('h4')
  stylesGr = (el) ->
    el.parent().parent().siblings('.styles')

  $('.apperance .minus').on 'click', ->
    familySize = (parseInt(family($(this)).css('font-size'))*0.875)+'px'
    family($(this)).css({ 'font-size': familySize })
    stylesSize = (parseInt(styles($(this)).first().css('font-size'))*0.875)+'px'
    styles($(this)).css({ 'font-size': stylesSize })
  $('.apperance .plus').on 'click', ->
    familySize = (parseInt(family($(this)).css('font-size'))*1.125)+'px'
    family($(this)).css({ 'font-size': familySize })
    stylesSize = (parseInt(styles($(this)).first().css('font-size'))*1.125)+'px'
    styles($(this)).css({ 'font-size': stylesSize })
  $('.apperance .list').on 'click', ->
    if stylesGr($(this)).hasClass('visible')
      $(this).removeClass('open')
      curStylesGr = stylesGr($(this))
      curStylesGr.removeClass('visible')
      hide = ->
        curStylesGr.hide()
      setTimeout hide, 750
    else
      $(this).addClass('open')
      stylesGr($(this)).show 150, ->
        $.scrollTo($(this), 'max')
        $(this).addClass('visible')
  $('.fonts').css { opacity: 1 }

if $('section.fonts#styles').size() > 0
  style = (el) ->
    el.parent().parent().siblings('h4').children('input')

  $('.apperance .minus').on 'click', ->
    styleSize = (parseInt(style($(this)).first().css('font-size'))*0.75)
    $(this).siblings('.size').html(parseInt(styleSize)+'pt')
    style($(this)).css({ 'font-size': styleSize+'px' })

  $('.apperance .plus').on 'click', ->
    styleSize = (parseInt(style($(this)).first().css('font-size'))*1.25)
    $(this).siblings('.size').html(parseInt(styleSize)+'pt')
    style($(this)).css({ 'font-size': styleSize+'px' })

  fixHeader = true
  $(window).on 'scroll', ->
    topBound = $('header.main').height()
    if fixHeader && ($(window).scrollTop() > topBound)
      $('.font-header').addClass('fixed')
      $('.font-header header').addClass('fixed')
      $('#styles').addClass('with-bumper')
      fixHeader = false
    if !fixHeader && ($(window).scrollTop() < topBound)
      $('.font-header').removeClass('fixed')
      $('.font-header header').removeClass('fixed')
      $('#styles').removeClass('with-bumper')
      fixHeader = true


  $('.sections a').on 'click', (e) ->
    offset = parseInt $(this).data('offset')
    console.log offset
    if !isNaN(offset)
      $('.font-header').addClass('fixed')
      $('.font-header header').addClass('fixed')
      $('#styles').addClass('with-bumper')
      fixHeader = false
      $(window).scrollTo $($(this).attr('href')), { duration: 300, offset: -offset }
    else
      $('.font-header').removeClass('fixed')
      $('.font-header header').removeClass('fixed')
      $('#styles').removeClass('with-bumper')
      fixHeader = true
      $(window).scrollTo 0, { duration: 500 }
    $('.sections a.active').removeClass('active')
    $(this).addClass('active')
    e.stopPropagation()
    false

$('header.main .menu *').on 'mouseenter', ->
  $('header.main nav').addClass('visible')
$('header.main').on 'mouseleave', ->
  hideMenu = ->
      $('header.main nav').removeClass('visible')
  setTimeout hideMenu, 500

$('.fonts input.tester').on 'change', ->
  $(this).parent('h3').siblings('.styles').children('h4').html($(this).val())

if $('.like').size() > 0
  $('.like').on 'click', ->
    name = $(this).data('name')
    addToLiked name
    $(this).addClass('pushed')
    renderLiked()
    refreshLiked(currentLiked())

$('.remove-all').on 'click', ->
  $.localStorage.removeAll()
  $('.pushed').removeClass('pushed')
  $.localStorage.set 'liked', []
  $('ul.items').html('')
  refreshLiked(currentLiked())
  hideLikedBox()

if $('#styles .styles').size() > 0
  $('.styles .style input').on 'input', ->
    if $(this).val() == ''
      $(this).parent().siblings('.tools').children('.apperance').children('.name').removeClass('visible')
    else
      $(this).parent().siblings('.tools').children('.apperance').children('.name').addClass('visible')
  $('.like').addClass('pushed')
  $('#styles .styles').show 150, ->
    $('#styles .styles').addClass('visible')
    showLike = ->
      $('.like').removeClass('pushed')
      if $.localStorage.get('liked') == null
        $.localStorage.set 'liked', []
      else
        $.each $('.like'), (index, button) ->
          if !inLiked($(button).data('name'))
            $(button).removeClass('pushed')
        refreshLiked currentLiked()
    setTimeout showLike, 750
  detailsActive = ->
    $('a.active').removeClass 'active'
    $('a.details').addClass 'active'
  glyphsActive = ->
    $('a.active').removeClass 'active'
    $('a.glyphs').addClass 'active'
  stylesActive = ->
    $('a.active').removeClass 'active'
    $('a.styles').addClass 'active'


  details = new Waypoint.Inview {
    element: $('#details')[0],
    enter: (direction) ->
      if direction == 'down'
        detailsActive()
    ,
    exited: (direction) ->
      if direction == 'up'
        glyphsActive()
  }
  glyphs = new Waypoint.Inview {
    element: $('#glyphs')[0],
    exited: (direction) ->
      if direction == 'up'
        stylesActive()
  }
  styles = new Waypoint.Inview {
    element: $('#styles')[0],
    enter: (direction) ->
      stylesActive()
    ,
    exited: (direction) ->
      glyphsActive()

  }


if $('#foundry')
  $('.studio img').on 'mouseenter', ->
    $(this).parent().addClass('hidden')
    $('.nonstop').addClass('visible').on 'mouseleave', ->
      $(this).removeClass('visible')
      $('.studio').removeClass('hidden')
renderLiked()
