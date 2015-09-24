CourseEventsCtrl = (
  $scope,
  $stateParams,
  pagination,
  AnalyticsTracker,
  Event,
  DateUtils,
  PageLoading
) ->
  angular.extend($scope, DateUtils)

  $scope.previousMonth = pagination.previousMonth
  $scope.currentMonth = pagination.currentMonth
  $scope.nextMonth = pagination.nextMonth
  $scope.events = pagination.events

  showEventsFor = (event) ->
    if event._fetched
      event._showTopics = true
    else
      event.course = $scope.course
      PageLoading.resolve event.get().then (response) ->
        event._fetched = true
        event._showTopics = true

  hideEventsFor = (event) ->
    event._showTopics = false

  $scope.toggleTopicsFor = (event, show) ->
    if show
      showEventsFor(event)
    else
      hideEventsFor(event)

  $scope.track = (event) ->
    AnalyticsTracker.eventAccessed(
      angular.extend({}, event, course: $scope.course),
      "Events Tab"
    )

CourseEventsCtrl.$inject = [
  '$scope',
  '$stateParams',
  'pagination',
  'AnalyticsTracker',
  'Event',
  'DateUtils',
  'PageLoading'
]

angular
  .module('app.courses')
  .controller('CourseEventsCtrl', CourseEventsCtrl)
