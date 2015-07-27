DunnoApp = angular.module('DunnoApp')

ScheduleCtrl = ($scope, $state) ->
  weekly_schedules = ({ weekday: i } for i in [0..6])
  $scope.course.weekly_schedules.forEach (weekly_schedule) ->
    weekly_schedules[weekly_schedule.weekday] = weekly_schedule
  weekly_schedules.push weekly_schedules.shift()
  $scope.weekly_schedules = weekly_schedules
  
  validateWeeklySchedule = (weeklySchedule) ->
      weeklySchedule.start_time?.length && weeklySchedule.end_time?.length

  $scope.update = ->
    $scope.course.weekly_schedules = $scope.weekly_schedules.filter validateWeeklySchedule
    $scope.$emit('wholePageLoading', $scope.course.update().then ->
      $state.go('^')
    )

ScheduleCtrl.$inject = ['$scope', '$state']
DunnoApp.controller 'ScheduleCtrl', ScheduleCtrl
