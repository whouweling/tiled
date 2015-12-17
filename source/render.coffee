

class window.Render

  offset_x: 1000
  offset_y: 0

  constructor: (world, content) ->

    this.world = world
    this.content = content
    this.tile_width = 36
    this.tile_height = this.tile_width / 2
    this.height_multiplier = 14

    this.el_width = 73
    this.el_height = 146

    this.zoom = 1

    this.map_context = document.getElementById("map").getContext("2d")
    this.items_context = document.getElementById("items").getContext("2d")
    this.fx_context = document.getElementById("fx").getContext("2d")

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

        this.fx_context.drawImage(tile, ix + this.offset_x, (iy + this.offset_y - height * 3 - 10) + effect.offset_y)





  draw_tile: (context, tile, x, y, height, light) ->

    if light < 1
      light = 1

    if light > 10
      light = 10

    if not light
      light = 1


    context.drawImage(this.tiles_resource[light], tile*this.el_width, 0, this.el_width, this.el_height, (x * this.zoom) + this.offset_x, (y * this.zoom) + this.offset_y - (height * this.zoom) * this.height_multiplier, this.el_width*this.zoom, this.el_height*this.zoom)


  update_map: ->

    #console.log "Render map"

    this.map_context.clearRect(0, 0, 2000, 2000)

    for x in [1 .. this.world.width]
      for y in [1 .. this.world.height]

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



        tile = this.world.map[x][y].tile


        height = this.world.map[x][y].get_vertical_offset()

        if this.world.map[x][y].height < this.world.water_level
          height=0

        ix = x * this.tile_width - (y * this.tile_width)
        iy = y * this.tile_height + (x * this.tile_height)

        #for steps in [ 0 .. height ]
        light = this.world.light[x][y]
        this.draw_tile(this.map_context, tile, ix, iy, height, light)

        this.map_context.fillStyle = '#ccc'

        if this.world.task[x][y]
#          image = this.content.sprites[this.world.task[x][y].get_tile()][height_to_tile]
#
#          this.map_context.drawImage(image, ix + this.offset_x, iy + this.offset_y - height * 3)

          if not this.world.items[x][y]
            this.map_context.fillText(this.world.task[x][y].abbr, ix + this.offset_x + 17, (iy + this.offset_y - height * 3) + 85)

        if this.world.items[x][y]

          tile = this.world.items[x][y].get_tile()

          this.draw_tile(this.map_context, tile, ix, iy, height, light)

          if this.world.items[x][y].count > 1
            this.map_context.fillText(this.world.items[x][y].count, ix + this.offset_x + 17, (iy + this.offset_y - height * 3) + 85)

        if this.world.actors[x][y]

           tile = this.world.actors[x][y].get_tile()
           this.draw_tile(this.map_context, tile, ix, iy, height, light)

           if this.world.actors[x][y].carry
             tile = this.world.actors[x][y].carry.get_tile()
             this.draw_tile(this.map_context, tile, ix, iy, height+1, light)


#