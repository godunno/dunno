DunnoApp = angular.module('DunnoApp')

TransferWeeklyScheduleCtrl = ($scope, $state, $modalInstance, TimeGetterSetter, weeklySchedule) ->
  $scope.originalWeeklySchedule = weeklySchedule
  $scope.weeklySchedule = angular.copy(weeklySchedule)

  $scope.startTime = TimeGetterSetter.generate($scope.weeklySchedule, 'start_time')
  $scope.endTime = TimeGetterSetter.generate($scope.weeklySchedule, 'end_time')

  $scope.submit = (weeklySchedule) ->
    $scope.$emit('wholePageLoading', weeklySchedule.transfer().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

  $scope.close = -> $modalInstance.close()

TransferWeeklyScheduleCtrl.$inject = ['$scope', '$state', '$modalInstance', 'TimeGetterSetter', 'weeklySchedule']
DunnoApp.controller 'TransferWeeklyScheduleCtrl', TransferWeeklyScheduleCtrl
