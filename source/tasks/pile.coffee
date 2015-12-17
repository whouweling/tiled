
class window.PileTask extends window.Task

  is_executable: ->

    # Is something stored here?
    if this.world.items[this.x][this.y] and this.world.items[this.x][this.y].count <= 10
      return false

    # Is the material nearby somewhere?
    if not this.world.find_item this.x, this.y, this.options.material, false
      return false

    return true

  execute: ->

#    if this.world.items[this.x][this.y] and this.world.items[this.x][this.y].count >= 10
#      return false

    # Go fetch the material and bring it here!
    return new window.Fetch(this.world, this.x, this.y, this.options.material, false)


