// Generated by CoffeeScript 1.10.0
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.PileTask = (function(superClass) {
    extend(PileTask, superClass);

    function PileTask() {
      return PileTask.__super__.constructor.apply(this, arguments);
    }

    PileTask.prototype.is_executable = function() {
      if (this.world.items[this.x][this.y] && this.world.items[this.x][this.y].count <= 10) {
        return false;
      }
      if (!this.world.find_item(this.x, this.y, this.options.material, false)) {
        return false;
      }
      return true;
    };

    PileTask.prototype.execute = function() {
      return new window.Fetch(this.world, this.x, this.y, this.options.material, false);
    };

    return PileTask;

  })(window.Task);

}).call(this);

//# sourceMappingURL=pile.js.map
