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
  scale = 2.9

  positions = {
    veganSans: {
      name: 'vegan-sans',
      initial: 't0, '+(height+160),
      final: 't'+(width/2-240)+' 520 s'+scale,
      speed: 700
    }
    kundaBook: {
      name: 'kunda-book',
      initial: 't'+(width+160)+', '+(height+150),
      final: 't'+(width/2+240)+' 520 s'+scale,
      speed: 800
    }
    hrot: {
      name: 'hrot',
      initial: 't'+(width/2)+', -160',
      final: 't'+(width/2)+' 150 s'+scale,
      speed: 900
    }
  }

  Snap.load '/assets/images/buttons.svg', (canvas) ->
    buttons = canvas.select 'g#Buttons'
    s.append buttons

    veganSans = buttons.select 'g#'+positions.veganSans.name
    veganSans.attr { transform: zero }
    veganSans.selectAll('g').attr { transform: positions.veganSans.initial }

    kundaBook = buttons.select 'g#'+positions.kundaBook.name
    kundaBook.attr { transform: zero }
    kundaBook.selectAll('g').attr { transform: positions.kundaBook.initial }

    hrot = buttons.select 'g#'+positions.hrot.name
    hrot.attr { transform: zero }
    hrot.selectAll('g').attr { transform: positions.hrot.initial }

    moveButtons 0


  moveButtons = (index) ->
    if index > 1
      index = 0

    veganSans.selectAll('g')[index].animate { transform: positions.veganSans.final}, positions.veganSans.speed, mina.bounce
    kundaBook.selectAll('g')[index].animate { transform: positions.kundaBook.final}, positions.kundaBook.speed, mina.bounce
    hrot.selectAll('g')[index].animate { transform: positions.hrot.final}, positions.hrot.speed, mina.bounce

    restart = ->
      returnButtons index, ->
        moveButtons ++index

    setTimeout restart, 4000

  returnButtons = (index, callback) ->
    veganSans.selectAll('g')[index].animate { transform: positions.veganSans.initial}, positions.veganSans.speed/2, mina.easein, callback
    kundaBook.selectAll('g')[index].animate { transform: positions.kundaBook.initial}, positions.kundaBook.speed/2, mina.easein
    hrot.selectAll('g')[index].animate { transform: positions.hrot.initial}, positions.hrot.speed/2, mina.easein


  # $.each buttons, (i, item) ->
  #   Snap.load '/assets/images/'+item.name+'.svg', (f) ->
  #     g = f.select("g")
  #     s.append g
  #     console.log item.name, item.speed
  #     g.attr { transform: "translate("+item.initial+")"  }
  #     if item.speed > 0
  #       g.animate { transform: item.final }, item.speed, mina.bounce

