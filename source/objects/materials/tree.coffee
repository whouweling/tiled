

class window.Tree extends window.Plant

  name: "tree"
  grow_delay: 1000

  get_product: ->
    super()
    return window.Wood

  get_tile: ->
    if this.grown == this.grow_delay
      return 4
    else
      return 5
