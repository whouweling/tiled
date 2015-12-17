

class window.Worker extends window.Actor

  home: null

  hunger: 0
  sleep: 0

  # Start work on a task
  start: (task) ->

    task.assigned = this
    this.tasks.unshift(task)
    console.debug "Worker " + this.id + " starts on task " + task.id + " (" + task.abbr + ")"

  invalidate: ->
    for task in this.tasks
      task.assigned = null
    this.tasks = []

  get_tile: ->
    return 7

  act: ->

    super()

#    this.hunger = this.hunger + 1
#    if this.hunger > 1000
#      this.die()
#      return
#
#    this.sleep = this.sleep + 1
#    if this.sleep > 2000
#      this.die()
#      return

    # Do we need to move to somewhere?
    if (this.x != this.target_x or this.y != this.target_y) and this.world.reachable(this.target_x, this.target_y)
      this.move()
      return

    if not this.tasks.length and this.carry

      if this.world.items[this.x][this.y] != null
        drop_location = this.world.find_free_spot(this.x, this.y)
        this.target_x = drop_location.x
        this.target_y = drop_location.y

      if this.world.items[this.x][this.y] == null
        this.drop()

      return



    # Idling
    if this.tasks.length == 0

      if parseInt(Math.random()*50, 10) == 1
        target_x = this.target_x + parseInt(Math.random()*10-5, 10)
        target_y = this.target_y + parseInt(Math.random()*10-5, 10)
        if this.world.reachable(target_x, target_y)
          this.target_x = target_x
          this.target_y = target_y

      #this.furfill_needs()

      return

    task = this.tasks[0]

    result = task.execute()

    if result instanceof window.Task
      this.start(result)

    if not result

      console.debug "Worker " + this.id + " completed task " + task.id + " (" + task.abbr + ")"
      task.assigned = null

      # Complete the task, remove it from my queue
      this.tasks.shift()

      #this.furfill_needs()

      return

    else

      if task.working

        if parseInt(Math.random()*5, 10) == 1

          if task instanceof window.GatherTask
            new window.IndicatorEffect("smoke", this.x, this.y)

          if task instanceof window.BuildTask
            new window.IndicatorEffect("work", this.x, this.y)

          if task instanceof window.ConsumeTask
            new window.IndicatorEffect("eat", this.x, this.y)

          if task instanceof window.RestTask
            new window.IndicatorEffect("sleep", this.x, this.y)



  furfill_needs: ->

    # If we are hungry search for food
    if this.hunger > 500 and this.world.find_item(this.x, this.y, window.Food, null)
      this.start(new ConsumeTask(this.world, this.x, this.y, { work: 20, abbr: "E" } ))

    # If we are sleepy search for an available bed
    if this.sleep > 500 and this.world.find_item(this.x, this.y, window.Bed, null)
      this.start(new RestTask(this.world, this.x, this.y, { work: 150, abbr: "E" } ))






