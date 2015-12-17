
class Coordinates

  constructor: (x, y) ->
    this.x = x
    this.y = y

  equals: (coordinates) ->
    if coordinates.x == this.x and coordinates.y = this.y
      return true
    else
      return false