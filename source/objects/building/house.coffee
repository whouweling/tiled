
class window.House extends window.Building

  get_tile: ->
    return 16

  created: ->
    this.resident = new window.Worker(this.world, this.x, this.y)
    this.world.add_actor(this.resident)


