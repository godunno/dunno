DunnoApp = angular.module('DunnoApp')

NewWeeklyScheduleCtrl = (
  $scope,
  $state,
  $modalInstance,
  $filter,
  TimeGetterSetter,
  weeklySchedule
) ->

  $scope.formButton = "Adicionar"
  $scope.weeklySchedule = weeklySchedule

  $scope.startTime = TimeGetterSetter.generate(weeklySchedule, 'start_time')
  $scope.endTime = TimeGetterSetter.generate(weeklySchedule, 'end_time')
  $scope.weeklySchedule.weekday = $scope.startTime().getDay()

  # TODO: Extract to a service
  setInterval = (newStartTime) ->
    newEndTime = moment(newStartTime).add(1, 'hour').toDate()
    $scope.endTime(newEndTime)
  $scope.$watch('startTime()', setInterval, true)

  $scope.submit = (weeklySchedule) ->
    $scope.$emit('wholePageLoading', weeklySchedule.save().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

  $scope.close = -> $modalInstance.close()

NewWeeklyScheduleCtrl.$inject = [
  '$scope',
  '$state',
  '$modalInstance','$filter',
  'TimeGetterSetter',
  'weeklySchedule'
]
DunnoApp.controller 'NewWeeklyScheduleCtrl', NewWeeklyScheduleCtrl
