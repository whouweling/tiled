




class window.Command

  el: "#context-menu"

  constructor: (world, start, end, mouse_x, mouse_y) ->

    this.world = world
    this.start = start
    this.end = end
    this.mouse_x = mouse_x
    this.mouse_y = mouse_y

    this.render()
    this.bind()

  events:
    "click a.action-select-task": (event) ->
      index = $(event.target).attr("data-index")
      selected_task_type = window.TASK_TYPES[index]

      for x in [ this.start.x .. this.end.x ]
          for y in [ this.start.y .. this.end.y ]
            this.world.add_task(new selected_task_type.task(this.world, x, y, selected_task_type.options))

      this.close()

    "click a.action-clear-task": (event) ->
      index = $(event.target).attr("data-index")
      selected_task_type = window.TASK_TYPES[index]

      for x in [ this.start.x .. this.end.x ]
          for y in [ this.start.y .. this.end.y ]
            this.world.remove_task_on(x, y)

      this.close()

    "click a.action-close": (event) ->
      this.close()

  close: ->
    this.unbind()
    $(this.el).hide()

  bind: ->
    $.each this.events, (event, callback) =>
      [ event_type, element ] = event.split(" ")
      $(this.el).on event_type, element, (event) =>
        event.preventDefault()
        callback.call(this, event)

  unbind: ->
    for selector, _ of this.events
      $(this.el).unbind selector

  render: ->

      window.template_loader.get "ui/task/set.html", (template) =>

        $(this.el).html template(task_types: window.TASK_TYPES)

        $(this.el).css("top", this.mouse_y - 100)
        $(this.el).css("left", this.mouse_x)

        $(this.el).show()



