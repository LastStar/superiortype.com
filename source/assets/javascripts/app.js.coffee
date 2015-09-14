//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min
//= require jquery.scrollTo/jquery.scrollTo.min
//= require jQuery-Storage-API/jquery.storageapi.min.js
//= require jquery-waypoints/lib/jquery.waypoints.min.js
//= require jquery-waypoints/lib/shortcuts/inview.min.js

wishedButton = $('#wished button')
wishedClose = $('.close a')
wishedBox = $('.wished-box')
defaultSpeed = 250
isMobile = window.screen.availWidth < 750
isSafariFirst = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1

emailIsValid = (email) ->
  pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i)
  pattern.test(email)

clearMessage = ->
  $('.message').html('')

hideWishedBox = ->
  wishedBox.one "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", ->
    wishedClose.off 'click'
    $('main').off 'click'
    wishedButton.show()
    $('main').removeClass('faded')
    $('body').removeClass('faded')
    $('header.main').removeClass('faded')
    wishedButton.one 'click', showWishedBox
    clearMessage()
  wishedBox.removeClass('visible')

showWishedBox = ->
  wishedBox.off "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd"
  wishedButton.hide().off 'click'
  $('main').addClass('faded')
  $('body').addClass('faded')
  $('header.main').addClass('faded')
  wishedBox.addClass('visible')
  wishedClose.one 'click', hideWishedBox
  $('main').one 'click', hideWishedBox

refreshWished = (wished) ->
  size = wished.length
  if size > 0
    content = 'Wished '
    if size == 1
      content += '1 item'
    else
      content += "#{size} items"
    wishedButton.html content
    wishedButton.removeClass 'empty'
    wishedButton.on 'click', showWishedBox
  else
    wishedButton.html ''
    wishedButton.addClass 'empty'

currentWished = ->
  $.localStorage.get 'wished'

itemToObject = (name, pkg) ->
  JSON.stringify({ name: name, package: pkg })

inWished = (name, pkg) ->
  item = itemToObject name, pkg
  if $.inArray(item, currentWished()) == -1
    false
  else
    true

addToWished = (name, pkg) ->
  tempWished = currentWished()
  tempWished.push(itemToObject(name, pkg))
  tempWished = $.unique tempWished
  $.localStorage.set 'wished', tempWished
  renderWished

removeFromWished = (name, pkg) ->
  tempWished = currentWished()
  item = itemToObject name, pkg
  tempWished.splice($.inArray(item, currentWished()), 1)
  $.localStorage.set 'wished', tempWished

prototypeLine = $('table.items tbody tr.prototype').remove()
renderWished = ->
  items = []
  price = 0
  $.each currentWished(), (index, item) ->
    item = JSON.parse(item)
    name = item.name
    pkg = item.package
    line = prototypeLine.clone().removeClass('prototype').addClass('item')
    line.children('.name').html name
    if pkg == 'Superior'
      line.find('.package select').remove()
    else
      line.find(".package select option[value='#{pkg}']").attr 'selected', 'selected'
    price = price + 60
    items.push line
  $('table.items tbody tr.item').remove()
  $('table.items tbody').prepend items
  $('table.items tbody .total .price .amount').text "#{price} USD"
  $('.remover').on 'click', ->
    name = $(this).data 'name'
    pkg = $(this).data 'package'
    removeFromWished name, pkg
    $(this).parent('li').fadeOut()
    if currentWished().length > 0
      refreshWished(currentWished())
      renderWished()
    else
      refreshWished(currentWished())
      hideWishedBox()
  $('#wish-list').on 'submit', (e) ->
    $(this).addClass('filled')
    $(this).find('.checkout').hide()
    $(this).find('.remove-all').hide()
    $(this).find('.remove-wrap').hide()
    $(this).find('td select').each (i) ->
      val = $("<span class='val'>#{$(this).find('option:selected').html()}</span>")
      $(this).hide().after val
    $(this).on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", ->
      $('.wished-box').addClass('checking-out')
      title = $('.wished-box header h2')
      title.html(title.data('alternate'))
      $('#checkout').addClass('active')
      $.each $countries, (code, country) ->
        opt = $("<option value='#{code}'>#{country}</option>")
        $('select#countries').append opt
      $('#countries').on 'change', ->
        $('#states').find('option').remove()
        $.each $states[$(this).val()], (code, state) ->
          opt = $("<option value='#{code}'>#{state}</option>")
          $('#states').append opt
      $('.eula input').on 'change', ->
        if $(this).prop('checked')
          $('input.pay').addClass('visible')
        else
          $('input.pay').removeClass('visible')
      wishedClose.html(wishedClose.data('alternate'))
    wishedClose.off('click').one 'click', ->
      wishList = $('#wish-list')
      wishList.off "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd"
      wishList.removeClass('filled')
      wishList.find('.checkout').show()
      wishList.find('.remove-all').show()
      wishList.find('.remove-wrap').show()
      wishList.find('td select').show()
      wishList.find('span.val').remove()
      $('.wished-box').removeClass('checking-out')
      title = $('.wished-box header h2')
      title.html(title.data('normal'))
      $('#checkout').removeClass('active')
      wishedClose.html(wishedClose.data('normal'))
      wishedClose.one 'click', hideWishedBox
    e.preventDefault()


