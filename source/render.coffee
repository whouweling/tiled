

class window.Render

  constructor: (world, content) ->

    this.world = world
    this.content = content
    this.tile_width = 36
    this.tile_height = this.tile_width / 2
    this.height_multiplier = 14

    this.el_width = 73
    this.el_height = 146

    this.x_offset =  Math.round(this.world.width / 2) - 10
    this.y_offset =  Math.round(this.world.height / 2) - 10


    this.viewport_offset_x = 0
    this.viewport_offset_y = 0

    this.viewport_width = 10
    this.viewport_height = 10

    this.zoom =  1

    this.map_context = document.getElementById("map").getContext("2d")
    this.items_context = document.getElementById("items").getContext("2d")
    this.fx_context = document.getElementById("fx").getContext("2d")


  resize: ->
    this.viewport_width = parseInt(window.innerWidth / (this.tile_width * this.zoom) / 2,  10) - 2
    this.viewport_height = parseInt(window.innerHeight / (this.tile_height * this.zoom) / 2, 10) - 2
    this.viewport_offset_x = window.innerWidth / 2
    this.viewport_offset_y = -120

  update: () ->

    # TODO: this needs to be moved
    this.tiles_resource = this.content.images.tiles

    this.update_map()
    this.update_fx()

  update_fx: () ->

    return

    this.fx_context.clearRect(0, 0, 2000, 2000)
    for effect in window.effects

        if not effect
          continue

        effect.run()

        ix = effect.x * this.tile_width - (effect.y * this.tile_width)
        iy = effect.y * this.tile_height + (effect.x * this.tile_height)

        height = this.world.map[effect.x][effect.y].get_vertical_offset()
        tile = this.content.sprites[effect.tile][1]

        this.fx_context.drawImage(tile, ix + this.viewport_offset_x, (iy + this.viewport_offset_y - height * 3 - 10) + effect.viewport_offset_y)





  draw_tile: (context, tile, x, y, height, light) ->

    if light < 1
      light = 1

    if light > 10
      light = 10

    if not light
      light = 1


    context.drawImage(this.tiles_resource[light], tile*this.el_width, 0, this.el_width, this.el_height, (x * this.zoom) + this.viewport_offset_x, (y * this.zoom) + this.viewport_offset_y - (height * this.zoom) * this.height_multiplier, this.el_width*this.zoom, this.el_height*this.zoom)


  update_map: ->

    #console.log "Render map"

    this.map_context.clearRect(0, 0, 2000, 2000)

    for x in [1 .. this.viewport_width]
      for y in [1 .. this.viewport_height]

        ox = x + this.x_offset
        oy = y + this.y_offset

        if ox < 1
          continue

        if oy < 1
          continue

        if ox > this.world.width
          continue

        if oy > this.world.height
          continue

        tile = this.world.map[ox][oy].tile
        task = this.world.task[ox][oy]
        item = this.world.items[ox][oy]

        height = this.world.map[ox][oy].get_vertical_offset()

        ix = x * this.tile_width - (y * this.tile_width)
        iy = y * this.tile_height + (x * this.tile_height)
        light = this.world.light[ox][oy]


        if this.world.cloud[ox][oy] > 2
          light = light + 2

        if height < this.world.water_level
          light = light + 10

        # Fake substance
        if x == this.viewport_width or y == this.viewport_height or ox == this.world.width or oy == this.world.height
          for h in [ -1 .. height ]
            this.draw_tile(this.map_context, 3, ix, iy, h, 8 - h)


        this.draw_tile(this.map_context, tile, ix, iy, height, light)


        # Fake soft shadows
        corner = true
        if oy > 1 and  this.world.map[ox][oy-1].height > height
          this.draw_tile(this.map_context, 18, ix, iy, height, light)
          corner = false

        if ox > 1 and this.world.map[ox-1][oy].height > height
          this.draw_tile(this.map_context, 19, ix, iy, height, light)
          corner = false

        if ox > 1 and oy > 1 and corner and this.world.map[ox-1][oy-1].height > height
          this.draw_tile(this.map_context, 21, ix, iy, height, light)

        if item
          this.draw_tile(this.map_context, 20, ix, iy, height, light)

        # Draw water
        if height < this.world.water_level
          this.draw_tile(this.map_context, 2, ix, iy, this.world.water_level, this.world.light[ox][oy])

        if task




#          image = this.content.sprites[this.world.task[x][y].get_tile()][height_to_tile]
#          this.map_context.drawImage(image, ix + this.offset_x, iy + this.offset_y - height * 3)

          if task.work > 0
            this.draw_tile(this.map_context, 23, ix, iy, height, light)
            this.map_context.fillText(task.work, ix  + this.tile_width / 2, (iy - height * 3) + 85)

          if not item
            this.map_context.fillText(task.abbr, ix + 17, (iy + height * 3) + 85)

        if item
          this.draw_tile(this.map_context,  item.get_tile(), ix, iy, height, light)

          if item.count > 1
            this.map_context.fillText(item.count, ix + 17, (iy + height * 3) + 85)

        actor = this.world.actors[ox][oy]
        if actor
           this.draw_tile(this.map_context, actor.get_tile(), ix, iy, height, light)

           if actor.carry
             this.draw_tile(this.map_context, actor.carry.get_tile(), ix, iy, height+1, light)

        if this.world.cloud[ox][oy] > 2
          this.draw_tile(this.map_context, 22, ix, iy, 8, light)
