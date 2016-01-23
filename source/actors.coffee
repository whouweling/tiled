

class window.Actor

  id: null
  tasks: null

  target_x: null
  target_y: null

  carry: null

  path: null

  tile_offset_x: null
  tile_offset_y: null

  constructor: (world, x, y) ->

    this.world = world

    this.x = x
    this.y = y

    this.target_x = x
    this.target_y = y

    this.tasks = []

    this.id = this.world.get_id()

  act: ->


  find_path: (target_x, target_y) ->

    graph = new Graph(this.world.get_access_map())

    start = graph.nodes[this.x][this.y]
    end = graph.nodes[target_x][target_y]

    options =
      diagonal: true
      closest: true
      heuristic: astar.diagonal

    return astar.search(graph.nodes, start, end, options)


  move: ->

    if not this.path

      this.path = this.find_path(this.target_x, this.target_y)

      if not this.path or this.path.length == 0
        offset_x = Math.round((Math.random() * 1) - 2)
        offset_y = Math.round((Math.random() * 1) - 2)
        this.path = this.find_path(this.target_x+offset_x, this.target_y+offset_y)

    node = this.path.shift()

    if not node
      this.path = null
      return

    moved = this.world.move_actor(this, node.x, node.y)

    if not moved
      this.path = null


  goto: (place) ->

    if not place
      return false

    this.target_x = place.x
    this.target_y = place.y

    # TODO: check if accessible
    return true


  pickup: (item) ->

    if item.count > 1
      item.count = item.count - 1
      item = new item.constructor(this.world, this.x, this.y)
    else
      this.world.remove_item(item)

    this.carry = item

  drop: ->
    #alert "drop!"

    this.carry.x = this.x
    this.carry.y = this.y

    if this.world.item_at(this) and this.world.item_at(this).constructor == this.carry.constructor
      this.world.item_at(this).count = this.world.item_at(this).count + 1
    else
      this.world.add_item(this.carry)

    this.carry = null

    if this.world.task[this.x][this.y] instanceof window.PileTask
      this.world.items[this.x][this.y].in_pile = true
    else
      this.world.items[this.x][this.y].in_pile = false

  die: ->

    if this.carry
      this.drop()

    this.world.remove_actor(this)






