describe 'SystemNotificationsCtrl', ->
  beforeEach module('app.templates')
  beforeEach module('app.system-notifications')

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
    inject ($controller, $rootScope, $compile, $templateCache) ->
      html = $templateCache.get('system-notifications/system-notifications')
      ctrl = $controller 'SystemNotificationsCtrl',
               systemNotifications: systemNotifications
      $scope = $rootScope.$new()
      $scope.vm = ctrl
      view = $compile(angular.element(html))($scope)
      $scope.$digest()

  it "assigns system notifications", ->
    expect(ctrl.systemNotifications).toBe(systemNotifications)

  it "has the notification's type", ->
    expect(view.html()).toContain(systemNotification.notification_type)

  it "has the notification's creation date", ->
    expect(view.html()).toContain('09/10/15 15:09')

  it "has the author's name", ->
    expect(view.html()).toContain(author.name)

  it "has the author's avatar", ->
    expect(view.find('[user-avatar="notification.user"]').length).toBe(1)
