// Generated by CoffeeScript 1.9.2
(function() {
  window.Actor = (function() {
    Actor.prototype.id = null;

    Actor.prototype.tasks = null;

    Actor.prototype.target_x = null;

    Actor.prototype.target_y = null;

    Actor.prototype.carry = null;

    Actor.prototype.path = null;

    Actor.prototype.tile_offset_x = null;

    Actor.prototype.tile_offset_y = null;

    function Actor(world, x, y) {
      this.world = world;
      this.x = x;
      this.y = y;
      this.target_x = x;
      this.target_y = y;
      this.tasks = [];
      this.tile_offset_x = Math.random() * 10 - 20;
      this.tile_offset_y = Math.random() * 10 - 20;
      this.id = this.world.get_id();
    }

    Actor.prototype.act = function() {};

    Actor.prototype.find_path = function(target_x, target_y) {
      var end, graph, options, start;
      graph = new Graph(this.world.get_access_map());
      start = graph.nodes[this.x][this.y];
      end = graph.nodes[target_x][target_y];
      options = {
        diagonal: true,
        closest: true,
        heuristic: astar.diagonal
      };
      return astar.search(graph.nodes, start, end, options);
    };

    Actor.prototype.move = function() {
      var moved, node, offset_x, offset_y;
      if (!this.path) {
        this.path = this.find_path(this.target_x, this.target_y);
        if (!this.path || this.path.length === 0) {
          offset_x = Math.round((Math.random() * 1) - 2);
          offset_y = Math.round((Math.random() * 1) - 2);
          this.path = this.find_path(this.target_x + offset_x, this.target_y + offset_y);
        }
      }
      node = this.path.shift();
      if (!node) {
        this.path = null;
        return;
      }
      moved = this.world.move_actor(this, node.x, node.y);
      if (!moved) {
        return this.path = null;
      }
    };

    Actor.prototype.goto = function(place) {
      if (!place) {
        return false;
      }
      this.target_x = place.x;
      this.target_y = place.y;
      return true;
    };

    Actor.prototype.pickup = function(item) {
      if (item.count > 1) {
        item.count = item.count - 1;
        item = new item.constructor(this.world, this.x, this.y);
      } else {
        this.world.remove_item(item);
      }
      return this.carry = item;
    };

    Actor.prototype.drop = function() {
      this.carry.x = this.x;
      this.carry.y = this.y;
      if (this.world.item_at(this) && this.world.item_at(this).constructor === this.carry.constructor) {
        this.world.item_at(this).count = this.world.item_at(this).count + 1;
      } else {
        this.world.add_item(this.carry);
      }
      this.carry = null;
      if (this.world.task[this.x][this.y] instanceof window.PileTask) {
        return this.world.items[this.x][this.y].in_pile = true;
      } else {
        return this.world.items[this.x][this.y].in_pile = false;
      }
    };

    Actor.prototype.die = function() {
      if (this.carry) {
        this.drop();
      }
      return this.world.remove_actor(this);
    };

    return Actor;

  })();

}).call(this);

//# sourceMappingURL=actors.js.map
