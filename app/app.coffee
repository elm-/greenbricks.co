angular.module "greenbricks", [
 "ngRoute"
 "greenbricks-main"
 "templates"
 "highcharts-ng"
 "ui.slider"
]
  .config ($routeProvider) ->
    $routeProvider
      .otherwise
        redirectTo: "/"