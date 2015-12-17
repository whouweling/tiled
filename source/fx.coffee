

window.effects = []

class window.Effect

  x: null
  y: null

  tile: null
  lifetime: null

  offset_y: null
  offset_x: null

  constructor: (x, y) ->
    this.x = x
    this.y = y
    this.offset_x = 0
    this.offset_y = 0
    this.lifetime = 10
    effects.unshift(this)

  run: ->
    this.lifetime = this.lifetime - 1
    if this.lifetime == 0
      this.remove()

  remove: ->
    window.effects.splice(window.effects.indexOf(this), 1)


class window.IndicatorEffect extends Effect

  constructor: (tile, x, y) ->
    this.tile = tile
    super(x,y)

  run: ->
    this.offset_y = this.offset_y - 1
    super()


