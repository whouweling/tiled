

class window.Potato extends window.Food

  name: "potato"
  planted: window.PotatoPlant

  get_tile: ->
    return "potato"

  get_planted: ->
    return window.PotatoPlant