if currentWished() == null || isMobile
  $.localStorage.set 'wished', []
else
  refreshWished currentWished()

showSlideShow = ->
  return false if $('#show-room').size() == 0
  svg = $('#show-room')
  width = svg.width()
  snap = Snap "#show-room"
  snap.clear()
  $('.font .styles').hide()
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
    height = (250 * 3 + 32) * scale
    svg.css({ height: height })
    Snap.load '/assets/images/mobile-buttons.svg', (canvas) ->
      buttons = canvas.select 'g#Buttons'
      top = 32 * scale
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
    if isSafariFirst
      isSafariFirst = false
      console.log 'first dry'
      $(window).resize()
      showSlideShow()
      return
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
          name = title.select('#name')
          name.attr { cursor: 'pointer' }
          $(name.node).one 'click', ->
            document.location = '/fonts/'+item.id
          $(title.node).one 'mouseleave', ->
            moveToPosition title, item.initial, scale.initial
            finishMovement()
      returnButtons = (element, item, callback) ->
        element.animate { transform: 'translate('+item.initial+') scale('+scale.initial+')' }, item.speed/2, mina.easeIn, ->
          setTimeout callback, 6*defaultSpeed - item.speed

if $('#show-room').size() > 0
  showSlideShow()

$(window).resize ->
  setTimeout showSlideShow, 100

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

