TransferWeeklyScheduleCtrl = (
  $scope,
  $state,
  modalInstance,
  AnalyticsTracker,
  TimeGetterSetter,
  PageLoading,
  weeklySchedule) ->

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

  addHour = (time) ->
    moment(time).add(1, 'hour').toDate()

  setEndTimeDuration = (newStartTime, oldStartTime) ->
    $scope.endTime(addHour(newStartTime)) if newStartTime != oldStartTime

  $scope.$watch('startTime()', setEndTimeDuration, true)

  success = ->
    modalInstance.destroy()
    AnalyticsTracker.scheduleEdited($scope.weeklySchedule)
    $state.go('.', null, reload: true)

  $scope.submit = (weeklySchedule) ->
    $scope.submitting = PageLoading.resolve weeklySchedule.transfer().then(success)

TransferWeeklyScheduleCtrl.$inject = [
  '$scope',
  '$state',
  'modalInstance',
  'AnalyticsTracker',
  'TimeGetterSetter',
  'PageLoading',
  'weeklySchedule'
]

angular
  .module('app.courses')
  .controller('TransferWeeklyScheduleCtrl', TransferWeeklyScheduleCtrl)
