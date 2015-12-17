

class window.HarvestTest extends window.EngineTest

  execute: ->


    this.world.items[10][10] = new Wheat(this.world, 10, 10)

    this.world.add_task(new window.GatherTask(this.world, 10, 10, { abbr: "H" }))

    this.world.add_item(new window.House(this.world, 8, 10))
