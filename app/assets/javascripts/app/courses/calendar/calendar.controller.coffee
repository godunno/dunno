CalendarCtrl = (
  $scope,
  $state,
  AnalyticsTracker,
  DateUtils,
  course
) ->
  angular.extend($scope, DateUtils)

  $scope.course = course

  $scope.goToEvent = (event) ->
    AnalyticsTracker.eventAccessed(
      angular.extend({}, event, course: $scope.course),
      "Calendar Tab"
    )
    if $scope.course.user_role == 'teacher'
      $state.go('^.event', { startAt: event.start_at })
    else
      $state.go('^.events', until: event.start_at)

CalendarCtrl.$inject = [
  '$scope',
  '$state',
  'AnalyticsTracker',
  'DateUtils',
  'course'
]

angular
  .module('app.courses')
  .controller('CalendarCtrl', CalendarCtrl)
