

class window.Object

  in_pile: false
  is_blocking: false
  count: 1

  constructor: (world, x, y, count) ->
    this.world = world
    this.x = x
    this.y = y
    if count
      this.count = count
    else
      this.count = 1

    #this.created()

  created: ->


  cycle: ->


  has_product: ->
    return false









