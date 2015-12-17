

class window.Wheat extends window.Plant

  name: "wheat"
  grow_delay: 10

  get_product: ->
    super()
    return window.Grain

  get_tile: ->
    if this.grown == this.grow_delay
      return 9
    else
      return 10



