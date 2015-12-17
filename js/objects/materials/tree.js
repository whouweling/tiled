// Generated by CoffeeScript 1.9.2
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.Tree = (function(superClass) {
    extend(Tree, superClass);

    function Tree() {
      return Tree.__super__.constructor.apply(this, arguments);
    }

    Tree.prototype.name = "tree";

    Tree.prototype.grow_delay = 1000;

    Tree.prototype.get_product = function() {
      Tree.__super__.get_product.call(this);
      return window.Wood;
    };

    Tree.prototype.get_tile = function() {
      if (this.grown === this.grow_delay) {
        return 4;
      } else {
        return 5;
      }
    };

    return Tree;

  })(window.Plant);

}).call(this);

//# sourceMappingURL=tree.js.map
