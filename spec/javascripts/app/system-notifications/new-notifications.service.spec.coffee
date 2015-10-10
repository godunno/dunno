describe "NewNotifications service", ->
  beforeEach module('app.system-notifications')

  $rootScope = null
  $httpBackend = null
  NewNotifications = null

  beforeEach ->
    inject (_$rootScope_, _$httpBackend_, _NewNotifications_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      NewNotifications = _NewNotifications_

  it "starts with zero", ->
    expect(NewNotifications.getCount()).toBe(0)

  it "updates the count when changing state", ->
    $httpBackend
      .expectGET('/api/v1/system_notifications/new_notifications')
      .respond(200, new_notifications_count: 1)
    $rootScope.$emit('$stateChangeStart')
    $httpBackend.flush()
    expect(NewNotifications.getCount()).toBe(1)
