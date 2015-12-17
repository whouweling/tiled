
class window.PlantTask extends window.Task

  is_executable: ->

    # Is something stored here?
    if this.world.items[this.x][this.y]
      return false

    # Is the material nearby somewhere?
    if not this.world.find_item(this.x, this.y, this.options.material)
      return false

    return true

  execute: ->

    item_at_location = this.world.items[this.x][this.y]

    if item_at_location

      if not (item_at_location instanceof this.options.material)
        this.remove()
        return false

      planted = this.world.item_at(this).get_planted()
      planted_item = new planted(this.world, this.x, this.y)
      planted_item.grown = 0

      this.world.add_item(planted_item)
      this.remove()
      this.world.add_task(new window.GatherTask(this.world, this.x, this.y, { abbr: "F" }))
      return false

    # Go fetch the material and bring it here!
    return new window.Fetch(this.world, this.x, this.y, this.options.material, null)


