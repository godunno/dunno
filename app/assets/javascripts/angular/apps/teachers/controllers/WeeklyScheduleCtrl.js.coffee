DunnoApp = angular.module('DunnoApp')

WeeklyScheduleCtrl = ($scope, $state, $modalInstance, $filter, TimeGetterSetter, weeklySchedule) ->
  $scope.weeklySchedule = weeklySchedule

  $scope.startTime = TimeGetterSetter.generate(weeklySchedule, 'start_time')
  $scope.endTime = TimeGetterSetter.generate(weeklySchedule, 'end_time')

  $scope.submit = (weeklySchedule) ->
    $scope.$emit('wholePageLoading', weeklySchedule.save().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

WeeklyScheduleCtrl.$inject = ['$scope', '$state', '$modalInstance','$filter', 'TimeGetterSetter', 'weeklySchedule']
DunnoApp.controller 'WeeklyScheduleCtrl', WeeklyScheduleCtrl
