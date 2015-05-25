//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min
//= require jquery.scrollTo/jquery.scrollTo.min

if $('#show-room')
  svg = $('svg')
  width = svg.width() - 150
  height = svg.height()

  snap = Snap "#show-room"

  zero = 'translate(0, 0)'
  scale = { initial: '0.01', final: 2.5 }

  config = {
    hrot: {
      id: 'hrot',
      initial: [(width/2-70) - 75, -76],
      final: [(width/2-70) - 85, 80],
      title: [(width/2-70) - 103, 44],
      speed: 900
    }
    kundaBook: {
      id: 'kunda-book',
      initial: [(width+90), height],
      final: [(width/2+70), 440],
      title: [(width/2+53), 404],
      speed: 800
    }
    veganSans: {
      id: 'vegan-sans',
      initial: [0, height],
      final: [(width/2-370), 440],
      title: [(width/2-398), 404],
      speed: 700
    }
  }

  buttons = null
  Snap.load '/assets/images/buttons.svg', (canvas) ->
    buttons = canvas.select 'g#Buttons'
    snap.append buttons

    $.each config, (name, item) ->
      group = buttons.select 'g#'+item.id
      group.attr { transform: zero }
      group.selectAll('g').attr { transform: 'translate('+item.initial+') scale('+scale.initial+')' }
      moveButton group, item, 0

    setTimeout showFontList, 1000
    enableMenu()
    # window.scrollTo($('20px'))

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

    elementToMove.click ->
      Snap.load '/assets/images/vegan-sans-show-room.svg', (canvas) ->
        snap.clear()

        show = canvas.select 'g#VeganSans'
        snap.append show

        slide = show.selectAll('g#canvas > g#slide-1').attr(transform: 'translate(-'+width+', 0)')
        show.selectAll('g#canvas > g#slide-2').attr(transform: 'translate(80, '+height+')')

        hideSlide = ->
          show.select('g#canvas > g#slide-1').animate { transform: 'translate(80, -'+height+')' }, 750, mina.easein
          show.select('g#canvas > g#slide-2').animate { transform: 'translate(80, 120)' }, 750, mina.easein, ->
            setTimeout(
              ->
                show.selectAll('g#slide-2 path')[1].animate { transform: 'translate(80, '+height+')' }, 350
              , 300)

        showSlide = ->
          slide.animate { transform: 'translate(80 0)' }, 1000, mina.easeout

        setTimeout showSlide, 50
        setTimeout hideSlide, 2950




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
