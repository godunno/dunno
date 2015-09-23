ScheduleCtrl = (
  $scope,
  $state,
  ModalFactory,
  AnalyticsTracker,
  WeeklySchedule,
  Utils) ->

  $scope.transferWeeklySchedule = (weeklySchedule) ->
    new ModalFactory
      templateUrl: 'courses/schedule/schedule-transfer'
      controller: 'TransferWeeklyScheduleCtrl'
      class: 'small edit__schedule'
      resolve:
        weeklySchedule: -> angular.copy(weeklySchedule)
    .activate()

  $scope.newWeeklySchedule = ->
    new ModalFactory
      templateUrl: 'courses/schedule/schedule-new'
      controller: 'NewWeeklyScheduleCtrl'
      class: 'small new__schedule'
      resolve:
        weeklySchedule: -> angular.copy(new WeeklySchedule(course_id: $scope.course.uuid))
    .activate()

  $scope.removeWeeklySchedule = (weeklySchedule) ->
    if confirm('Deseja remover esse horário?')
      weeklySchedule.remove().then ->
        AnalyticsTracker.scheduleRemoved(weeklySchedule)
        Utils.remove($scope.course.weekly_schedules, weeklySchedule)

ScheduleCtrl.$inject = [
  '$scope',
  '$state',
  'ModalFactory',
  'AnalyticsTracker',
  'WeeklySchedule',
  'Utils']

angular
  .module('app.courses')
  .controller('ScheduleCtrl', ScheduleCtrl)
