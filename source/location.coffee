

class window.Location

  y_offset: 0
  brightness_variation: 0

  constructor: (world, x, y, height) ->
    this.world = world
    this.x = x
    this.y = y
    this.height = height
    this.brightness_variation = Math.floor(Math.random()*2)

  settle: ->
    return

  get_vertical_offset: ->
    return this.height


  around: (check) ->
    for ox in [ -1 .. 1]
      for oy in [ -1 .. 1]

        if this.x + ox <= 0
          continue

        if this.y + oy <= 0
          continue

        if this.x + ox > this.world.width
          continue

        if this.y + oy > this.world.height
          continue

        if ox == 0 and oy == 0
          continue

        check(this.world.map[this.x+ox][this.y+oy])


class window.Indicator extends window.Location

  tile: 4


class window.Grass extends window.Location

  tile: 3

class window.Dirt extends window.Location

  tile: 1

class window.Water extends window.Location

  tile: 2

  get_vertical_offset: ->
    return (this.world.water_level * 2) - 2


