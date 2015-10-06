CourseEventsCtrl = (
  $scope,
  $templateCache,
  pagination,
  AnalyticsTracker,
  PageLoading
) ->
  @previousMonth = pagination.previousMonth
  @currentMonth = pagination.currentMonth
  @nextMonth = pagination.nextMonth
  @events = pagination.events

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

  @toggleTopicsFor = (event, show) ->
    if show
      showEventsFor(event)
    else
      hideEventsFor(event)

  @track = (event) ->
    AnalyticsTracker.eventAccessed(
      angular.extend({}, event, course: $scope.course),
      "Events Tab"
    )

  @eventsDates = @events.map (event) ->
    moment(event.start_at)

  filterDates = (date) =>
    for event in @eventsDates
      return event if event.isSame(date, 'day')

  @calendarOptions =
    filter: filterDates
    start: @currentMonth
    template: $templateCache.get('courses/events/angular-mighty-datepicker')
    callback: (date) =>
      @selectedDate = date

  @eventsMarkers = @eventsDates.map (date) ->
    day: date
    marker: ' '

  @moveToEvent = (event) =>
    filterDates(@selectedDate)?.isSame(moment(event.start_at))

  @selectedEvent = (event) =>
    @selectedDate?.isSame(moment(event.start_at), 'day')

  @

CourseEventsCtrl.$inject = [
  '$scope',
  '$templateCache',
  'pagination',
  'AnalyticsTracker',
  'PageLoading'
]

angular
  .module('app.courses')
  .controller('CourseEventsCtrl', CourseEventsCtrl)
