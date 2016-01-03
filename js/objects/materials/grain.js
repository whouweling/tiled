// Generated by CoffeeScript 1.10.0
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.Grain = (function(superClass) {
    extend(Grain, superClass);

    function Grain() {
      return Grain.__super__.constructor.apply(this, arguments);
    }

    Grain.prototype.name = "grain";

    Grain.prototype.get_tile = function() {
      return 11;
    };

    Grain.prototype.get_planted = function() {
      return window.Wheat;
    };

    return Grain;

  })(window.Food);

}).call(this);

//# sourceMappingURL=grain.js.map
