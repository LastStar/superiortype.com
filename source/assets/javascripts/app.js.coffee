//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min

if $('#show-room')
  svg = $('svg')
  width = svg.width() - 150
  height = svg.height()

  s = Snap "#show-room"

  veganSans = null
  kundaBook = null
  hrot = null
  zero = 'translate(0, 0)'
  scale = 2.5

  config = {
    veganSans: {
      name: 'vegan-sans',
      initial: 't0, '+height+'s0.01',
      final: 't'+(width/2-220)+' 500 s'+scale,
      speed: 700
    }
    kundaBook: {
      name: 'kunda-book',
      initial: 't'+(width+160)+', '+height+'s0.01',
      final: 't'+(width/2+220)+' 500 s'+scale,
      speed: 800
    }
    hrot: {
      name: 'hrot',
      initial: 't'+(width/2)+', -76'+'s0.01',
      final: 't'+(width/2)+' 150 s'+scale,
      speed: 900
    }
  }

  Snap.load '/assets/images/buttons.svg', (canvas) ->
    buttons = canvas.select 'g#Buttons'
    s.append buttons

    veganSans = buttons.select 'g#'+config.veganSans.name
    veganSans.attr { transform: zero }
    veganSans.selectAll('g').attr { transform: config.veganSans.initial }

    kundaBook = buttons.select 'g#'+config.kundaBook.name
    kundaBook.attr { transform: zero }
    kundaBook.selectAll('g').attr { transform: config.kundaBook.initial }

    hrot = buttons.select 'g#'+config.hrot.name
    hrot.attr { transform: zero }
    hrot.selectAll('g').attr { transform: config.hrot.initial }

    setTimeout moveButtons, 350
    setTimeout showFontList, 1000
    enableMenu()


  moveButtons = (index = 0) ->
    if index > 3
      index = 0

    veganSans.selectAll('g')[index].animate { transform: config.veganSans.final}, config.veganSans.speed, mina.bounce
    kundaBook.selectAll('g')[index].animate { transform: config.kundaBook.final}, config.kundaBook.speed, mina.bounce
    hrot.selectAll('g')[index].animate { transform: config.hrot.final}, config.hrot.speed, mina.bounce

    restart = ->
      returnButtons index, ->
        moveButtons ++index

    setTimeout restart, 4000

  returnButtons = (index, callback) ->
    delayedCallback = ->
      setTimeout callback, 750
    veganSans.selectAll('g')[index].animate { transform: config.veganSans.initial}, config.veganSans.speed/2, mina.easeout, delayedCallback
    kundaBook.selectAll('g')[index].animate { transform: config.kundaBook.initial}, config.kundaBook.speed/2, mina.easeout
    hrot.selectAll('g')[index].animate { transform: config.hrot.initial}, config.hrot.speed/2, mina.easeout

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

