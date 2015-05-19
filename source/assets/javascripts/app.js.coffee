//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min

fG = ''
if $('#show-room')
  black = '#111'
  body = $('body')
  body.css({ "background-color": black })
  cart = $('#cart')
  cart.hide()
  fontList = $('section.font-list')

  s = Snap "#show-room"

  cTop = 360
  cLeft = 100
  cRadius =  150
  sCircle = s.circle cLeft, cTop, cRadius
  sCircle.attr { fill: "#fff" }
  mCircle = s.circle cLeft, cTop, cRadius
  mCircle.attr { fill: "#fff" }


  sText = s.text 30, 460, "SUPER"
  sText.attr { fill: "#000", "font-size": "18rem", "font-weight": 900 }
  sG = s.g sCircle, sText
  sG.attr { mask: mCircle }

  searchLightRight = ->
    sCircle.animate { cx: 1000 }, 4000, mina.ease, searchLightLeft
    mCircle.animate { cx: 1000 }, 4000, mina.ease

  searchLightLeft = ->
    sCircle.animate { cx: 100 }, 4000, mina.ease, searchLightRight
    mCircle.animate { cx: 100 }, 4000, mina.ease

  sG.click ->
    sCircle.stop()
    mCircle.stop()
    sCircle.animate { r: 700 }, 650, mina.linear, ->
      sCircle.remove()
    mCircle.animate { r: 700 }, 350, mina.linear, ->
      body.css { backgroundColor: '#fff' }
      mCircle.remove()
      cart.show()
      fontList.css({ opacity: 1 })
    sText.animate { opacity: 0 }, 350, mina.ease, ->
      mCircle.remove()
    showFonts()
    sG.unclick()


  showFonts = ->
    tVegan = s.text 190, 400, "a"
    tVegan.attr { fill: '#000', fontFamily: "VeganSans", fontSize: '25rem' }
    nVegan = s.text 20, 20, "NEW!"
    nVeganPath = s.path "M110,180Q120,110,210,120"
    nVeganPath.attr { fill: 'none' }
    nVegan.attr { textpath: nVeganPath }
    nVegan.attr { fill: "#f00" }
    cVegan = s.circle 300, 300, 220
    cVegan.attr { fill: "#ff0" }
    vegan = s.g cVegan, tVegan, nVegan

    tKunda = s.text 570, 610, "g"
    tKunda.attr { fill: '#000', fontFamily: "Kunda", "font-size": "8rem" }
    cKunda = s.circle 600, 580, 100
    cKunda.attr { fill: '#f00' }
    kunda = s.g cKunda, tKunda

    tHrot = s.g s.text(882, 300, "H"), s.text(750, 340, "mmm"), s.text(750, 380, "mm"), s.text(750, 420, "m")
    tHrot.attr { fill: '#000', fontFamily: "Hrot", "font-size": "4rem" }
    cHrot = s.circle 810, 330, 170
    cHrot.attr { fill: '#00f' }
    hrot = s.g cHrot, tHrot


    fG = s.g vegan, kunda, hrot
    fG.attr { opacity: 0 }
    fG.animate { opacity: 0.01 }, 300, mina.ease, ->
      fG.animate { opacity: 1 }, 500, mina.ease

    rotateNVegan = ->
      nVegan.animate { transform: "r3600, 300, 300" }, 50000, mina.linear, rotateNVegan

    rotateNVegan()

    vegan.click ->
      document.location = "/fonts/vegan"
    kunda.click ->
      document.location = "/fonts/kunda"
    hrot.click ->
      document.location = "/fonts/hrot"

  searchLightRight()

  $("header h1").on "mouseenter", ->
    $("header nav").addClass('visible')

  $(window).scroll ->
    scrolled = $(this).scrollTop()
    console.log scrolled
    if scrolled < 237
      fG.attr { transform: "translateX("+scrolled*4+")" }
    else
      $("svg").hide()
