NewWeeklyScheduleCtrl = (
  $scope,
  $state,
  modalInstance,
  $filter,
  AnalyticsTracker,
  TimeGetterSetter,
  weeklySchedule) ->

  $scope.formButton = "Adicionar"
  $scope.weeklySchedule = weeklySchedule

  $scope.startTime = TimeGetterSetter.generate(weeklySchedule, 'start_time')
  $scope.endTime = TimeGetterSetter.generate(weeklySchedule, 'end_time')
  $scope.weeklySchedule.weekday = $scope.startTime().getDay()

  # TODO: Extract to a service
  addHour = (time) ->
    moment(time).add(1, 'hour').toDate()

  setEndTimeDuration = (newStartTime) ->
    $scope.endTime(addHour(newStartTime))

  $scope.$watch('startTime()', setEndTimeDuration, true)


  $scope.submit = (weeklySchedule) ->
    $scope.$emit('wholePageLoading', weeklySchedule.save().then (weeklySchedule) ->
      modalInstance.destroy()
      AnalyticsTracker.scheduleCreated(weeklySchedule)
      $state.go('.', null, reload: true)
    )

NewWeeklyScheduleCtrl.$inject = [
  '$scope',
  '$state',
  'modalInstance',
  '$filter',
  'AnalyticsTracker',
  'TimeGetterSetter',
  'weeklySchedule'
]

angular
  .module('app.courses')
  .controller('NewWeeklyScheduleCtrl', NewWeeklyScheduleCtrl)
