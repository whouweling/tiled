

class window.DropTask extends window.Task


  constructor: (world, x, y) ->
    super(world, x, y)


  execute: ->

    if not this.assigned.carry
      return false

    console.log "here"
    if (not this.world.item_at(this.assigned)) \
       or ((this.world.item_at(this.assigned).constructor == this.assigned.carry.constructor) \
            and this.world.item_at(this.assigned).count < 10)

      this.assigned.drop()
      return false

    location = this.world.find_free_spot(this.assigned.x, this.assigned.y)

    this.assigned.goto(location)



