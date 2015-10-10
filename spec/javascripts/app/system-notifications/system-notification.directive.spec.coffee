describe 'SystemNotificationsCtrl', ->
  beforeEach module('app.templates')
  beforeEach module('app.system-notifications')

  element = null

  author =
    name: 'Professor Girafales'

  systemNotification =
    created_at: "2015-10-09T18:09:23Z"
    notification_type: 'event_canceled'
    author: author

  beforeEach ->
    inject ($controller, $rootScope, $compile, $templateCache) ->
      $scope = $rootScope.$new()
      $scope.systemNotification = systemNotification
      template = '<system-notification notification="systemNotification">'
      element = $compile(template)($scope)
      $scope.$digest()

  # it "has the notification's creation date", ->
  #   expect(element.html()).toContain('Sexta (09/Out - 18:09)')

  it "has the author's name", ->
    expect(element.html()).toContain(author.name)

  it "has the author's avatar", ->
    expect(element.find('[user-avatar="notification.author"]').length).toBe(1)
