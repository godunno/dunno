CourseEventsCtrl = (
  $scope,
  $stateParams,
  pagination,
  AnalyticsTracker,
  Event,
  DateUtils
) ->
  angular.extend($scope, DateUtils)

  setEvents = (pagination) ->
    $scope.events = ($scope.events || []).concat pagination.events
    $scope.noMoreEvents = pagination.finished

  setEvents(pagination)

  $scope.eventsOffset = $scope.events.length
  $scope.nextPage = 1
  $scope.scrollUntil = $stateParams.until

  $scope.track = (event) ->
    AnalyticsTracker.eventAccessed(
      angular.extend({}, event, course: $scope.course),
      "Events Tab"
    )

  $scope.paginate = (page) ->
    params =
      course_id: $scope.course.uuid,
      offset: $scope.eventsOffset,
      page: page

    Event.paginate(params).then (pagination) ->
      setEvents(pagination)
      $scope.nextPage = page + 1

CourseEventsCtrl.$inject = [
  '$scope',
  '$stateParams',
  'pagination',
  'AnalyticsTracker',
  'Event',
  'DateUtils'
]

angular
  .module('app.courses')
  .controller('CourseEventsCtrl', CourseEventsCtrl)
