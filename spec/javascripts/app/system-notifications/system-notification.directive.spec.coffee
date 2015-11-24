describe 'system-notification directive', ->
  beforeEach module('app.templates')
  beforeEach module('app.system-notifications')
  beforeEach module('app.courses')

  element = null
  $scope = null
  $httpBackend = null
  systemNotification = null

  author =
    name: 'José'

  course =
    uuid: 'some-uuid'
    name: 'Português'

  event =
    start_at: "2015-10-14T17:00:00Z"
    course: course

  comment =
    id: 1
    event: event

  topic =
    event: event

  compile = ->
    inject ($controller, $rootScope, $compile, $templateCache, SystemNotification) ->
      $scope = $rootScope.$new()
      $scope.systemNotification = systemNotification
      template = '<system-notification notification="systemNotification">'
      element = $compile(template)($scope)
      $scope.$digest()

  beforeEach ->
    jasmine.clock().mockDate(new Date("2015-10-14T15:00:00Z"))

    inject (_$httpBackend_, SystemNotification) ->

      systemNotification = new SystemNotification
        id: 1
        created_at: "2015-10-13T17:00:00Z"
        author: author

      $httpBackend = _$httpBackend_
      $httpBackend.whenGET('/api/v1/courses').respond(200, [])
      $httpBackend.whenGET('/api/v1/courses/' + course.uuid).respond(200, {})
      $httpBackend.whenGET("/api/v1/events?course_id=#{course.uuid}&month=#{event.start_at}")
        .respond(200, [])
      $httpBackend.whenGET('/api/v1/system_notifications/1').respond(200, [])

  describe "notification for new comment", ->
    beforeEach ->
      systemNotification.notification_type = 'new_comment'
      systemNotification.notifiable = comment
      compile()

    it "links to the comment", inject ($timeout, $state, $stateParams) ->
      element.find('a.system__notification').click()

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      expect($state.is('app.courses.show.events')).toBe(true)
      expect($stateParams).toEqual
        courseId: course.uuid
        startAt: event.start_at
        commentId: String(comment.id)
        month: undefined
        trackEventCanceled: undefined

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.notification.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José comentou há um dia atrás na aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português.'
        )

    it "marks as read when clicked", ->
      spyOn(systemNotification, 'get').and.callThrough()
      element.find('a.system__notification').click()
      expect(systemNotification.get).toHaveBeenCalled()

  describe "notification for event canceled", ->
    beforeEach ->
      systemNotification.notification_type = 'event_canceled'
      systemNotification.notifiable = event
      compile()

    it "links to the event", inject ($timeout, $state, $stateParams) ->
      element.find('a.system__notification').click()

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      expect($state.is('app.courses.show.events')).toBe(true)
      expect($stateParams).toEqual
        courseId: course.uuid
        startAt: event.start_at
        commentId: null
        month: undefined
        trackEventCanceled: undefined

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.notification.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José cancelou há um dia atrás a aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português.'
        )

  describe "notification for event published", ->
    beforeEach ->
      systemNotification.notification_type = 'event_published'
      systemNotification.notifiable = event
      compile()

    it "links to the event", inject ($timeout, $state, $stateParams) ->
      element.find('a.system__notification').click()

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      expect($state.is('app.courses.show.events')).toBe(true)
      expect($stateParams).toEqual
        courseId: course.uuid
        startAt: event.start_at
        commentId: null
        month: undefined
        trackEventCanceled: undefined

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.notification.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José publicou há um dia atrás a aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português.'
        )

  describe "notification for blocked", ->
    beforeEach ->
      $httpBackend.whenGET("/api/v1/events?course_id=#{course.uuid}").respond(403)
      systemNotification.notification_type = 'blocked'
      systemNotification.notifiable = course
      compile()

    it "links to the courses page", inject ($timeout, $state, $stateParams) ->
      $state.go('app.courses')

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      element.find('a.system__notification').click()

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      expect($state.is('app.courses')).toBe(true)

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.notification.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José bloqueou você há um dia atrás ' +
          'da disciplina Português.'
        )

  describe "notification for new member", ->
    beforeEach ->
      systemNotification.notification_type = 'new_member'
      systemNotification.notifiable = course
      compile()

    it "links to the course's members page", inject ($timeout, $state, $stateParams) ->
      $state.go('app.courses')

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      element.find('a.system__notification').click()

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      expect($state.is('app.courses.show.members')).toBe(true)
      expect($stateParams).toEqual jasmine.objectContaining(courseId: course.uuid)

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.notification.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José entrou há um dia atrás ' +
          'na disciplina Português.'
        )

  describe "notification for new topic", ->
    beforeEach ->
      systemNotification.notification_type = 'new_topic'
      systemNotification.notifiable = topic
      compile()

    it "links to the event containing the topic", inject ($timeout, $state, $stateParams) ->
      element.find('a.system__notification').click()

      $scope.$apply()
      $timeout.flush()
      $httpBackend.flush()

      expect($state.is('app.courses.show.events')).toBe(true)
      expect($stateParams).toEqual
        courseId: course.uuid
        startAt: event.start_at
        commentId: null
        month: undefined
        trackEventCanceled: undefined

    it "has the author's name", ->
      expect(element.html()).toContain(author.name)

    it "has the author's avatar", ->
      expect(element.find('[user-avatar="vm.notification.author"]').length).toBe(1)

    it "shows the message for new comment", ->
      expect(element.text().trim())
        .toEqual(
          'José publicou há um dia atrás um novo conteúdo na aula de ' +
          'Quarta-Feira (14/Out - 14:00) da ' +
          'disciplina Português.'
        )
