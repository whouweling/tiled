
class window.GatherTask extends window.Task

  is_executable: ->

    # Something to gather here?
    item = this.world.items[this.x][this.y]
    if not item
      return false

    if not item.has_product()
      return false

    return true

  execute: ->

    if not this.is_executable()
      return

    if this.assigned.carry
      return new window.DropTask(this.world, this.x, this.y)

    if this.assigned.x != this.x or this.assigned.y != this.y

      # First get to the spot to start gathering
      this.assigned.goto(this)
      return true

    # Perform the work
    if this.do_work()
      return true

    # Gather product
    console.log this.world.items[this.x][this.y]
    product = this.world.items[this.x][this.y].get_product()
    this.assigned.carry = new product(this.world, this.x, this.y)

    # Find a free spot to drop the product
    return new window.DropTask(this.world, this.x, this.y)


