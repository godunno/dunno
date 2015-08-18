DunnoApp = angular.module('DunnoApp')

TransferWeeklyScheduleCtrl = ($scope, $state, $modalInstance, TimeGetterSetter, PageLoading, weeklySchedule) ->
  $scope.formButton = "Transferir"
  $scope.originalWeeklySchedule = weeklySchedule
  $scope.weeklySchedule = angular.copy(weeklySchedule)

  $scope.startTime = TimeGetterSetter.generate($scope.weeklySchedule, 'start_time')
  $scope.endTime = TimeGetterSetter.generate($scope.weeklySchedule, 'end_time')

  success = (affected_events) ->
    $modalInstance.close()
    alert "Aulas afetadas: #{affected_events}"
    $state.go('.', null, reload: true)

  $scope.submit = (weeklySchedule) ->
    PageLoading.resolve weeklySchedule.transfer().then(success)

  $scope.close = -> $modalInstance.close()

TransferWeeklyScheduleCtrl.$inject = ['$scope', '$state', '$modalInstance', 'TimeGetterSetter', 'PageLoading', 'weeklySchedule']
DunnoApp.controller 'TransferWeeklyScheduleCtrl', TransferWeeklyScheduleCtrl
