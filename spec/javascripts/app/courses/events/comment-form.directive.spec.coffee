describe "comment-form directive", ->
  el = null
  SessionManager = null
  $httpBackend = null
  scope = null
  ctrl = null
  commentBodyInput = null
  UserComment = null

  beforeEach ->
    module('app.templates')
    module 'app.core', ($provide) ->
      mockS3Upload =
        upload: (->)
      $provide.value('S3Upload', mockS3Upload)
      return
    module 'app.courses', ($urlRouterProvider) ->
      $urlRouterProvider.deferIntercept()

    inject (
      _$rootScope_,
      _$compile_,
      _SessionManager_,
      _$httpBackend_,
      _UserComment_) ->

      $rootScope = _$rootScope_
      $compile = _$compile_
      SessionManager = _SessionManager_
      $httpBackend = _$httpBackend_
      UserComment = _UserComment_

      SessionManager.setCurrentUser(name: '', avatar_url: 'http://example.org/my/cool/avatar.png')
      el = angular.element("""
        <comment-form event="event" course="course" on-save="saveCallback">
        </comment-form>
      """)
      scope = $rootScope.$new()
      scope.event = { start_at: "2015-10-06T00:10:44Z" }
      scope.course = { uuid: "1" }
      $compile(el)(scope)
      scope.$apply()

      scope.saveCallback = jasmine.createSpy('onSave')
      commentBodyInput = el.find('input')
      ctrl = el.controller('commentForm')
      $httpBackend.whenPOST('/api/v1/comments').respond
        comment:
          id: 1
          body: 'cool!'
          user:
            id: 1
          attachments: []

  sendComment = ->
    commentBodyInput.val('cool!').trigger('input')
    el.find('button').click()
    $httpBackend.flush()

  it 'has avatar and some form components', ->
    expect(el.html()).toMatch('http://example.org/my/cool/avatar.png')
    expect(el.find('form').attr('name')).toEqual("vm.commentForm")
    expect(el.find('input').attr('name')).toEqual("commentBody")

  it 'sets the comment body, course id and event start_at', ->
    commentBodyInput.val('cool!').trigger('input')
    expect(ctrl.comment.course_id).toEqual("1")
    expect(ctrl.comment.event_start_at).toEqual("2015-10-06T00:10:44Z")
    expect(ctrl.comment.body).toEqual('cool!')

  it 'saves the comment', ->
    spyOn(UserComment.prototype, 'save').and.callThrough()
    sendComment()

    expect(UserComment.prototype.save).toHaveBeenCalled()

  it 'calls the callback function with comment', ->
    sendComment()

    expect(scope.saveCallback).toHaveBeenCalledWith(jasmine.any(UserComment))

  it 'clears comment after save', ->
    sendComment()
    expect(ctrl.comment.body).toBeUndefined()
    expect(ctrl.comment.event_start_at).toEqual("2015-10-06T00:10:44Z")
