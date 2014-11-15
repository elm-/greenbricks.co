angular.module 'greenbricks', [ 'ngRoute','greenbricks-main','templates' ]
  
  .config ($routeProvider) ->

    $routeProvider
      .otherwise
        redirectTo: '/'