DunnoApp = angular.module('DunnoApp')

FakeLoadingCoursesCtrl = ($scope, $timeout, $window, Course)->
  iterationsLimit = 1
  maxTime = 2
  interval = -> maxTime / iterationsLimit * 1000

  finish = ->
    $scope.$broadcast("progress.stop")
    $scope.loading = false
    $window.location.href = "/dashboard#courses?first_access=true"

  loadNextItem = ->
    if $scope.currentItemIndex + 1 < iterationsLimit
      index = ++$scope.currentItemIndex + 1
      percentage = 100.0 / iterationsLimit * index
      $scope.$broadcast("progress.setValue", "#{percentage}%")
      $timeout(loadNextItem, interval())
    else
      finish()

  Course.query().then (response)->
    $scope.items = response.map (item)-> item.name
    maxTime = $scope.items.length if $scope.items.length > maxTime
    iterationsLimit = $scope.items.length if $scope.items.length > iterationsLimit
    $scope.currentItemIndex = -1
    $scope.loading = true
    $scope.$broadcast("progress.start")
    loadNextItem()

  $scope.currentItem = -> $scope.items[$scope.currentItemIndex]

FakeLoadingCoursesCtrl.$inject = ['$scope', '$timeout', '$window', 'Course']
DunnoApp.controller 'FakeLoadingCoursesCtrl', FakeLoadingCoursesCtrl
