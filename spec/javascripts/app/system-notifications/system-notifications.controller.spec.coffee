describe 'SystemNotificationsCtrl', ->
  beforeEach module('app.templates')
  beforeEach module('app.system-notifications')

  $httpBackend = null

  $scope = null
  ctrl = null
  view = null

  author =
    name: 'Professor Girafales'

  systemNotification =
    created_at: "2015-10-09T18:09:23Z"
    notification_type: 'event_canceled'
    author: author

  systemNotifications = [systemNotification]

  beforeEach ->
    inject ($controller, $rootScope, $compile, $templateCache, _$httpBackend_) ->
      $httpBackend = _$httpBackend_
      $httpBackend
        .expectPATCH('/api/v1/system_notifications/viewed.json')
        .respond(200, '')

      html = $templateCache.get('system-notifications/system-notifications')
      $scope = $rootScope.$new()
      ctrl = $controller 'SystemNotificationsCtrl',
               systemNotifications: systemNotifications
               $scope: $scope
      $scope.vm = ctrl
      view = $compile(angular.element(html))($scope)
      $scope.$digest()

  it "assigns system notifications", ->
    expect(ctrl.systemNotifications).toBe(systemNotifications)

  it "has the notification's type", ->
    expect(view.find('system-notification').length).toBe(1)

  it "zeroes the new notifications count", ->
    spyOn($scope, '$emit')
    $httpBackend.flush()
    expect($scope.$emit).toHaveBeenCalledWith('$stateChangeStart')
