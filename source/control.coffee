
COMMAND =
  gather: 1
  build: 2






class window.Control

  cursor_x: 1
  cursor_y: 1
  command: COMMAND.gather
  select: false


  constructor: (world, content, renderer) ->

    this.world = world
    this.content = content
    this.renderer = renderer

  translate: (cursor_x, cursor_y) ->

    tile_width = this.renderer.tile_width
    tile_height = this.renderer.tile_height

    # Translate x,y to isometric x,y
    x = (((cursor_x - this.renderer.viewport_offset_x)  * .25) - 10)
    y = ((cursor_y - this.renderer.viewport_offset_y) - 100) * this.renderer.zoom


    return {
        x: Math.round((x / tile_height) + (y / tile_width))
        y: Math.round((y / tile_width) - (x / tile_height))
    }

  show_cursor: (x,y) ->

    tile_width = this.renderer.tile_width
    tile_height = this.renderer.tile_height

    ix = x * tile_width - (y * tile_width)
    iy = y * tile_height + (x * tile_height)

    ox = x + this.renderer.x_offset
    oy = y + this.renderer.y_offset

    height = this.world.map[ox][oy].get_vertical_offset()

    this.renderer.draw_tile(this.cursor_context, 0, ix, iy, height)

  init: ->

    control_surface = document.getElementById("fx")

    cursor_canvas = document.getElementById("cursor")
    this.cursor_context = cursor_canvas.getContext("2d")

    $(control_surface).mousemove (event) =>

      this.cursor_context.clearRect(0, 0, 2000, 2000)

      cursor = this.translate(event.offsetX, event.offsetY)

      if this.select
        for x in [ this.select.x .. cursor.x ]
          for y in [ this.select.y .. cursor.y ]
            this.show_cursor(x, y)

      else
        this.show_cursor(cursor.x, cursor.y)


      if this.move_map
        this.renderer.x_offset = this.base_offset_x + (this.move_map.x - cursor.x)
        this.renderer.y_offset = this.base_offset_y + (this.move_map.y - cursor.y)




    $(control_surface).mousedown (event) =>
      console.debug event

      if event.button == 0
        this.select = this.translate(event.offsetX, event.offsetY)

      if event.button == 2
        this.move_map = this.translate(event.offsetX, event.offsetY)
        this.base_offset_x = this.renderer.x_offset
        this.base_offset_y = this.renderer.y_offset

    $(control_surface).mouseup (event) =>

      cursor = this.translate(event.offsetX, event.offsetY)

      if this.select
        start = this.select
        end = cursor
      else
        start = cursor
        end = cursor

      if not this.move_map
        start.x = start.x + this.renderer.x_offset
        start.y = start.y + this.renderer.y_offset
        end.x = end.x + this.renderer.x_offset
        end.y = end.y + this.renderer.y_offset
        new window.Command(this.world, start, end, mouse_x = event.pageX, mouse_y = event.pageY)

      this.select = null
      this.move_map = null


