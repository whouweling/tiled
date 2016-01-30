

class window.Engine

  world: null
  control: null
  render: null
  content: null
  context: null

  constructor: ->

    this.content = new Content(window.RESOURCES)
    this.world = new window.World(250, 250, 29399)
    this.render = new window.Render(this.world, this.content)
    this.control = new window.Control(this.world, this.content, this.render)

  start: ->

    this.world.generate()
    this.world.populate()

    this.render.resize()

    this.content.load =>

      this.control.init()

     # this.load_test_world()

      #test = new window.BuildTest(this.world)
      #test.execute()


      this.world.add_item(new window.House(this.world, Math.round(this.world.width/2),  Math.round(this.world.height/2)))


      this.render.update()

      task_queue_delay = 0
      world_cycle_delay = 0


      render_frame = =>

        this.render.update_map()
        this.render.update_fx()

        requestAnimationFrame(render_frame)

      render_frame()


      setInterval =>

        task_queue_delay = task_queue_delay + 1
        if task_queue_delay > 10
          task_queue_delay = 0
          this.distribute_tasks()

        for actor in this.world.actor_queue
          actor.act()

        world_cycle_delay = world_cycle_delay + 1
        if world_cycle_delay > 10
          world_cycle_delay = 0
          this.world.cycle()

      , 100





  load_test_world: ->

      # Clear a spot
      for x in [ 1 .. 10 ]
        for y in [ 1 .. 10 ]
          this.world.items[5+x][5+y] = null
          this.world.height_map[5+x][5+y] = 1

      this.world.add_item(new window.House(this.world, 10, 12))
#
      this.world.add_item(new window.Wood(this.world, 15, 11, 10))
#      this.world.add_item(new window.Wood(this.world, 15, 12))
#      this.world.add_item(new window.Wood(this.world, 15, 13))
#      this.world.add_item(new window.Wood(this.world, 15, 14))
#
#      this.world.add_item(new window.Potato(this.world, 17, 11))
#      this.world.add_item(new window.Potato(this.world, 17, 12))
#      this.world.add_item(new window.Potato(this.world, 17, 13))
#      this.world.add_item(new window.Potato(this.world, 17, 14))

#      test_x = 14
#      for task_type in window.TASK_TYPES
#        test_x = test_x + 2
#        for y in [ 1 .. 2 ]
#          this.world.add_task(new task_type.task(this.world, test_x, 11 + y, task_type.options))

      this.world.changed = true


  # Distribute tasks along the workers
  distribute_tasks: ->

      #console.log this, "looking for task"

      idle_workers = []
      for worker in this.world.actor_queue
        if worker.tasks.length == 0
          idle_workers.push(worker)

      #console.debug "Tasks:", this.world.task_queue
      for task in this.world.task_queue

        if task.assigned != null
          continue

        if not task.is_executable()
          continue

        # Get a worker
        worker = idle_workers.pop()

        if not worker
          return

        worker.start(task)

      return

