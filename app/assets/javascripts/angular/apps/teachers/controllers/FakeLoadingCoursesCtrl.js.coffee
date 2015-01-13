DunnoApp = angular.module('DunnoApp')

FakeLoadingCoursesCtrl = ($scope, $timeout, Course)->
  $scope.state = 'INITIAL'
  interval = -> $scope.maxTime / $scope.items.length * 1000

  loadNextItem = ->
    if $scope.currentItemIndex + 1 < $scope.items.length
      index = ++$scope.currentItemIndex + 1
      percentage = 100.0 / $scope.items.length * index
      $scope.$broadcast("progress.setValue", "#{percentage}%")
      $timeout(loadNextItem, interval())
    else
      $scope.$broadcast("progress.stop")
      $scope.state = 'LOADED'

  Course.query().then (response)->
    $scope.items = response.map (item)-> item.name
    $scope.maxTime = $scope.items.length
    $scope.currentItemIndex = -1
    $scope.state = 'LOADING'
    $scope.$broadcast("progress.start")
    loadNextItem()

  $scope.currentItem = -> $scope.items[$scope.currentItemIndex]

FakeLoadingCoursesCtrl.$inject = ['$scope', '$timeout', 'Course']
DunnoApp.controller 'FakeLoadingCoursesCtrl', FakeLoadingCoursesCtrl
