angular.module "greenbricks", [
 "ngRoute"
 "greenbricks-main"
 "templates"
 "highcharts-ng"
]
  .config ($routeProvider) ->
    $routeProvider
      .otherwise
        redirectTo: "/"