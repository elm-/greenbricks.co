angular.module 'greenbricks-main',['ngRoute']

  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'main/main.html'
        controller: 'MainCtrl'

  .controller 'MainCtrl', ($scope) ->
    $scope.homeTypes = [
      value: "house"
      label: "House"
    ,
      value: "rowHouse"
      label: "Row House"
    ,
      value: "flat"
      label: "Flat"
    ]
    $scope.sizeTypes = [
      value: "one"
      label: "House"
    ,
      value: "two"
      label: "Couple"
    ,
      value: "three"
      label: "Family with Kid"
    ,
      value: "four"
      label: "Family Two Kids"
    ]
    $scope.yearTypes = [
      value: "old"
      label: "1930"
    ,
      value: "fair"
      label: "1970"
    ,
      value: "insulated"
      label: "1980"
    ,
      value: "modern"
      label: "2000"
    ]

    $scope.calcModel =
      home: "house"
      size: "one"
      year: "old"
      installations:
        insulation:
          wall: true
          floor: true
          roof: false
        power:
          solar: true
        windows:
          double: false

    $scope.$watch "calcModel", (newValue, oldValue) ->
      $scope.calculateChartResult()
      console.log("foo")
    , true


    $scope.calculateChartResult = ->
      $scope.calcResultChart.series = [
        name: "Solar"
        data: [8,7,6,5,4,3,2,1].map((v) -> v - Math.random() * 2)
        color: "#f39c12"
      ,
        name: "Insulation"
        data: [8,7,6,5,4,3,2,1].map((v) -> v / 1.5 - Math.random() * 2)
        color: "#c0392b"
      ,
        name: "LED Lighting"
        data: [8,7,6,5,4,3,2,1].map((v) -> v / 2 - Math.random())
        color: "#16a085"
      ]

    $scope.savingsChart =
      options:
        chart:
          type: "column"
          backgroundColor: "#eee"
        title:
          text: "Overall Savings"
        xAxis:
          labels:
            enabled: false
            minorGridLineWidth: 0
            minorTickLength: 0
        yAxis:
          labels:
            enabled: false
            minorGridLineWidth: 0
            minorTickLength: 0
          gridLineColor: "#CCC"

      size:
        height: 200


      series: [
        name: "Today"
        data: [40]
        color: "#c0392b"
      ,
        name: "Future"
        data: [20]
        color: "#16a085"
      ]

    $scope.calcResultChart =
      options:
        chart:
          type: "area"
          backgroundColor: "#eee"
        title:
          text: "Environmental Analysis"
        plotOptions:
          area:
            stacking: "normal"
        xAxis:
          labels:
            formatter: ->
              if @value % 2 == 0
                "#{@value} yrs"
              else
                null
        yAxis:
          title:
            text: "Savings in €"
          min: 0
          gridLineColor: "#CCC"

      series: [{}, {}]
