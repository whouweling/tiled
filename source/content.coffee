
class window.Content

  images: {}

  constructor: (resources) ->
    this.resources = resources


  load: (done) ->

      loadedImages = 0

      for name in this.resources

        console.log "Loading", name

        this.images[name] = []

        for i in [ 1 .. 10 ]
          this.images[name][i] = new Image()

          this.images[name][i].onload = =>

            if ++loadedImages >= (this.resources.length*10)
              done()

          this.images[name][i].src = "res/gen/" + name + "-" + i + ".png"


