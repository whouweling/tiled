// Generated by CoffeeScript 1.9.2
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.Wheat = (function(superClass) {
    extend(Wheat, superClass);

    function Wheat() {
      return Wheat.__super__.constructor.apply(this, arguments);
    }

    Wheat.prototype.name = "wheat";

    Wheat.prototype.grow_delay = 10;

    Wheat.prototype.get_product = function() {
      Wheat.__super__.get_product.call(this);
      return window.Grain;
    };

    Wheat.prototype.get_tile = function() {
      if (this.grown === this.grow_delay) {
        return 9;
      } else {
        return 10;
      }
    };

    return Wheat;

  })(window.Plant);

}).call(this);

//# sourceMappingURL=wheat.js.map