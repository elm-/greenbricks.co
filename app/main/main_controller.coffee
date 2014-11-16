angular.module 'greenbricks-main',['ngRoute']

  .config ($routeProvider) ->
    $routeProvider
      .when '/main',
        templateUrl: 'main/main.html'
        controller: 'MainCtrl'
      .when '/',
        templateUrl: 'main/landing.html'
        controller: 'LandingCtrl'
  .controller "LandingCtrl", ($scope, $location) ->
    $scope.address = null


    $scope.start = ->
      return unless $scope.address

      $location.path("/main").search(address: $scope.address)

  .controller 'MainCtrl', ($scope, $routeParams) ->
    solarRates =
      house:  600
      rowHouse: 400
      cornerHouse: 400
      flat: 150

    insulationRates =
      wall:
        house:  800
        rowHouse: 250
        cornerHouse: 500
        flat: 150
      roof:
        house:  850
        rowHouse: 650
        cornerHouse: 650
        flat: 650
      floor:
        house:  300
        rowHouse: 150
        cornerHouse: 225
        flat: 150

    doubleWindowsRates =
      house:  600
      rowHouse: 300
      cornerHouse: 450
      flat: 200


    co2RateInsulation = 2.738462
    co2RateWindows = 2.738462
    co2RateSolar = 2.46


    $scope.homeTypes = [
      value: "house"
      label: "House"
    ,
      value: "rowHouse"
      label: "Town House"
    ,
      value: "cornerHouse"
      label: "Corner House"
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

    $scope.calcModel =
      home: "house"
      size: "one"
      year: 1960
      installations:
        insulation:
          wall: false
          floor: false
          roof: false
        power:
          solar: false
        windows:
          double: false

    $scope.totalCo2Sum = -> $scope.solarSum * co2RateSolar + $scope.insulationSum * co2RateInsulation + $scope.doubleWindowsSum * co2RateWindows
    $scope.totalCo2SumFormatted = -> Math.round($scope.totalCo2Sum() / 1000)

    $scope.totalSum = -> $scope.solarSum + $scope.insulationSum + $scope.doubleWindowsSum
    $scope.totalSumFormatted = -> Math.round($scope.totalSum() / 1000)
    $scope.solarSum = 0
    $scope.insulationSum = 0
    $scope.doubleWindowsSum = 0

    $scope.address = $routeParams.address

    $scope.$watch "calcModel", (newValue, oldValue) ->
      $scope.calculateChartResults()
    , true

    $scope.$watch "calcModel.year", (newValue, oldValue) ->
      $scope.calcModel.installations.insulation.wall = false
      $scope.calcModel.installations.insulation.floor = false
      $scope.calcModel.installations.insulation.roof = false
      $scope.calcModel.installations.power.solar = false
      $scope.calcModel.installations.windows.double = false
      if ($scope.calcModel.year >= 1970)
        $scope.calcModel.installations.insulation.wall = true
        $scope.calcModel.installations.insulation.roof = true
      if ($scope.calcModel.year >= 1990)
        $scope.calcModel.installations.windows.double = true
      if ($scope.calcModel.year >= 2010)
        $scope.calcModel.installations.power.solar = true



    $scope.calculateChartResults = ->
      calcYearly = (rate, years, yearlyEffects = 0.03) ->
        sum = 0
        for i in [1..years]
          sum += rate
          sum = sum * (1 + yearlyEffects)
        sum

      $scope.solarSum = 0
      $scope.insulationSum = 0
      $scope.doubleWindowsSum = 0

      series = []
      if not $scope.calcModel.installations.power.solar
        $scope.solarSum = calcYearly(solarRates[$scope.calcModel.home], 25)
        series.push
          name: "Solar"
          data: [1..25].map((v) -> calcYearly(solarRates[$scope.calcModel.home], v))
          color: "#f39c12"
      if not $scope.calcModel.installations.insulation.wall or not $scope.calcModel.installations.insulation.floor or not $scope.calcModel.installations.insulation.roof
        insulationTypes = ["wall", "floor", "roof"]
        for insType in insulationTypes
          if not $scope.calcModel.installations.insulation[insType]
            $scope.insulationSum += calcYearly(insulationRates[insType][$scope.calcModel.home], 25)
        series.push
          name: "Insulation"
          data: [1..25].map((v) ->
            sum = 0
            for insType in insulationTypes
              if not $scope.calcModel.installations.insulation[insType]
                sum = sum + calcYearly(insulationRates[insType][$scope.calcModel.home], v)
            sum
          )
          color: "#c0392b"
      if not $scope.calcModel.installations.windows.double
        $scope.doubleWindowsSum = calcYearly(doubleWindowsRates[$scope.calcModel.home], 25)
        series.push
          name: "Double Windows"
          data: [1..25].map((v) -> calcYearly(doubleWindowsRates[$scope.calcModel.home], v))
          color: "#16a085"

      $scope.calcResultChart.series = series

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
          text: "Savings Analysis"
        plotOptions:
          area:
            stacking: "normal"
        xAxis:
          labels:
            formatter: ->
              if @value % 5 == 0
                "#{@value} yrs"
              else
                null
        yAxis:
          title:
            text: "Savings in €"
          min: 0
          gridLineColor: "#CCC"

      series: []
