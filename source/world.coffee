
class window.Position

  constructor: (x, y) ->
    this.x = x
    this.y = y


class window.World

  map: []
  light: []
  items: []

  height_map: []

  task: []
  task_queue: []

  actors: []
  actor_queue: []

  water_level: 0
  next_id: 0

  changed: true

  version: 0

  constructor: (width, height) ->

    this.width = width
    this.height = height

    # Init the grids
    for x in [1 .. this.width]
      this.height_map[x] = []
      this.task[x] = []
      this.items[x] = []
      this.actors[x] = []
      this.light[x] = []

  get_access_map: ->

    # Needs some padding for the astar lib used
    access_map = [0]

    for x in [1 .. this.width]

      row = [0]
      for y in [1 .. this.height]
        if this.height_map[x][y] < this.water_level or this.actors[x][y]
          row.push(0)
        else
          row.push(1)
      access_map.push(row)

    return access_map

  get_id: ->
    this.next_id = this.next_id + 1
    return this.next_id

  set: (x, y, location_class) ->
    this.map[x][y] = new location_class(this, x, y, this.height_map[x][y])

  add_task: (task) ->
    this.task[task.x][task.y] = task
    this.task_queue.push(task)
    this.changed = true

  remove_task: (task) ->

    if task.assigned
      task.assigned.invalidate()

    this.task[task.x][task.y] = null
    this.task_queue.splice(this.task_queue.indexOf(task), 1)
    this.changed = true

  remove_task_on: (x, y) ->

    if not this.task[x][y]
      return

    this.remove_task(this.task[x][y])

  add_actor: (actor) ->
    this.actors[actor.x][actor.y] = actor
    this.actor_queue.push(actor)
    this.changed = true

  remove_actor: (actor) ->
    this.actors[actor.x][actor.y] = null
    this.actor_queue.splice(this.actor_queue.indexOf(actor), 1)
    this.changed = true

  add_item: (item) ->
    this.items[item.x][item.y] = item
    this.items_changed = true
    this.changed = true
    item.created()

  remove_item: (item) ->
    this.items[item.x][item.y] = null
    this.changed = true

  item_at: (object) ->
    return this.items[object.x][object.y]

  find_free_spot: (start_x, start_y) ->

    # TODO: optimize this!

    distance = null
    location = null

    for x in [1 .. this.width]
      for y in [1 .. this.height]

        if this.items[x][y]
          continue

        distance_to_item = Math.abs(x - start_x) + Math.abs(y - start_y)
        if distance == null or distance_to_item < distance
          location = { x: x, y: y }
          distance = distance_to_item

    return location


  find: (x, y, range, check) ->
    for rx in [ -range .. range ]
      for ry in [ -range .. range ]

        if x + rx <= 0
          continue

        if y + ry <= 0
          continue

        if x + rx > this.width
          continue

        if y + ry > this.width
          continue

        check(x+rx, y+ry)

  find_tasks: (x, y, range) ->
    find_tasks = []

    this.find x, y, range, (check_x, check_y) =>
        if this.task[check_x][check_y]
          find_tasks.push(this.task[check_x][check_y])

    return find_tasks

  move_actor: (actor, x, y) ->

    # Is this place free?
    if not this.reachable(x, y)
      return false

    this.actors[actor.x][actor.y] = null

    # Move
    actor.x = x
    actor.y = y
    this.actors[actor.x][actor.y] = actor

  reachable: (x, y) ->

    if x < 1 or y < 1
      return false

    if this.actors[x][y]
      return false

    if x > this.width or y > this.height
      return false

    if this.height_map[x][y] < this.water_level
      return false

    return true

  smoothen: (map, acount) ->
    for c in [1 .. acount]
      for x in [1 .. this.width]
        for y in [1 .. this.height]
          avg = 0
          count = 0
          for ox in [ -1 .. 1]
            for oy in [ -1 .. 1]

              if x + ox <= 0 or y + oy <= 0 or x + ox > this.width or y + oy > this.height
                continue

              if ox == 0 and oy == 0
                continue

              avg = avg + map[x+ox][y+oy]
              count = count + 1
          map[x][y] = avg / count

  normalize: (map, norm) ->

    max = 0
    for x in [1 .. this.width]
        for y in [1 .. this.height]
          if map[x][y] > max
            max = map[x][y]

    for x in [1 .. this.width]
        for y in [1 .. this.height]
          map[x][y] = Math.round(((map[x][y] / max) * norm), 1)


  create_height_map: ->

    for x in [1 .. this.width]
      this.height_map[x] = []
      for y in [1 .. this.height]
        this.height_map[x][y] = 2
        if Math.round((Math.random()*20)) == 1
          this.height_map[x][y] = Math.floor((Math.random()*1000)) - 500


    this.smoothen(this.height_map, 20)
    this.normalize(this.height_map, 4)


  find_item: (start_x, start_y, object, in_pile) ->

    distance = null
    found_item = null

    for x in [1 .. this.width]
      for y in [1 .. this.height]

        item = this.items[x][y]

        if not item
          continue

        if not (item instanceof object)
          continue

        if in_pile == false and this.task[x][y] instanceof window.PileTask
          continue

        if in_pile == true and not (this.task[x][y] instanceof window.PileTask)
          continue

        if not this.reachable(x, y) and (x != start_x and y != start_y)
          continue

        distance_to_item = Math.abs(x - start_x) + Math.abs(y, start_y)

        if distance == null or distance_to_item < distance
          distance = distance_to_item
          found_item = item

    console.debug "Search for ", object, "resulted in", found_item
    return found_item


  cycle: ->
    for x in [1 .. this.width]
      for y in [1 .. this.height]

        if not this.items[x][y]
          continue

        this.items[x][y].cycle()





  generate: ->


    this.create_height_map()



    for x in [1 .. this.width]
      this.map[x] = []
      for y in [1 .. this.height]
        this.map[x][y] = new window.Grass(this, x, y, this.height_map[x][y])


  lightmap: ->

    max_height=0
    for x in [1 .. this.width]
      for y in [1 .. this.height]
        if this.height_map[x][y] > max_height
          max_height = this.height_map[x][y]

    factor = 6 / max_height

    for x in [1 .. this.width]
      this.light[x] = []
      for y in [1 .. this.height]
        this.light[x][y] = parseInt(factor*(max_height-this.height_map[x][y]), 10) + parseInt(Math.random()*2, 10)


  populate: ->

    plains = []
    for x in [1 .. this.width]
      plains[x] = []
      for y in [1 .. this.height]
        plains[x][y] = Math.floor((Math.random()*10))

    this.smoothen(plains, 6)
    this.normalize(plains, 3)
    this.lightmap()

    for x in [1 .. this.width]
      this.map[x] = []
      for y in [1 .. this.height]

        this.map[x][y] = new window.Grass(this, x, y, this.height_map[x][y])

        if plains[x][y] == 1
          this.map[x][y] = new window.Grass(this, x, y, this.height_map[x][y])

        if Math.floor((Math.random()*50)) == 1
          this.items[x][y] = new window.Wheat(this, x, y, this.height_map[x][y])

        if plains[x][y] == 3
          this.items[x][y] = new window.Tree(this, x, y, this.height_map[x][y])


        if this.height_map[x][y] < this.water_level
          this.map[x][y] = new window.Water(this, x, y, this.height_map[x][y])
          this.items[x][y] = null



