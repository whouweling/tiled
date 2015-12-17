

window.Utils =

  distance : (object1, object2) ->
    return Math.abs(object1.x - object2.x) + Math.abs(object2.y, object2.y)




Array.prototype.insert = (index, item) ->
  this.splice(index, 0, item)
