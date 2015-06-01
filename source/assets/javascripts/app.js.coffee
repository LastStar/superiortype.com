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
      initial: [(width/2) - 5, -76],
      final: [(width/2) - 150, 80],
      speed: 900
    }
    kundaBook: {
      id: 'kunda-book',
      initial: [(width+90), height],
      final: [(width/2+70), 440],
      speed: 800
      showRoom: '/assets/images/kunda-book-show-room.svg'
    }
    veganSans: {
      id: 'vegan-sans',
      initial: [0, height],
      final: [(width/2-370), 440],
      speed: 700
      showRoom: '/assets/images/vegan-sans-show-room.svg'
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
    title = buttons.select 'g#'+item.id+'-title'

    elementToMove.animate { transform: 'translate('+item.final+') scale('+scale.final+')' }, item.speed, mina.bounce
    title.attr { opacity: 0, transform: 'translate(0, 0) scale(0)'  }

    restart = ->
      title.attr { opacity: 0, transform: 'translate(0, 0) scale(0)'  }
      title.unmouseover
      title.unmouseoout
      ++index
      restartDelay += 300
      returnButtons elementToMove, item, ->
        moveButton item, index

    timeout = setTimeout restart, restartDelay

    elementToMove.click ->
      Snap.load item.show-room, (canvas) ->
        snap.clear()

        if item.id == 'vegan-sans'
          show = canvas.select 'g#VeganSans'
          snap.append show

          slide = show.selectAll('g#canvas > g#slide-1').attr(transform: 'translate(-'+width+', 0)')
          show.selectAll('g#canvas > g#slide-2').attr(transform: 'translate(80, '+height+')')

          showSlide = ->
            slide.animate { transform: 'translate(80 0)' }, 1000, mina.easeout

          changeSlide = ->
            show.select('g#canvas > g#slide-1').animate { transform: 'translate(80, -'+height+')' }, 750, mina.easein
            show.select('g#canvas > g#slide-2').animate { transform: 'translate(80, 120)' }, 750, mina.easein, ->
              setTimeout(
                ->
                  show.selectAll('g#slide-2 path')[1].animate { transform: 'translate(80, '+height+')' }, 350
                  show.selectAll('g#slide-2 path')[0].animate { transform: 'scale(2)' }, 350
                , 350)

        else if item.id == 'kunda-book'
          show = canvas.select 'g#KundaBook'
          snap.append show
          slides = [show.selectAll('g#canvas > g#MU').attr(transform: 'translate(-'+width+', 0)')]
          slides.push(show.selectAll('g#canvas > g#SE').attr(transform: 'translate(-'+width+', 0)'))
          slides.push(show.selectAll('g#canvas > g#UM').attr(transform: 'translate(-'+width+', 0)'))
          calling = show.select('g#canvas > g#is-calling').attr(opacity: 0)

          showSlide = ->
            $.each(slides, (index, slide) ->
              slide.animate { transform: 'translate(40, '+index*250+')' }, index*250
            )

          changeSlide = ->
            $.each(slides, (index, slide) ->
              slide.animate { transform: 'translate(40, 0)' }, index*250, mina.easeout, ->
                setTimeout(
                  ->
                    slide.animate { transform: 'translate('+index*850+', 0)' }, index*250
                  , 550)

            )
            calling.animate { opacity: 1 }, 3000


        setTimeout showSlide, 50
        setTimeout changeSlide, 2950

    # elementToMove.mouseover ->
    #   clearTimeout(timeout)
    #   title.attr { opacity: 0, transform: 'translate('+item.final+') scale('+scale.final+')'  }
    #   title.animate { opacity: 1 }, 150, mina.linear

    # title.mouseout ->
    #   timeout = setTimeout restart, 1000
    #   title.stop()
    #   title.attr { opacity: 0, transform: 'translate('+item.final+') scale('+scale.final+')' }

  returnButtons = (element, item, callback) ->
    element.animate { transform: 'translate('+item.initial+') scale('+scale.initial+')' }, item.speed/2, mina.easeout, ->
      setTimeout callback, 1500 - item.speed


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
