//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min
//= require jquery.scrollTo/jquery.scrollTo.min

if $('#show-room').size() > 0
  svg = $('svg')
  width = svg.width() - 150
  height = svg.height()

  snap = Snap "#show-room"

  zero = 'translate(0, 0)'
  scale = { initial: '0.01', final: 2.5 }

  config = {
    hrot: {
      id: 'hrot',
      initial: [(width/2+70) - 85, -76],
      final: [(width/2-70) - 85, 80],
      speed: 900
    }
    kundaBook: {
      id: 'kunda-book',
      initial: [(width+90), height],
      final: [(width/2+70), 440],
      speed: 800
    }
    veganSans: {
      id: 'vegan-sans',
      initial: [0, height],
      final: [(width/2-370), 440],
      speed: 700
    }
  }

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

    $.scrollTo('svg', 'max')

  moveButton = (item, index) ->
    index = 0 if index > 3

    elementToMove = buttons.selectAll('g#'+item.id+' > g')[index]
    elementToMove.animate { transform: 'translate('+item.final+') scale('+scale.final+')' }, item.speed, mina.bounce

    restart = ->
      title.attr { opacity: 0 }
      title.unmouseover
      title.unmouseoout
      returnButtons elementToMove, item, ->
        restartDelay += 300
        moveButton item, ++index

    timeout = setTimeout restart, restartDelay

    title = buttons.select 'g#'+item.id+'-title'
    title.attr { opacity: 0, transform: 'translate('+item.final+') scale('+scale.final+')'  }

    title.mouseover ->
      title.animate { opacity: 1 }, 150, mina.linear
      clearTimeout(timeout)

    title.mouseout ->
      title.stop()
      title.attr { opacity: 0, transform: 'translate('+item.final+') scale('+scale.final+')' }
      timeout = setTimeout restart, 1000

  returnButtons = (element, item, callback) ->
    delayedCallback = ->
      setTimeout callback, 1500 - item.speed

    element.animate { transform: 'translate('+item.initial+') scale('+scale.initial+')' }, item.speed/2, mina.easeout, delayedCallback

showFontList = ->
  $('.tools .minus').on 'click', ->
    family  = $(this).parent().siblings('h3')
    styles = $(this).parent().siblings('.styles').children('h4')
    familySize = (parseInt(family.css('font-size'))*0.875)+'px'
    family.css({ 'font-size': familySize })
    stylesSize = (parseInt(styles.first().css('font-size'))*0.875)+'px'
    styles.css({ 'font-size': stylesSize })
  $('.tools .plus').on 'click', ->
    family  = $(this).parent().siblings('h3')
    styles = $(this).parent().siblings('.styles').children('h4')
    familySize = (parseInt(family.css('font-size'))*1.125)+'px'
    family.css({ 'font-size': familySize })
    stylesSize = (parseInt(styles.first().css('font-size'))*1.125)+'px'
    styles.css({ 'font-size': stylesSize })
  $('.tools .list').on 'click', ->
    styles = $(this).parent().siblings('.styles')
    styles.addClass('visible')
    $.scrollTo(styles, 'max')
  $('.fonts').css { opacity: 1 }

showFontList()

$('header.main').on 'mouseenter', ->
  $('header.main nav').addClass('visible')

$('header.main').on 'mouseout', ->
  hideMenu = ->
    $('heade.main nav').removeClass('visible')
  setTimeout hideMenu, 2000

$('.fonts input.tester').on 'change', ->
  $(this).parent('h3').siblings('.styles').children('h4').html($(this).val())

if $('address').size() > 0
  $(window).scroll ->
    scrolled = $(window).scrollTop()
    console.log scrolled
    if scrolled > 20 && scrolled < 380
      $('address').css({ transform: 'translate(0, '+(-(200-scrolled))+'px)' })
