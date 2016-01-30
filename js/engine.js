// Generated by CoffeeScript 1.10.0
(function() {
  window.Engine = (function() {
    Engine.prototype.world = null;

    Engine.prototype.control = null;

    Engine.prototype.render = null;

    Engine.prototype.content = null;

    Engine.prototype.context = null;

    function Engine() {
      this.content = new Content(window.RESOURCES);
      this.world = new window.World(250, 250, 29399);
      this.render = new window.Render(this.world, this.content);
      this.control = new window.Control(this.world, this.content, this.render);
    }

    Engine.prototype.start = function() {
      this.world.generate();
      this.world.populate();
      this.render.resize();
      return this.content.load((function(_this) {
        return function() {
          var render_frame, task_queue_delay, world_cycle_delay;
          _this.control.init();
          _this.world.add_item(new window.House(_this.world, Math.round(_this.world.width / 2), Math.round(_this.world.height / 2)));
          _this.render.update();
          task_queue_delay = 0;
          world_cycle_delay = 0;
          render_frame = function() {
            _this.render.update_map();
            _this.render.update_fx();
            return requestAnimationFrame(render_frame);
          };
          render_frame();
          return setInterval(function() {
            var actor, i, len, ref;
            task_queue_delay = task_queue_delay + 1;
            if (task_queue_delay > 10) {
              task_queue_delay = 0;
              _this.distribute_tasks();
            }
            ref = _this.world.actor_queue;
            for (i = 0, len = ref.length; i < len; i++) {
              actor = ref[i];
              actor.act();
            }
            world_cycle_delay = world_cycle_delay + 1;
            if (world_cycle_delay > 10) {
              world_cycle_delay = 0;
              return _this.world.cycle();
            }
          }, 100);
        };
      })(this));
    };

    Engine.prototype.load_test_world = function() {
      var i, j, x, y;
      for (x = i = 1; i <= 10; x = ++i) {
        for (y = j = 1; j <= 10; y = ++j) {
          this.world.items[5 + x][5 + y] = null;
          this.world.height_map[5 + x][5 + y] = 1;
        }
      }
      this.world.add_item(new window.House(this.world, 10, 12));
      this.world.add_item(new window.Wood(this.world, 15, 11, 10));
      return this.world.changed = true;
    };

    Engine.prototype.distribute_tasks = function() {
      var i, idle_workers, j, len, len1, ref, ref1, task, worker;
      idle_workers = [];
      ref = this.world.actor_queue;
      for (i = 0, len = ref.length; i < len; i++) {
        worker = ref[i];
        if (worker.tasks.length === 0) {
          idle_workers.push(worker);
        }
      }
      ref1 = this.world.task_queue;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        task = ref1[j];
        if (task.assigned !== null) {
          continue;
        }
        if (!task.is_executable()) {
          continue;
        }
        worker = idle_workers.pop();
        if (!worker) {
          return;
        }
        worker.start(task);
      }
    };

    return Engine;

  })();

}).call(this);

//# sourceMappingURL=engine.js.map
