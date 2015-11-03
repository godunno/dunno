NewWeeklyScheduleCtrl = (
  $scope,
  $state,
  modalInstance,
  $filter,
  AnalyticsTracker,
  TimeGetterSetter,
  PageLoading,
  weeklySchedule,
  ErrorParser
) ->
  vm = @

  vm.formButton = "Adicionar"
  vm.weeklySchedule = weeklySchedule

  vm.startTime = TimeGetterSetter.generate(
    vm.weeklySchedule,
    'start_time'
  )

  vm.endTime = TimeGetterSetter.generate(
    vm.weeklySchedule,
    'end_time'
  )

  vm.weeklySchedule.weekday = vm.startTime().getDay()

  addHour = (time) ->
    moment(time).add(1, 'hour').toDate()

  setEndTimeDuration = (newStartTime) ->
    vm.endTime(addHour(newStartTime))

  $scope.$watch('vm.startTime()', setEndTimeDuration, true)

  success = (weeklySchedule) ->
    modalInstance.destroy()
    AnalyticsTracker.scheduleCreated(weeklySchedule)
    $state.go('.', $state.params, reload: true)

  failure = (response) ->
    ErrorParser.setErrors(response.data.errors, vm.weeklyScheduleForm, $scope)

  vm.submit = (weeklySchedule) ->
    vm.submitting = PageLoading.resolve weeklySchedule.save().then(success, failure)

  vm

NewWeeklyScheduleCtrl.$inject = [
  '$scope',
  '$state',
  'modalInstance',
  '$filter',
  'AnalyticsTracker',
  'TimeGetterSetter',
  'PageLoading',
  'weeklySchedule',
  'ErrorParser'
]

angular
  .module('app.courses')
  .controller('NewWeeklyScheduleCtrl', NewWeeklyScheduleCtrl)
