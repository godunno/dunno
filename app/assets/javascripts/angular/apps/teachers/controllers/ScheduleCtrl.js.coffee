DunnoApp = angular.module('DunnoApp')

ScheduleCtrl = ($scope, $state) ->
  $scope.update = ->
    $scope.$emit('wholePageLoading', $scope.course.update().then ->
      $state.go('^', null, reload: true)
    )

ScheduleCtrl.$inject = ['$scope', '$state']
DunnoApp.controller 'ScheduleCtrl', ScheduleCtrl
