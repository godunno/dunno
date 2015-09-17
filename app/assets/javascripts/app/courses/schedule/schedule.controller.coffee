ScheduleCtrl = (
  $scope,
  $state,
  ModalFactory,
  AnalyticsTracker,
  WeeklySchedule,
  Utils) ->

  $scope.update = ->
    $scope.$emit('wholePageLoading', $scope.course.update().then ->
      $state.go('^', null, reload: true)
    )

  $scope.transferWeeklySchedule = (weeklySchedule) ->
    new ModalFactory
      templateUrl: 'courses/schedule/schedule-transfer',
      controller: 'TransferWeeklyScheduleCtrl'
      resolve:
        weeklySchedule: -> angular.copy(weeklySchedule)
    .activate()

  $scope.newWeeklySchedule = ->
    new ModalFactory
      templateUrl: 'courses/schedule/schedule-new',
      controller: 'NewWeeklyScheduleCtrl'
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