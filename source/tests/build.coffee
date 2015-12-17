
class window.BuildTest extends window.EngineTest

  execute: ->


    options =
        needs: [
          { material: window.Wood, count: 3 }
        ]
        result: window.House
        abbr: "H"

    this.world.add_task(new window.BuildTask(this.world, 8, 7, options))

    this.world.add_item(new window.House(this.world, 8, 10))

    for i in [ 1 .. 10 ]
      this.world.add_item(new window.Wood(this.world, 11, 6+i))
