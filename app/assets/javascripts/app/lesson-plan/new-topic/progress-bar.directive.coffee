progressBarCtrl = ($scope) ->
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

progressBarCtrl.$inject = ['$scope']

link = (scope, element, attrs) ->
  scope.progress = element
  scope.meter = element.find(".progress__meter")
  scope.stop()

progressBar = ->
  link: link
  restrict: 'E'
  replace: true
  controller: progressBarCtrl
  scope: true
  template: '
    <div class="progress success round">
      <span class="progress__meter meter"></span>
    </div>
  '

angular
  .module('app.lessonPlan')
  .directive('progressBar', progressBar)
