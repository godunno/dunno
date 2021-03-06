describe "CourseEventsCtrl", ->
  beforeEach module('app.courses')

  ctrl = null
  AnalyticsTracker =
    eventAccessed: (->)

  course =
    user_role: 'student'

  $scope =
    course: course

  event =
    uuid: "cee53377-508c-418c-a627-d2e06601df76"
    start_at: "2015-08-05T12:00:00Z"
    end_at: "2015-08-05T14:00:00Z"
    status: "draft"
    classroom: "201-A"
    get: ->
      then: (fn) -> fn()

  selectedEvent =
    uuid: "cde53377-508c-418c-a627-d2e06601df76"
    start_at: "2015-08-08T12:00:00Z"
    end_at: "2015-08-08T14:00:00Z"
    status: "draft"
    classroom: "201-A"
    get: ->
      then: (fn) -> fn()

  pagination =
    previousMonth: "2015-07-01T03:00:00Z"
    currentMonth: "2015-08-01T03:00:00Z"
    nextMonth: "2015-09-01T03:00:00Z"
    events: [event, selectedEvent]

  beforeEach ->
    inject ($controller) ->
      ctrl = $controller 'CourseEventsCtrl',
        $scope: $scope
        pagination: pagination
        AnalyticsTracker: AnalyticsTracker
        $stateParams:
          startAt: selectedEvent.start_at
          commentId: 1

  it "assigns events", ->
    expect(ctrl.events).toBe(pagination.events)

  it "assigns previous month", ->
    expect(ctrl.previousMonth).toBe(pagination.previousMonth)

  it "assigns current month", ->
    expect(ctrl.currentMonth).toBe(pagination.currentMonth)

  it "assigns next month", ->
    expect(ctrl.nextMonth).toBe(pagination.nextMonth)

  it "fetches comments for event", ->
    spyOn(event, 'get').and.callThrough()
    ctrl.toggleCommentsFor(event, true)
    expect(event.course).toBe(course)
    expect(event.get).toHaveBeenCalled()
    expect(event._fetched).toBe(true)

  it "doesn't fetch again topics for event", ->
    event._fetched = true
    spyOn(event, 'get')
    ctrl.toggleCommentsFor(event, true)
    expect(event.get).not.toHaveBeenCalled()

  it "shows topics for event", ->
    ctrl.toggleCommentsFor(event, true)
    expect(event._showComments).toBe(true)

  it "hides topics for event", ->
    ctrl.toggleCommentsFor(event, false)
    expect(event._showComments).toBe(false)

  it "tracks event", ->
    spyOn(AnalyticsTracker, 'eventAccessed')
    ctrl.track(event)
    expect(AnalyticsTracker.eventAccessed).toHaveBeenCalledWith(event, "Events Tab")

  it "selects date by default", ->
    expect(ctrl.selectedDate).toEqual(moment(selectedEvent.start_at))

  it "exposes events selected", ->
    expect(ctrl.selectedEvents()).toEqual([selectedEvent])

  it "fetches events topics and comments if comment id is passed on", ->
    expect(selectedEvent._fetched).toEqual(true)

  describe "go to today", ->
    today = new Date(selectedEvent.start_at)
    beforeEach ->
      jasmine.clock().mockDate(today)

    initializeController = ->
      inject ($controller) ->
        ctrl = $controller 'CourseEventsCtrl',
          $scope: $scope
          pagination: pagination

    it "sets today correctly", ->
      initializeController()
      expect(ctrl.today).toEqual(today.toISOString())

    it "doesn't show button when it's in current month", ->
      initializeController()
      expect(ctrl.showToday()).toBe(false)

    it "shows button when it's in another month", ->
      oneMonth = 1000 * 60 * 60 * 24 * 31 * 2
      jasmine.clock().mockDate(new Date(today.getTime() + oneMonth))
      initializeController()
      expect(ctrl.showToday()).toBe(true)

  describe "calendar widget", ->
    $state = { go: (->) }
    startAt = moment(event.start_at)
    inSameDay = startAt.clone().add(2, 'hours')
    eventInSameDay =
      start_at: inSameDay

    beforeEach ->
      calendarPagination = angular.copy(pagination)
      calendarPagination.events = [event, eventInSameDay]
      inject ($controller) ->
        ctrl = $controller 'CourseEventsCtrl',
          $scope: $scope
          $state: $state
          pagination: calendarPagination
          AnalyticsTracker: AnalyticsTracker

    it "assigns events dates", ->
      expect(ctrl.eventsDates).toEqual([startAt, inSameDay])

    it "assigns events markers", ->
      expect(ctrl.eventsMarkers).toEqual [
        { day: startAt, marker: ' ' },
        { day: inSameDay, marker: ' ' }
      ]

    it "assigns the calendar start", ->
      expect(ctrl.calendarOptions.start).toEqual(pagination.currentMonth)

    it "finds the first event's start at in the same day with the filter function", ->
      filter = ctrl.calendarOptions.filter
      expect(filter(startAt)).toEqual(startAt)
      dayAfter = startAt.clone().add(1, 'day')
      expect(filter(dayAfter)).not.toBeDefined()

    it "assigns a scheduled selected date on the callback", ->
      date = moment(event.start_at)
      ctrl.calendarOptions.callback(date)
      expect(ctrl.selectedDate).toBe(date)

    it "redirects to new event when selected date is outside the schedule", ->
      spyOn($state, 'go')
      date = moment(event.start_at).add(1, 'day')
      ctrl.calendarOptions.callback(date)
      expect($state.go).toHaveBeenCalledWith('^.event', { startAt: date.clone().hours(9).format() })

    it "moves to the first event in the same day", ->
      expect(ctrl.moveToEvent(event)).not.toBeDefined()
      ctrl.selectedDate = startAt
      expect(ctrl.moveToEvent(event)).toBe(true)
      expect(ctrl.moveToEvent(eventInSameDay)).toBe(false)

    it "marks all the events in the same day", ->
      expect(ctrl.selectedEvent(event)).toBe(false)
      ctrl.selectedDate = startAt
      expect(ctrl.selectedEvent(event)).toBe(true)
      expect(ctrl.selectedEvent(eventInSameDay)).toBe(true)
