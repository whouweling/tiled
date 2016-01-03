// Generated by CoffeeScript 1.10.0
(function() {
  window.Content = (function() {
    Content.prototype.images = {};

    function Content(resources) {
      this.resources = resources;
    }

    Content.prototype.load = function(done) {
      var i, j, len, loadedImages, name, ref, results;
      loadedImages = 0;
      ref = this.resources;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        console.log("Loading", name);
        this.images[name] = [];
        results.push((function() {
          var k, results1;
          results1 = [];
          for (i = k = 1; k <= 10; i = ++k) {
            this.images[name][i] = new Image();
            this.images[name][i].onload = (function(_this) {
              return function() {
                if (++loadedImages >= (_this.resources.length * 10)) {
                  return done();
                }
              };
            })(this);
            results1.push(this.images[name][i].src = "res/gen/" + name + "-" + i + ".png");
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    return Content;

  })();

}).call(this);

//# sourceMappingURL=content.js.map
