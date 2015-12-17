
class window.Task

  abbr: null
  work: 0

  assigned: null
  working: null

  constructor: (world, x, y, options) ->

    this.world = world
    this.x = x
    this.y = y
    this.id = world.get_id()
    this.working = false

    if options
      this.options = options
      this.abbr = this.options.abbr
      this.work = this.options.work
      console.log "Set work to:", this.work

    this.init()

  remove: ->
    this.world.remove_task(this)

  init: ->

  is_executable: ->
    return true

  execute: ->

  do_work: ->
    if this.work > 0
      this.work = this.work - 1
      this.working = true
      return true
    return false

  get_tile: ->
    return "command"
















