//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min
//= require jquery.scrollTo/jquery.scrollTo.min

if $('#show-room').size() > 0
  svg = $('svg')
  maxWidth = svg.width()
  width = svg.width() - 150
  height = svg.height()

  snap = Snap "#show-room"

  zero = 'translate(0, 0)'
  scale = { initial: 0.01, final: 1.9 }

  config = {
    hrot: {
      id: 'hrot',
      initial: [(width/2) - 5, -76],
      final: [(width/2) - 145, 80],
      speed: 900
    }
    kundaBook: {
      id: 'kunda-book'
      initial: [(width+90), height]
      final: [(width/2+70), 440]
      speed: 800
      showRoom: '/assets/images/kunda-book-show-room.svg'
      preSlide: (show) ->
        show.selectAll('g#slide-1 > g').attr(transform: 'translate(-'+width+', 0)')
        show.select('g#slide-2').attr(opacity: 0)
        show.select('g#background rect').attr { width: maxWidth, height: height, opacity: 0 }

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
      final: [(width/2-370), 440],
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
    console.log $(window).scrollTop()

  moveButton = (item, index) ->
    index = 0 if index > 3

    elementToMove = buttons.selectAll('g#'+item.id+' > g')[index]
    # title = buttons.select 'g#'+item.id+'-title'

    elementToMove.animate { transform: 'translate('+item.final+') scale('+scale.final+')' }, item.speed, mina.bounce
    # title.attr { opacity: 0, transform: 'translate(0, 0) scale(0)'  }

    restart = ->
      # title.attr { opacity: 0, transform: 'translate(0, 0) scale(0)'  }
      # title.unmouseover
      # title.unmouseoout
      ++index
      restartDelay += 300
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

  $(window).on 'scroll', ->
    scrolled = $(window).scrollTop()
    if scrolled > 60 and scrolled < height
      $(window).stop(true).scrollTo('.fonts', { duration: 600 })
      $(window).off 'scroll'

if $('section.fonts').size() > 0
  family = (el) ->
    el.parent().parent().siblings('h3')
  styles = (el) ->
    el.parent().siblings('.styles').children('h4')
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
    stylesGr($(this)).addClass('visible')
    $.scrollTo(stylesGr($(this)), 'max')
  $('.fonts').css { opacity: 1 }

if $('section.fonts#styles').size() > 0
  styles = (el) ->
    el.parent().parent().siblings('h4').children('input')

  $('.apperance .minus').on 'click', ->
    stylesSize = (parseInt(styles($(this)).first().css('font-size'))*0.875)+'px'
    styles($(this)).css({ 'font-size': stylesSize })
  $('.apperance .plus').on 'click', ->
    stylesSize = (parseInt(styles($(this)).first().css('font-size'))*1.125)+'px'
    styles($(this)).css({ 'font-size': stylesSize })

  $(window).on 'scroll', ->
    if $(window).scrollTop() > 32
      $('.font-header').addClass('fixed')
    else
      $('.font-header').removeClass('fixed')


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

