


class window.Plant extends window.Object

   constructor: (world, x, y) ->
     super(world, x, y)
     this.grown = this.grow_delay


   cycle: ->
     if this.grown < this.grow_delay
       this.grown = this.grown + 1

   get_product: ->
     this.grown = 0

   has_product: ->
     if this.grown < this.grow_delay
       return false
     return true


