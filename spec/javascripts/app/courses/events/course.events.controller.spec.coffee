describe "CourseEventsCtrl", ->
  beforeEach module('app.courses')

  ctrl = null
  AnalyticsTracker =
    eventAccessed: (->)

  course = {}

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

  pagination =
    previousMonth: "2015-07-01T03:00:00Z"
    currentMonth: "2015-08-01T03:00:00Z"
    nextMonth: "2015-09-01T03:00:00Z"
    events: [event]

  beforeEach ->
    inject ($controller) ->
      ctrl = $controller 'CourseEventsCtrl',
               $scope: $scope
               pagination: pagination
               AnalyticsTracker: AnalyticsTracker

  it "assigns events", ->
    expect(ctrl.events).toBe(pagination.events)

  it "assigns previous month", ->
    expect(ctrl.previousMonth).toBe(pagination.previousMonth)

  it "assigns current month", ->
    expect(ctrl.currentMonth).toBe(pagination.currentMonth)

  it "assigns next month", ->
    expect(ctrl.nextMonth).toBe(pagination.nextMonth)

  it "fetches topics for event", ->
    spyOn(event, 'get').and.callThrough()
    ctrl.toggleTopicsFor(event, true)
    expect(event.course).toBe(course)
    expect(event.get).toHaveBeenCalled()
    expect(event._fetched).toBe(true)

  it "doesn't fetch again topics for event", ->
    event._fetched = true
    spyOn(event, 'get')
    ctrl.toggleTopicsFor(event, true)
    expect(event.get).not.toHaveBeenCalled()

  it "shows topics for event", ->
    ctrl.toggleTopicsFor(event, true)
    expect(event._showTopics).toBe(true)

  it "hides topics for event", ->
    ctrl.toggleTopicsFor(event, false)
    expect(event._showTopics).toBe(false)

  it "tracks event", ->
    spyOn(AnalyticsTracker, 'eventAccessed')
    ctrl.track(event)
    expect(AnalyticsTracker.eventAccessed).toHaveBeenCalledWith(event, "Events Tab")

  describe "calendar widget", ->
    startAt = moment(event.start_at)
    inSameDay = startAt.clone().add(2, 'hours')
    eventInSameDay =
      start_at: inSameDay

    pagination.events.push(eventInSameDay)

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

    it "assigns the selected date on the callback", ->
      date = moment()
      ctrl.calendarOptions.callback(date)
      expect(ctrl.selectedDate).toBe(date)

    it "moves to the first event in the same day", ->
      expect(ctrl.moveToEvent(event)).not.toBeDefined()
      ctrl.selectedDate = startAt
      expect(ctrl.moveToEvent(event)).toBe(true)
      expect(ctrl.moveToEvent(eventInSameDay)).toBe(false)

    it "marks all the events in the same day", ->
      expect(ctrl.selectedEvent(event)).not.toBeDefined()
      ctrl.selectedDate = startAt
      expect(ctrl.selectedEvent(event)).toBe(true)
      expect(ctrl.selectedEvent(eventInSameDay)).toBe(true)
