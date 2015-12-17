




class window.Fetch extends window.Task

  search_x: null
  search_y: null
  abbr: "F"

  constructor: (world, x, y, object, in_pile) ->
    super(world, x, y)
    this.object = object
    this.in_pile = in_pile

  execute: ->

    # If we carry something unrelated drop it first somewhere
    if not this.assigned.carry instanceof this.object
      return new window.DropTask(this.world, this.x, this.y)

    # Get the material
    if not (this.assigned.carry instanceof this.object)

      item_at_this_location = this.world.items[this.assigned.x][this.assigned.y]

      if item_at_this_location instanceof this.object and (this.in_pile == null or (this.in_pile == item_at_this_location.in_pile))
        this.assigned.pickup(item_at_this_location)

      else

        # Try to find the item on the map
        item = this.world.find_item this.x, this.y, this.object, this.in_pile

        if not item
          this.assigned.invalidate()
          return false

        this.assigned.goto(item)

      return true

    # Bring the material to the designated place
    if this.x != this.assigned.x or this.y != this.assigned.y
      this.assigned.goto(this)
      return

    # Drop the material at the destination location
    this.assigned.drop()
    return false
