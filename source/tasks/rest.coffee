
class window.RestTask extends window.Task

  is_executable: ->

    return true

  execute: ->

    if this.carry
      return new window.DropTask(this.world, this.x, this.y)

    if this.world.item_at(this.assigned) instanceof window.Bed

      console.log "Sleeping"
      # Consume
      if this.do_work()
        return true

      this.assigned.sleep = 0
      return false

    # Search for a free bed
    bed = this.world.find_item(this.x, this.y, window.Bed, null)

    if not bed
      return false

    if not this.world.is_reachable(bed)
      return false

    this.assigned.goto(bed)
    return true


