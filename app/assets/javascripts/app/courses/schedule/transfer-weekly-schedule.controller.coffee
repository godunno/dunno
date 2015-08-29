DunnoApp = angular.module('DunnoApp')

TransferWeeklyScheduleCtrl = (
  $scope,
  $state,
  $modalInstance,
  TimeGetterSetter,
  PageLoading,
  weeklySchedule
) ->
  $scope.formButton = "Salvar"
  $scope.originalWeeklySchedule = weeklySchedule
  $scope.weeklySchedule = angular.copy(weeklySchedule)

  $scope.startTime = TimeGetterSetter.generate(
    $scope.weeklySchedule,
    'start_time'
  )

  $scope.endTime = TimeGetterSetter.generate(
    $scope.weeklySchedule,
    'end_time'
  )

  # TODO: Extract to a service
  addHour = (time) ->
    moment(time).add(1, 'hour').toDate()

  setEndTimeDuration = (newStartTime, oldStartTime) ->
    $scope.endTime(addHour(newStartTime)) if newStartTime != oldStartTime

  $scope.$watch('startTime()', setEndTimeDuration, true)

  success = (affected_events) ->
    $modalInstance.close()
    #alert "Aulas afetadas: #{affected_events}"
    $state.go('.', null, reload: true)

  $scope.submit = (weeklySchedule) ->
    PageLoading.resolve weeklySchedule.transfer().then(success)

  $scope.close = -> $modalInstance.close()

TransferWeeklyScheduleCtrl.$inject = [
  '$scope',
  '$state',
  '$modalInstance',
  'TimeGetterSetter',
  'PageLoading',
  'weeklySchedule'
]
DunnoApp.controller 'TransferWeeklyScheduleCtrl', TransferWeeklyScheduleCtrl
