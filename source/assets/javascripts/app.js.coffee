//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min
//= require jquery.scrollTo/jquery.scrollTo.min
//= require jQuery-Storage-API/jquery.storageapi.min.js
//= require jquery-waypoints/lib/jquery.waypoints.min.js
//= require jquery-waypoints/lib/shortcuts/inview.min.js

wishedSpan = $('#wished span')
wishedClose = $('.close')
wishedBox = $('.wished-box')
defaultSpeed = 250
isMobile = window.screen.availWidth < 750

emailIsValid = (email) ->
  pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i)
  pattern.test(email)

clearMessage = ->
  $('.message').html('')

hideWishedBox = ->
  wishedClose.off 'click'
  wishedBox.hide 'fast', ->
    wishedSpan.show()
  $('main').removeClass('faded')
  $('body').removeClass('faded')
  $('header.main').removeClass('faded')
  wishedSpan.on 'click', showWishedBox
  clearMessage()

showWishedBox = ->
  wishedSpan.hide().off 'click'
  wishedBox.show 'fast', ->
    $('main').addClass('faded')
    $('body').addClass('faded')
    $('header.main').addClass('faded')
  wishedClose.on 'click', hideWishedBox
  $('.contact-form').on 'submit', (e) ->
    email = $(this).children("input[type='email']").val()
    if email != '' and emailIsValid(email)
      e.stopPropagation()
      $('.message').html('<h2>Thank you! Check your email soon.</h2>')
      setTimeout hideWishedBox, 10*defaultSpeed
    else
      $('.message').html('<h2>Please provide email in valid format!</h2>')
      setTimeout clearMessage, 10*defaultSpeed
    false

refreshWished = (wished) ->
  size = wished.length
  if size > 0
    content = 'Wished '
    if size == 1
      content += '1 item'
    else
      content += "#{size} items"
    wishedSpan.html content
    wishedSpan.removeClass 'empty'
    wishedSpan.on 'click', showWishedBox
    hideHelp = ->
      $('.faq').removeClass('visible')
      $('.items').show()
      $('.contact-form').show()
      $('.remove-all').removeClass('hidden')
      $(this).html('What\'s this')
      $(this).on 'click', showHelp
    showHelp = ->
      $('.items').hide()
      $('.faq').addClass('visible')
      $('.contact-form').hide()
      $('.remove-all').addClass('hidden')
      $(this).html('Got it!')
      $(this).on 'click', hideHelp
    $('.help a').on 'click', showHelp
  else
    wishedSpan.html ''
    wishedSpan.addClass 'empty'
    $('.wish').show()

currentWished = ->
  $.localStorage.get 'wished'

inWished = (name) ->
  if $.inArray(name, currentWished()) == -1
    false
  else
    true

addToWished = (name) ->
  tempWished = currentWished()
  tempWished.push(name)
  tempWished = $.unique tempWished
  $.localStorage.set 'wished', tempWished

removeFromWished = (name) ->
  tempWished = currentWished()
  tempWished.splice($.inArray(name, currentWished()), 1)
  $.localStorage.set 'wished', tempWished

renderWished = ->
  items = []
  $.each currentWished(), (index, item) ->
    items.push $("<li><div class='name'>#{item}</div><div class='remove-wrap'><a class='remover' data-name='#{item}'>Remove</a></div></li>")
  $('ul.items').html items
  $('.remover').on 'click', ->
    name = $(this).data 'name'
    removeFromWished name
    $(this).parent('li').fadeOut()
    $(".wish[data-name='#{name}']").removeClass('pushed')
    if currentWished().length > 0
      refreshWished(currentWished())
      renderWished()
    else
      refreshWished(currentWished())
      hideWishedBox()

if $.localStorage.get('wished') == null || isMobile
  $.localStorage.set 'wished', []
else
  $.each $('.wish'), (index, button) ->
    if inWished($(button).data('name'))
      $(button).addClass('pushed')
  refreshWished currentWished()

