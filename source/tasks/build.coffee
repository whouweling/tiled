
class window.BuildTask extends window.Task

  get_tile: ->
    if this.material_at_build
      return 12

  constructor: (world, x, y, options) ->
    super(world, x, y, options)
    this.materials = {}
    this.material_at_build = false

  is_executable: ->

    if this.world.items[this.x][this.y]
      return false

    # Is the material in a pile nearby somewhere?
    for index, need of this.options.needs

      if not need.count
        continue

      if not this.materials[index]
        this.materials[index] = 0

      if this.materials[index] < need.count
        if not this.world.find_item(this.x, this.y, need.material, null)
          return false

    return true


  execute: ->

    # Did material arive at the build site?
    if this.world.items[this.x][this.y]
      material_at_location = this.world.items[this.x][this.y]
      for index, need of this.options.needs

        if not need.count
          continue

        if material_at_location instanceof need.material
          this.materials[index] = this.materials[index] + 1

      this.world.remove_item(material_at_location)
      if not this.material_at_build
        this.world.add_item(new Buildsite(this.world, this.x, this.y))

    # Do we need more material?
    for index, need of this.options.needs
      if this.materials[index] < need.count
        if this.world.find_item(this.x, this.y, need.material, null)
          return new window.Fetch(this.world, this.x, this.y, need.material, null)

    # Perform the work
    if this.do_work()
      console.log "Doing work ..."
      return true

    # Done!
    this.world.add_item(new this.options.result(this.world, this.x, this.y))
    return false

