
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
    x = (((cursor_x - this.renderer.offset_x)  * .25) - 10)
    y = ((cursor_y - this.renderer.offset_y) - 100) * this.renderer.zoom


    return {
        x: Math.round((x / tile_height) + (y / tile_width))
        y: Math.round((y / tile_width) - (x / tile_height))
    }

  show_cursor: (x,y) ->

    tile_width = this.renderer.tile_width
    tile_height = this.renderer.tile_height

    ix = x * tile_width - (y * tile_width)
    iy = y * tile_height + (x * tile_height)

    height = this.world.map[x][y].get_vertical_offset()

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

    $(control_surface).mousedown (event) =>
      this.select = this.translate(event.offsetX, event.offsetY)

    $(control_surface).mouseup (event) =>

      cursor = this.translate(event.offsetX, event.offsetY)

      if this.select
        start = this.select
        end = cursor
      else
        start = cursor
        end = cursor

      new window.Command(this.world, start, end, mouse_x = event.pageX, mouse_y = event.pageY)

      this.select = null

