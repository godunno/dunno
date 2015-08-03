DunnoApp = angular.module('DunnoApp')

TransferWeeklyScheduleCtrl = ($scope, $state, $modalInstance, weeklySchedule) ->
  $scope.originalWeeklySchedule = weeklySchedule
  $scope.editingWeeklySchedule = angular.copy weeklySchedule

  $scope.transfer = (weeklySchedule) ->
    $scope.$emit('wholePageLoading', weeklySchedule.transfer().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

TransferWeeklyScheduleCtrl.$inject = ['$scope', '$state', '$modalInstance', 'weeklySchedule']
DunnoApp.controller 'TransferWeeklyScheduleCtrl', TransferWeeklyScheduleCtrl