showSlideShow = ->
  return false if $('#show-room').size() == 0
  svg = $('#show-room')
  width = svg.width()
  snap = Snap "#show-room"
  snap.clear()
  moveToPosition = (element, position, scale) ->
    transform = "translate(#{position}) scale(#{scale})"
    element.attr { transform: transform }
  if isMobile
    config = {
      hrot: {
        id: 'hrot'
        name: 'Hrot'
      }
      kundaBook: {
        id: 'kunda-book'
        name: 'Kunda Book'
      }
      veganSans: {
        id: 'vegan-sans'
        name: 'Vegan Sans'
      }
    }
    scale = width/200
    height = (250 * 3 + 16) * scale
    svg.css({ height: height })
    Snap.load '/assets/images/mobile-buttons.svg', (canvas) ->
      buttons = canvas.select 'g#Buttons'
      top = 16 * scale
      left = parseInt svg.css('padding-left')
      $.each config, (name, item) ->
        button = buttons.select "g##{item.id}"
        snap.append button
        moveToPosition button, [left, top], scale
        $(button.node).one 'click', ->
          document.location = '/fonts/'+item.id

        top += 250 * scale
  else
    height = $(window).height() - $('header.main').height()
    svg.css({ height: height })
    zero = 'translate(0, 0)'
    scale = { initial: 0.0001, final: height/525, title: height/210 }
    halfCircle = 99*scale.final
    halfBigCircle = 99*scale.title
    titlePosition = [width/2 - halfBigCircle, 0]
    config = {
      hrot: {
        id: 'hrot'
        name: 'Hrot'
        initial: [(width/2) - 5, 0]
        final: [(width/2) - halfCircle, height/7 - height/21]
        speed: 800
      }
      kundaBook: {
        id: 'kunda-book'
        name: 'Kunda Book'
        initial: [(width+90), height]
        final: [(width/2) + 20, height/2 - height/21]
        speed: 800
      }
      veganSans: {
        id: 'vegan-sans'
        name: 'Vegan Sans'
        initial: [0, height]
        final: [(width/2) - 2*halfCircle - 20, height/2 - height/21]
        speed: 800
      }
    }
    restartDelay = 3000
    buttons = null
    nowMoving = { 'hrot': {}, 'kunda-book': {}, 'vegan-sans': {} }
    Snap.load '/assets/images/buttons.svg', (canvas) ->
      buttons = canvas.select 'g#Buttons'
      snap.append buttons
      $.each config, (name, item) ->
        group = buttons.select 'g#'+item.id
        moveToPosition group, zero, ''
        moveToPosition buttons.selectAll('g#'+item.id+' > g'), item.initial, scale.initial
        moveToPosition buttons.select('g#'+item.id+'-title'), item.initial, scale.initial
        moveButton item, 0
      scroller = snap.circle $('header.main').css('padding-left'), height - 46, 13
      scroller.attr { fill: '#b3b3b3', cursor: 'pointer' }
      $(scroller.node).on 'click', ->
        $.scrollTo '.fonts', { duration: defaultSpeed }
        scroller.attr { opacity: 0 }
      $(scroller.node).on 'mouseenter', ->
        scroller.attr { fill: '#000' }
      $(scroller.node).on 'mouseleave', ->
        scroller.attr { fill: '#b3b3b3' }
      $(window).on 'scroll', ->
        topBound = $('header.main').height()
        if $(window).scrollTop() > topBound
          scroller.attr { opacity: 0 }
        if $(window).scrollTop() < topBound
          scroller.attr { opacity: 1 }
    moveButton = (item, index) ->
      index = 0 if index > 11
      elementToMove = buttons.selectAll('g#'+item.id+' > g')[index]
      title = buttons.select('g#'+item.id+'-title')
      nowMoving[item.id]['element'] = elementToMove
      nowMoving[item.id]['index'] = index
      restart = ->
        ++index
        restartDelay += 100
        $(elementToMove.node).off 'mouseenter'
        returnButtons elementToMove, item, ->
          moveButton item, index
      elementToMove.animate { transform: 'translate('+item.final+') scale('+scale.final+')' }, item.speed, mina.bounce, ->
        nowMoving[item.id]['timeout'] = setTimeout restart, restartDelay
        $(elementToMove.node).one 'mouseenter', ->
          $.each config, (name, currItem) ->
            clearTimeout nowMoving[currItem.id]['timeout']
            el = nowMoving[currItem.id]['element']
            el.stop()
            moveToPosition el, currItem.initial, scale.initial
          finishMovement = ->
            $.each config, (name, currItem) ->
              el = nowMoving[currItem.id]['element']
              moveToPosition el, currItem.final, scale.final
              cont = ->
                returnButtons el, currItem, ->
                  moveButton currItem, nowMoving[currItem.id]['index']
              nowMoving[currItem.id]['timeout'] = setTimeout cont, currItem.speed
          moveToPosition title, titlePosition, scale.title
          if !inWished(item.name)
            wish = title.select('#wish')
            wish.attr { opacity: 1 }
            wish.attr { cursor: 'pointer' }
            $(wish.node).one 'click', ->
              addToWished(item.name)
              refreshWished(currentWished())
              renderWished()
              wish.attr { opacity: 0 }
          name = title.select('#name')
          name.attr { cursor: 'pointer' }
          $(name.node).one 'click', ->
            document.location = '/fonts/'+item.id
          $(title.node).one 'mouseleave', ->
            moveToPosition title, item.initial, scale.initial
            finishMovement()
      returnButtons = (element, item, callback) ->
        element.animate { transform: 'translate('+item.initial+') scale('+scale.initial+')' }, item.speed/2, mina.ease, ->
          setTimeout callback, 6*defaultSpeed - item.speed

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
      setTimeout hide, 3*defaultSpeed
    else
      $(this).addClass('open')
      stylesGr($(this)).show defaultSpeed, ->
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
  $('.sections a.scroll').on 'click', (e) ->
    offset = parseInt $(this).data('offset')
    console.log offset
    if !isNaN(offset)
      if $(window).width() > 2000
        offset += 30
      $('.font-header').addClass('fixed')
      $('.font-header header').addClass('fixed')
      $('#styles').addClass('with-bumper')
      fixHeader = false
      $(window).scrollTo $($(this).attr('href')), { duration: defaultSpeed, offset: -offset }
    else
      $('.font-header').removeClass('fixed')
      $('.font-header header').removeClass('fixed')
      $('#styles').removeClass('with-bumper')
      fixHeader = true
      $(window).scrollTo 0, { duration: 2*defaultSpeed }
    $('.sections a.active').removeClass('active')
    $(this).addClass('active')
    e.stopPropagation()
    false

