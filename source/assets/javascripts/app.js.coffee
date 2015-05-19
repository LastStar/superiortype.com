//= require jquery/dist/jquery.min
//= require snap.svg/dist/snap.svg-min

fG = ''
if $('#show-room')
  fontList = $('section.font-list')

  s = Snap "#show-room"


  showFonts = ->
    tVegan = s.text 150, 430, ["a ", " Rrr", " 65"]
    tVegan.attr { fill: '#000', fontFamily: "VeganSans", fontSize: '35rem' }
    lVegan = s.text 150, 150, "Vegan Sans"
    lVeganPath = s.path "M320,620Q610,610,620,320"
    lVeganPath.attr { fill: 'none' }
    lVegan.attr { textpath: lVeganPath, opacity: 0, fontSize: '1.5rem' }
    nVegan = s.text 210, 210, "NEW! "
    nVeganPath = s.path "M40,320Q140,100,320,40"
    nVeganPath.attr { fill: 'none' }
    nVegan.attr { textpath: nVeganPath }
    nVegan.attr { fill: "#f00", fontSize: "2rem", fontStyle: 'italic', fontWeight: "bold" }
    cVegan = s.circle 320, 320, 280
    cVegan.attr { fill: "#ff0" }
    mVegan = s.circle 320, 320, 280
    mVegan.attr { fill: "#fff" }
    vegan = s.g cVegan, tVegan, nVegan
    vegan.attr { transform: "t-800 -800", mask: mVegan}

    tKunda = s.text 570, 800, "g"
    tKunda.attr { fill: '#000', fontFamily: "Kunda", "font-size": "8rem" }
    cKunda = s.circle 600, 780, 100
    cKunda.attr { fill: '#f00' }
    kunda = s.g cKunda, tKunda
    kunda.attr { transform: "t600 100" }

    tHrot = s.g s.text(982, 300, "H"), s.text(850, 340, "mmm"), s.text(850, 380, "mm"), s.text(850, 420, "m")
    tHrot.attr { fill: '#000', fontFamily: "Hrot", "font-size": "4rem" }
    cHrot = s.circle 910, 330, 210
    cHrot.attr { fill: '#00f' }
    hrot = s.g cHrot, tHrot
    hrot.attr { transform: "t100 800" }

    fG = s.g vegan, kunda, hrot
    fG.attr { opacity: 0 }
    fG.animate { opacity: 0.01 }, 300, mina.ease, ->
      fG.animate { opacity: 1 }, 500, mina.ease
      hrot.animate { transform: "t0 0" }, 1000, mina.ease
      kunda.animate { transform: "t0 0" }, 1000, mina.ease
      vegan.animate { transform: "t0 0" }, 1000, mina.ease, ->
        nVegan.animate { transform: "r360, 320, 320" }, 3000, mina.linear
        tVegan.animate { transform: "translate(-350 150) scale(0.65, 0.65)" }, 2000, mina.linear, ->
          tVegan.animate { transform: "translate(-1130 140) scale(0.75, 0.75)" }, 2000, mina.linear

    rotateLeft = ->
      lVegan.attr { opacity: 1 }
      lVegan.animate { transform: 'r3600 320 320' }, 100000, mina.linear

    rotateRight =  ->
      lVegan.attr { opacity: 0 }
      lVegan.stop()

    vegan.hover rotateLeft, rotateRight


    vegan.click ->
      kunda.remove()
      hrot.remove()
      vegan.animate { transform: "scale(30, 30) translate(-400, -400)" }, 600, mina.linear, ->
        document.location = "/fonts/vegan-sans"
    kunda.click ->
      document.location = "/fonts/kunda"
    hrot.click ->
      document.location = "/fonts/hrot"

  showFonts()

  $("header h1").on "mouseenter", ->
    $("header nav").addClass('visible')

