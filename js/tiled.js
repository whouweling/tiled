// Generated by CoffeeScript 1.10.0
(function() {
  window.RESOURCES = ["tiles"];

  window.TASK_TYPES = [
    {
      label: "Harvest",
      task: window.GatherTask,
      options: {
        abbr: "H",
        work: 20
      }
    }, {
      label: "Material pile",
      task: window.PileTask,
      options: {
        material: window.Wood,
        abbr: "M"
      }
    }, {
      label: "Food pile",
      task: window.PileTask,
      options: {
        material: window.Grain,
        abbr: "F"
      }
    }, {
      label: "Plant",
      task: window.PlantTask,
      options: {
        material: window.Grain,
        result: window.Wheat,
        abbr: "P",
        work: 10
      }
    }, {
      label: "Build house",
      task: window.BuildTask,
      options: {
        needs: [
          {
            material: window.Wood,
            count: 5
          }
        ],
        result: window.House,
        abbr: "H",
        work: 100
      }
    }
  ];

  $(document).ready((function(_this) {
    return function() {
      var engine;
      engine = new window.Engine();
      return engine.start();
    };
  })(this));

}).call(this);

//# sourceMappingURL=tiled.js.map
