// Generated by CoffeeScript 1.10.0
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.Plant = (function(superClass) {
    extend(Plant, superClass);

    function Plant(world, x, y) {
      Plant.__super__.constructor.call(this, world, x, y);
      this.grown = this.grow_delay;
    }

    Plant.prototype.cycle = function() {
      if (this.grown < this.grow_delay) {
        return this.grown = this.grown + 1;
      }
    };

    Plant.prototype.get_product = function() {
      return this.grown = 0;
    };

    Plant.prototype.has_product = function() {
      if (this.grown < this.grow_delay) {
        return false;
      }
      return true;
    };

    return Plant;

  })(window.Object);

}).call(this);

//# sourceMappingURL=plant.js.map
