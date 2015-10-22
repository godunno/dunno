TransferWeeklyScheduleCtrl = (
  $scope,
  $state,
  modalInstance,
  AnalyticsTracker,
  TimeGetterSetter,
  PageLoading,
  weeklySchedule,
  ErrorParser
) ->
  vm = @

  vm.formButton = "Salvar"
  vm.originalWeeklySchedule = weeklySchedule
  vm.weeklySchedule = angular.copy(weeklySchedule)

  vm.startTime = TimeGetterSetter.generate(
    vm.weeklySchedule,
    'start_time'
  )

  vm.endTime = TimeGetterSetter.generate(
    vm.weeklySchedule,
    'end_time'
  )

  addHour = (time) ->
    moment(time).add(1, 'hour').toDate()

  setEndTimeDuration = (newStartTime, oldStartTime) ->
    vm.endTime(addHour(newStartTime)) if newStartTime != oldStartTime

  $scope.$watch('vm.startTime()', setEndTimeDuration, true)

  success = ->
    modalInstance.destroy()
    AnalyticsTracker.scheduleEdited(vm.weeklySchedule)
    $state.go('.', null, reload: true)

  failure = (response) ->
    ErrorParser.setErrors(response.data.errors, vm.weeklyScheduleForm, $scope)

  vm.submit = (weeklySchedule) ->
    vm.submitting = PageLoading.resolve weeklySchedule.transfer().then(success, failure)

  vm

TransferWeeklyScheduleCtrl.$inject = [
  '$scope',
  '$state',
  'modalInstance',
  'AnalyticsTracker',
  'TimeGetterSetter',
  'PageLoading',
  'weeklySchedule',
  'ErrorParser'
]

angular
  .module('app.courses')
  .controller('TransferWeeklyScheduleCtrl', TransferWeeklyScheduleCtrl)
