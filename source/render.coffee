

class window.Render

  constructor: (world, content) ->

    this.world = world
    this.content = content
    this.tile_width = 36
    this.tile_height = this.tile_width / 2
    this.height_multiplier = 14

    this.el_width = 73
    this.el_height = 146

    this.x_offset = 0
    this.y_offset = 0


    this.viewport_offset_x = 0
    this.viewport_offset_y = 0

    this.viewport_width = 10
    this.viewport_height = 10


    this.zoom = 1

    this.map_context = document.getElementById("map").getContext("2d")
    this.items_context = document.getElementById("items").getContext("2d")
    this.fx_context = document.getElementById("fx").getContext("2d")


  resize: ->
    this.viewport_width = parseInt(window.innerWidth / this.tile_width / 2,  10)
    this.viewport_height = parseInt(window.innerHeight / this.tile_height / 2, 10)
    this.viewport_offset_x = window.innerWidth / 2
    this.viewport_offset_y = 0

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

        #console.log "map:", this.world.map[x][y], this.resources.sprites.grass_2
#
#
#        height_to_tile = 1
#        if x > 3 and y > 3
#          diff = this.world.map[x][y].height - this.world.map[x - 3][y - 3].height
#          height_to_tile = 4 - Math.abs(diff) + this.world.map[x][y].brightness_variation
#          if height_to_tile < 1
#            height_to_tile = 1
#          if height_to_tile > 5
#            height_to_tile = 5

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
        height = this.world.map[ox][oy].get_vertical_offset()

        if this.world.map[ox][oy].height < this.world.water_level
          height=0

        ix = x * this.tile_width - (y * this.tile_width)
        iy = y * this.tile_height + (x * this.tile_height)

        #for steps in [ 0 .. height ]
        light = this.world.light[ox][oy]
        this.draw_tile(this.map_context, tile, ix, iy, height, light)

        this.map_context.fillStyle = '#ccc'

        if this.world.task[ox][oy]
#          image = this.content.sprites[this.world.task[x][y].get_tile()][height_to_tile]
#
#          this.map_context.drawImage(image, ix + this.offset_x, iy + this.offset_y - height * 3)

          if not this.world.items[ox][oy]
            this.map_context.fillText(this.world.task[ox][oy].abbr, ix + this.viewport_offset_x + 17, (iy + this.viewport_offset_y - height * 3) + 85)

        if this.world.items[ox][oy]

          tile = this.world.items[ox][oy].get_tile()

          this.draw_tile(this.map_context, tile, ix, iy, height, light)

          if this.world.items[ox][oy].count > 1
            this.map_context.fillText(this.world.items[ox][oy].count, ix + this.viewport_offset_x + 17, (iy + this.viewport_offset_y - height * 3) + 85)

        if this.world.actors[ox][oy]

           tile = this.world.actors[ox][oy].get_tile()
           this.draw_tile(this.map_context, tile, ix, iy, height, light)

           if this.world.actors[ox][oy].carry
             tile = this.world.actors[ox][oy].carry.get_tile()
             this.draw_tile(this.map_context, tile, ix, iy, height+1, light)


#