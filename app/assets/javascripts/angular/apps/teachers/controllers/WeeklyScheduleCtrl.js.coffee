DunnoApp = angular.module('DunnoApp')

WeeklyScheduleCtrl = ($scope, $state, $modalInstance, weeklySchedule) ->
  $scope.weeklySchedule = weeklySchedule

  $scope.save = (weeklySchedule) ->
    $scope.$emit('wholePageLoading', weeklySchedule.save().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

WeeklyScheduleCtrl.$inject = ['$scope', '$state', '$modalInstance', 'weeklySchedule']
DunnoApp.controller 'WeeklyScheduleCtrl', WeeklyScheduleCtrl
