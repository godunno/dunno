describe 'system-notifications directive', ->
  beforeEach module('app.templates')
  beforeEach module('app.system-notifications')

  $httpBackend = null

  $scope = null
  ctrl = null
  element = null

  author =
    name: 'Professor Girafales'

  systemNotification =
    created_at: "2015-10-09T18:09:23Z"
    author: author
    notification_type: 'event_canceled'
    notifiable:
      start_at: "2015-10-14T17:00:00Z"
      course:
        name: "Português"

  beforeEach ->
    inject ($controller, $rootScope, $compile, $templateCache, _$httpBackend_) ->
      $httpBackend = _$httpBackend_
      $httpBackend
        .expectGET('/api/v1/system_notifications')
        .respond(200, [systemNotification])
      $httpBackend
        .expectPATCH('/api/v1/system_notifications/viewed')
        .respond(200, '')

      template = '<system-notifications></system-notifications>'
      $scope = $rootScope.$new()
      element = $compile(angular.element(template))($scope)
      $scope.$digest()
      ctrl = element.controller('systemNotifications')

  beforeEach ->
    spyOn($scope, '$emit')
    $httpBackend.flush()
    $scope.$apply()

  it "assigns system notifications", ->
    systemNotifications = [jasmine.objectContaining(systemNotification)]
    expect(ctrl.systemNotifications).toEqual(systemNotifications)

  it "has the notification's type", ->
    expect(element.find('system-notification').length).toBe(1)

  it "zeroes the new notifications count", ->
    expect($scope.$emit).toHaveBeenCalledWith('checkNewNotifications')

  it "marks all as read", ->
    $httpBackend
      .expectPOST('/api/v1/system_notifications/mark_all_as_read')
      .respond(200, '')
    ctrl.markAllAsRead()
    $httpBackend.flush()