if $('section.fonts#styles').size() > 0 && !isMobile
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
  makeHeaderFixed = ->
    $('.font-header').addClass('fixed')
    $('.font-header header').addClass('fixed')
    $('#styles').addClass('with-bumper')
    fixHeader = false
  unmakeHeaderFixed = ->
    $('.font-header').removeClass('fixed')
    $('.font-header header').removeClass('fixed')
    $('#styles').removeClass('with-bumper')
    fixHeader = true
  $(window).on 'scroll', ->
    topBound = $('header.main').height()
    if fixHeader && ($(window).scrollTop() > topBound)
      makeHeaderFixed()
    if !fixHeader && ($(window).scrollTop() < 2*topBound)
      unmakeHeaderFixed()
  $('.sections a.scroll').on 'click', (e) ->
    offset = parseInt $(this).data('offset')
    console.log offset
    if !isNaN(offset)
      if $(window).width() > 2000
        offset += 30
      makeHeaderFixed()
      $(window).scrollTo $($(this).attr('href')), { duration: defaultSpeed, offset: -offset }
    else
      unmakeHeaderFixed()
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
  clickableWish = ->
    $('.wish').one 'click', (e) ->
      e.stopPropagation()
      wishButton = $(this)
      wishBox = wishButton.parents('.style').children('.wish-box')
      style = wishButton.parents('.style')
      otherStyles = style.siblings('.style')
      hideWishBox = ->
        wishButton.html(wishButton.data('normal'))
        wishButton.removeClass('pushed')
        hideBox = ->
          $('.wish-box.visible').removeClass('visible')
          style.siblings('.style').removeClass('faded').off 'click'
          otherStyles.find('.wish').show()
        packageBoxes  = $('.wish-box.visible > div')
        packageBoxes.removeClass('visible')
        packageBoxes.last().on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", (e) ->
          $(this).off "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd"
          hideBox()
        wishButton.off 'click'
        clickableWish()
      wishButton.addClass('pushed').one 'click', ->
        hideWishBox()
      otherStyles.find('.wish').hide().off 'click'
      otherStyles.addClass('faded').one 'click', (e) ->
        e.stopPropagation()
        hideWishBox()
        false
      niceShow = ->
        wishButton.html(wishButton.data('alternate'))
        name = wishButton.data('name')
        wishBox.addClass('visible')
        showPackages = ->
          wishBox.children('div').addClass('visible')
        setTimeout showPackages, 100
        $('.wish-box.visible > div').on 'click', ->
          if pkg = $(this).data('package')
            addToWished(name, pkg)
          else
            addToWished 'Superior', 'Superior'
          hideWishBox()
          refreshWished(currentWished())
          renderWished()
      $.scrollTo style, { duration: 90, offset: -$('.font-header').height() - 3, onAfter: niceShow }
  clickableWish()


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
  $('.slide').show defaultSpeed, ->
    deactivate = ->
      $('a.active').removeClass 'active'
    activate = (section) ->
      $("a.#{section}").addClass 'active'
    inuseActive = ->
      deactivate()
      activate 'inuse'
    detailsActive = ->
      deactivate()
      activate 'details'
    glyphsActive = ->
      deactivate()
      activate 'glyphs'
    stylesActive = ->
      deactivate()
      activate 'styles'
    $('.slide').addClass('visible')
    if $(window).scrollTop() < $('#styles .styles').height()
      stylesActive()
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
          detailsActive()
    }

inuseCount = $('#inuse figure').size()
if  inuseCount > 0
  if inuseCount > 1
    $('#inuse figure a').on 'click', ->
      if $(this).hasClass('next')
        progress = 1
      else
        progress = -1
      el = $(this).parents('figure')
      next = parseInt(el.data('order')) + progress
      next = 0 if next == inuseCount
      next = inuseCount - 1 if next < 0
      nel = $("#inuse figure[data-order='#{next}']")
      el.hide()
      nel.show()
  $('#inuse figure *').on 'mouseenter', ->
    fig = $(this).parent('figure')
    fig.children('figcaption').css({ opacity: 1 })
    if inuseCount > 1
      fig.children('nav').css({ opacity: 1 })
  $('#inuse figure *').on 'mouseleave', ->
    fig = $(this).parent('figure')
    fig.children('figcaption').css({ opacity: 0 })
    if inuseCount > 1
      fig.children('nav').css({ opacity: 0 })

if $('.studio img').size() > 0 && !isMobile
  $('.studio img').on 'mouseenter', ->
    $(this).attr({ src: '/assets/images/non-stop.svg' }).on 'mouseleave', ->
      $(this).attr({ src: '/assets/images/studio.jpg' })

if $('address').length > 0 && !isMobile
  removed = true
  address = $('address')
  showAddress = ->
    removed = false
    address.addClass('visible')
  setTimeout showAddress, defaultSpeed
  $(window).on 'scroll', ->
    offset = address.offset()
    if !removed && $(window).scrollTop() > (offset.top + address.height())
      address.removeClass('visible')
      removed = true
    else if removed && $(window).scrollTop() < (offset.top + address.height())
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
