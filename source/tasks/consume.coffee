
class window.ConsumeTask extends window.Task

  is_executable: ->

    return true

  execute: ->


    if this.assigned.carry and (this.assigned.carry instanceof window.Food)

      # Consume
      if this.do_work()
        return true

      this.assigned.hunger = 0
      this.assigned.carry = 0
      return false

    item = this.world.item_at(this.assigned)

    if item instanceof window.Food
      console.log "Picking up", item
      this.assigned.carry = item
      this.world.remove_item(item)
      return true

    food = this.world.find_item(this.x, this.y, window.Food, false)

    if not food
      console.log "No food found"
      return false

    console.log "Going to food", food.x, food.y
    this.assigned.goto(food)
    return true