if isMobile
  menuOpened = false
  $('header.main .menu .open-menu').on 'click', ->
    if menuOpened
      $('header.main nav').removeClass('visible')
      $('header.main').removeClass('opened')
      menuOpened = false
    else
      $('header.main nav').addClass('visible')
      $('header.main').addClass('opened')
      menuOpened = true
else
  $('header.main .menu *').on 'mouseenter', ->
    $('header.main nav').addClass('visible')
  $('header.main').on 'mouseleave', ->
    hideMenu = ->
        $('header.main nav').removeClass('visible')
    setTimeout hideMenu, 2*defaultSpeed

$('.fonts input.tester').on 'change', ->
  $(this).parent('h3').siblings('.styles').children('h4').html($(this).val())

if $('.wish').size() > 0
  $('.wish').on 'click', ->
    name = $(this).data('name')
    addToWished name
    $(this).addClass('pushed')
    renderWished()
    refreshWished(currentWished())

$('.remove-all').on 'click', ->
  $.localStorage.removeAll()
  $('.pushed').removeClass('pushed')
  $.localStorage.set 'wished', []
  $('ul.items').html('')
  refreshWished(currentWished())
  hideWishedBox()

if $('#styles .styles').size() > 0
  $('.styles .style input').on 'input', ->
    if $(this).val() == ''
      $(this).parent().siblings('.tools').children('.apperance').children('.name').removeClass('visible')
    else
      $(this).parent().siblings('.tools').children('.apperance').children('.name').addClass('visible')
  $('.wish').addClass('pushed')
  $('#styles .styles').show defaultSpeed, ->
    $('#styles .styles').addClass('visible')
    if $(window).scrollTop() < $('#styles .styles').height()
      stylesActive()
    showWish = ->
      $('.wish').removeClass('pushed')
      if $.localStorage.get('wished') == null
        $.localStorage.set 'wished', []
      else
        $.each $('.wish'), (index, button) ->
          if !inWished($(button).data('name'))
            $(button).removeClass('pushed')
        refreshWished currentWished()
    setTimeout showWish, 3*defaultSpeed
  inuseActive = ->
    $('a.active').removeClass 'active'
    $('a.inuse').addClass 'active'
  detailsActive = ->
    $('a.active').removeClass 'active'
    $('a.details').addClass 'active'
  glyphsActive = ->
    $('a.active').removeClass 'active'
    $('a.glyphs').addClass 'active'
  stylesActive = ->
    $('a.active').removeClass 'active'
    $('a.styles').addClass 'active'
  detailsIn = new Waypoint.Inview {
    element: $('#details')[0],
    enter: (direction) ->
      detailsActive()
    exited: (direction) ->
      if direction == 'up'
        glyphsActive()
      else
        inuseActive()
  }
  glyphsIn = new Waypoint.Inview {
    element: $('#glyphs')[0],
    enter: (direction) ->
      glyphsActive()
    exited: (direction) ->
      if direction == 'up'
        stylesActive()
      else
        detailsActive
  }

inuseCount = $('#inuse figure').size()
if  inuseCount > 0
  $('#inuse figure').on 'click', ->
    el = $(this)
    next = parseInt(el.data('order')) + 1
    next = 0 if next == inuseCount
    nel = $("#inuse figure[data-order='#{next}']")
    el.hide()
    nel.show()
  $('#inuse figure img').on 'mouseenter', ->
    $(this).siblings('figcaption').css({ opacity: 0.8 })
  $('#inuse figure img').on 'mouseleave', ->
    $(this).siblings('figcaption').css({ opacity: 0 })


$('.studio img').on 'mouseenter', ->
  $(this).attr({ src: '/assets/images/non-stop.svg' }).on 'mouseleave', ->
    $(this).attr({ src: '/assets/images/studio.jpg' })
if $('address').length > 0
  address = $('address')
  removed = false
  showAddress = ->
    address.addClass('visible')
  setTimeout showAddress, defaultSpeed
  $(window).on 'scroll', ->
      if !removed && $(window).scrollTop() > ($('address').position().top + $('address').height())
        address.removeClass('visible')
        removed = true
      else if removed && $(window).scrollTop() < ($('address').position().top + $('address').height())
        address.addClass('visible')
        removed = false

if $('select.glyphs').size() > 0
  glyphsSelect = $('select.glyphs')
  glyphsSelect.children('option:first-child').attr('selected', 'selected')
  $('#glyphs img:nth-child(2)').addClass('visible')
  glyphsSelect.on 'change', ->
    $('#glyphs img.visible').removeClass('visible')
    $(this).parent('#glyphs').children('img.'+$(this).val()).addClass('visible')

renderWished()
