DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'progressBarCtrl', ($scope) ->
  TRANSITION_END_EVENTS = "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd"

  $scope.start = ->
    $scope.progress.show()

  $scope.stop = ->
    if $scope.isAnimating
      $scope.meter.on TRANSITION_END_EVENTS, $scope.stop
    else
      $scope.progress.hide()
      $scope.meter.width("0%")

  $scope.setValue = ($event, value) ->
    $scope.meter.width(value)
    $scope.isAnimating = true
    $scope.meter.on TRANSITION_END_EVENTS, -> $scope.isAnimating = false

  $scope.$on "progress.start", $scope.start
  $scope.$on "progress.setValue", $scope.setValue
  $scope.$on "progress.stop", $scope.stop


DunnoApp.directive 'progressBar', ->
  restrict: 'E'
  replace: true
  controller: 'progressBarCtrl'
  scope: true
  link: (scope, element, attrs) ->
    scope.progress = element
    scope.meter = element.find(".meter")
    scope.stop()
  template: '
    <div class="progress">
      <span class="meter"></span>
    </div>
  '

