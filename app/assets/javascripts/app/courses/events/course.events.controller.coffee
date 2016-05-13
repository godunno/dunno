CourseEventsCtrl = (
  $scope,
  $templateCache,
  $state,
  pagination,
  AnalyticsTracker,
  PageLoading,
  $filter,
  $stateParams
) ->
  @previousMonth = pagination.previousMonth
  @currentMonth = pagination.currentMonth
  @nextMonth = pagination.nextMonth
  @events = pagination.events
  @today = new Date().toISOString()
  @showToday = ->
    current = moment(@currentMonth)
    startOfMonth = current.startOf('month').toISOString()
    endOfMonth = current.endOf('month').toISOString()
    !moment(@today).isBetween(startOfMonth, endOfMonth)

  showCommentsFor = (event) ->
    if event._fetched
      event._showComments = true
    else
      event.course = $scope.course
      PageLoading.resolve event.get().then (response) ->
        event._fetched = true
        event._showComments = true

  hideCommentsFor = (event) ->
    event._showComments = false

  filterEvent = (event) =>
    @selectedDate?.isSame(event.start_at, 'day')

  @selectedEvents = =>
    $filter('filter')(@events, filterEvent)

  @toggleCommentsFor = (event, show) ->
    if show
      showCommentsFor(event)
    else
      hideCommentsFor(event)

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

  isStudent = ->
    $scope.course.user_role == 'student'

  @calendarOptions =
    filter: if isStudent() then filterDates
    start: @currentMonth
    template: $templateCache.get('courses/events/angular-mighty-datepicker')
    callback: (date) =>
      if filterDates(date)
        @selectedDate = date
      else
        $state.go('^.event', { startAt: date.clone().hours(9).format() })

  @eventsMarkers = @eventsDates.map (date) ->
    day: date
    marker: ' '

  @moveToEvent = (event) =>
    filterDates(@selectedDate)?.isSame(moment(event.start_at))

  @selectedEvent = (event) =>
    @selectedEvents().indexOf(event) != -1

  goToDate = =>
    startAt = $stateParams.startAt
    commentId = $stateParams.commentId
    if startAt
      @selectedDate = moment(startAt)

      if commentId
        @selectedEvents().forEach (event) ->
          showCommentsFor(event)

      if $stateParams.trackEventCanceled
        event = @selectedEvents().filter(@selectedEvent)[0]
        AnalyticsTracker.eventCanceledAccessed(
          angular.extend({}, event, course: $scope.course)
        )

  goToDate()

  @

CourseEventsCtrl.$inject = [
  '$scope',
  '$templateCache',
  '$state',
  'pagination',
  'AnalyticsTracker',
  'PageLoading',
  '$filter',
  '$stateParams'
]

angular
  .module('app.courses')
  .controller('CourseEventsCtrl', CourseEventsCtrl)
