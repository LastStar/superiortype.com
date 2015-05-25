//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min

if $('#show-room')
  svg = $('svg')
  width = svg.width() - 150
  height = svg.height()

  s = Snap "#show-room"

  zero = 'translate(0, 0)'
  scale = { initial: '0.01', final: '2.5' }

  config = {
    veganSans: {
      id: 'vegan-sans',
      initial: [0, height],
      final: [(width/2-220), 500],
      title: [(width/2-248), 464],
      speed: 700
    }
    kundaBook: {
      id: 'kunda-book',
      initial: [(width+160), height],
      final: [(width/2+220), 500],
      title: [(width/2+192), 464],
      speed: 800
    }
    hrot: {
      id: 'hrot',
      initial: [(width/2), -76],
      final: [(width/2), 150],
      title: [(width/2) - 28, 114],
      speed: 900
    }
  }

  buttons = null
  Snap.load '/assets/images/buttons.svg', (canvas) ->
    buttons = canvas.select 'g#Buttons'
    s.append buttons

    $.each config, (name, item) ->
      group = buttons.select 'g#'+item.id
      group.attr { transform: zero }
      group.selectAll('g').attr { transform: 'translate('+item.initial+') scale('+scale.initial+')' }
      moveButton group, item, 0

    setTimeout showFontList, 1000
    enableMenu()


  moveButton = (group, item, index) ->
    index = 0 if index > 3

    elementToMove = group.selectAll('g')[index]
    elementToMove.animate { transform: 'translate('+item.final+') scale('+scale.final+')' }, item.speed, mina.bounce

    title = buttons.select 'g#'+item.id+'-title'
    title.attr { opacity: 0, transform: 'translate('+item.title+') scale('+scale.final+')' }
    restart = ->
      title.attr { opacity: 0 }
      elementToMove.unmouseover
      elementToMove.unmouseoout
      returnButtons elementToMove, item, ->
        moveButton group, item, ++index

    timeout = setTimeout restart, 8000

    elementToMove.mouseover ->
      title.attr { opacity: 1 }
      title.animate { transform: 'translate('+item.title+') scale('+scale.final+') rotate(720deg)' }, 8000
    elementToMove.mouseout ->
      title.stop()
      title.attr { opacity: 0, transform: 'translate('+item.title+') scale('+scale.final+')' }


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
    $('.fonts').css { opacity: 1 }

  enableMenu = ->
    $('header').on 'mouseenter', ->
      $('header nav').addClass('visible')


    $('header').on 'mouseout', ->
      hideMenu = ->
        $('header nav').removeClass('visible')
      setTimeout hideMenu, 2000

