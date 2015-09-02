CalendarCtrl = (
  $scope,
  $state,
  DateUtils,
  CourseHelper,
  EventHelper,
  course
) ->
  angular.extend($scope, DateUtils)
  angular.extend($scope, CourseHelper)
  angular.extend($scope, EventHelper)

  $scope.course = course

  $scope.goToEvent = (event) ->
    if $scope.course.user_role == 'teacher'
      $state.go('^.event', { startAt: event.start_at })
    else
      $state.go('^.events', until: event.start_at)

CalendarCtrl.$inject = [
  '$scope',
  '$state',
  'DateUtils',
  'CourseHelper',
  'EventHelper',
  'course'
]

angular
  .module('app.courses')
  .controller('CalendarCtrl', CalendarCtrl)
