describe 'system-notification directive', ->
  beforeEach module('app.templates')
  beforeEach module('app.system-notifications')

  element = null

  author =
    name: 'José'

  course =
    name: 'Português'

  event =
    start_at: "2015-10-14T17:00:00Z"
    course: course

  comment =
    event: event

  systemNotification =
    created_at: "2015-10-13T17:00:00Z"
    author: author

  compile = ->
    inject ($controller, $rootScope, $compile, $templateCache) ->
      $scope = $rootScope.$new()
      $scope.systemNotification = systemNotification
      template = '<system-notification notification="systemNotification">'
      element = $compile(template)($scope)
      $scope.$digest()

  beforeEach ->
    jasmine.clock().mockDate(new Date("2015-10-14T15:00:00Z"))

  describe "notification for new comment", ->
    beforeEach ->
      systemNotification.notification_type = 'new_comment'
      systemNotification.notifiable = comment
      compile()

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José comentou um dia atrás na aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português .'
        )

  describe "notification for event canceled", ->
    beforeEach ->
      systemNotification.notification_type = 'event_canceled'
      systemNotification.notifiable = event
      compile()

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José cancelou um dia atrás a aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português .'
        )

  describe "notification for event published", ->
    beforeEach ->
      systemNotification.notification_type = 'event_published'
      systemNotification.notifiable = event
      compile()

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José publicou um dia atrás a aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português .'
        )
