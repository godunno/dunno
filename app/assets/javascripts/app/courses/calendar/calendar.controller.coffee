CalendarCtrl = (
  $scope,
  $state,
  DateUtils,
  course
) ->
  angular.extend($scope, DateUtils)

  $scope.course = course

  $scope.goToEvent = (event) ->
    if $scope.course.user_role == 'teacher'
      $state.go('^.event', { startAt: event.start_at })
    else
      $state.go('^.events', until: event.start_at)

  $scope.isTeacher = (course) ->
    course.user_role == 'teacher'

CalendarCtrl.$inject = [
  '$scope',
  '$state',
  'DateUtils',
  'course'
]

angular
  .module('app.courses')
  .controller('CalendarCtrl', CalendarCtrl)
