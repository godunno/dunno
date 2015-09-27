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
