angular.module("greenbricks", ["ngRoute", "greenbricks-main", "templates", "highcharts-ng"]).config(function($routeProvider) {
  return $routeProvider.otherwise({
    redirectTo: "/"
  });
});



angular.module('greenbricks-main', ['ngRoute']).config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: 'main/main.html',
    controller: 'MainCtrl'
  });
}).controller('MainCtrl', function($scope) {
  $scope.homeTypes = [
    {
      value: "house",
      label: "House"
    }, {
      value: "rowHouse",
      label: "Row House"
    }, {
      value: "flat",
      label: "Flat"
    }
  ];
  $scope.sizeTypes = [
    {
      value: "one",
      label: "House"
    }, {
      value: "two",
      label: "Couple"
    }, {
      value: "three",
      label: "Family with Kid"
    }, {
      value: "four",
      label: "Family Two Kids"
    }
  ];
  $scope.yearTypes = [
    {
      value: "old",
      label: "1930"
    }, {
      value: "fair",
      label: "1970"
    }, {
      value: "insulated",
      label: "1980"
    }, {
      value: "modern",
      label: "2000"
    }
  ];
  $scope.windowTypes = [
    {
      value: "single",
      label: "Normal"
    }, {
      value: "double",
      label: "Double Frame"
    }, {
      value: "triple",
      label: "Triple Glass"
    }
  ];
  $scope.calcModel = {
    home: "house",
    size: "one",
    year: "old",
    installations: {
      insulation: {
        wall: true,
        floor: true,
        ceiling: false
      },
      power: {
        solar: true
      },
      windows: "single"
    }
  };
  $scope.$watch("calcModel", function(newValue, oldValue) {
    $scope.calculateChartResult();
    return console.log("foo");
  }, true);
  $scope.calculateChartResult = function() {
    return $scope.calcResultChart.series = [
      {
        name: "Solar",
        data: [8, 7, 6, 5, 4, 3, 2, 1].map(function(v) {
          return v - Math.random() * 2;
        }),
        color: "#7cb5ec"
      }, {
        name: "Insulation",
        data: [8, 7, 6, 5, 4, 3, 2, 1].map(function(v) {
          return v / 1.5 - Math.random() * 2;
        }),
        color: "#434348"
      }, {
        name: "LED Lighting",
        data: [8, 7, 6, 5, 4, 3, 2, 1].map(function(v) {
          return v / 2 - Math.random();
        }),
        color: "#90ed7d"
      }
    ];
  };
  $scope.savingsChart = {
    options: {
      chart: {
        type: "column"
      },
      title: {
        text: "Overall Savings"
      },
      xAxis: {
        labels: {
          enabled: false,
          minorGridLineWidth: 0,
          minorTickLength: 0
        }
      },
      yAxis: {
        labels: {
          enabled: false,
          minorGridLineWidth: 0,
          minorTickLength: 0
        }
      }
    },
    size: {
      height: 200
    },
    series: [
      {
        name: "Today",
        data: [40],
        color: "#b4512e"
      }, {
        name: "Future",
        data: [20],
        color: "#77ab14"
      }
    ]
  };
  return $scope.calcResultChart = {
    options: {
      chart: {
        type: "area"
      },
      title: {
        text: "Environmental Analysis"
      },
      plotOptions: {
        area: {
          stacking: "normal"
        }
      },
      xAxis: {
        labels: {
          formatter: function() {
            if (this.value % 2 === 0) {
              return "" + this.value + " yrs";
            } else {
              return null;
            }
          }
        }
      },
      yAxis: {
        title: {
          text: "Savings in €"
        },
        min: 0
      }
    },
    series: [{}, {}]
  };
});
