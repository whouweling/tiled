

class window.PotatoPlant extends window.Plant

  name: "potato_plant"

  grow_delay: 50

  get_product: ->
    super()
    return window.Potato

  get_tile: ->
    if this.grown == this.grow_delay
      return "potato_plant"
    else
      return "potato_plant_growing"



