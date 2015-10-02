describe "comment-form directive", ->
  el = null
  SessionManager = null
  $httpBackend = null
  scope = null
  ctrl = null
  commentBodyInput = null
  UserComment = null
  FoundationApi = null

  beforeEach ->
    module('app.templates')
    module 'app.courses', ($urlRouterProvider) ->
      $urlRouterProvider.deferIntercept()

    inject (_$rootScope_, _$compile_, _SessionManager_, _$httpBackend_, _UserComment_, _FoundationApi_) ->
      $rootScope = _$rootScope_
      $compile = _$compile_
      SessionManager = _SessionManager_
      $httpBackend = _$httpBackend_
      UserComment = _UserComment_
      FoundationApi = _FoundationApi_

      SessionManager.setCurrentUser(name: '', avatar_url: 'http://example.org/my/cool/avatar.png')
      el = angular.element("<comment-form event=\"event\" on-save=\"saveCallback\"></comment-form>")
      scope = $rootScope.$new()
      scope.event = {start_at: 1}
      $compile(el)(scope)
      scope.$apply()

      scope.saveCallback = jasmine.createSpy('onSave')
      commentBodyInput = el.find('input')
      ctrl = el.controller('commentForm')
      $httpBackend.whenPOST('/api/v1/comments').respond({comment: {body: 'cool!'}})

  sendComment = ->
    commentBodyInput.val('cool!').trigger('input')
    el.find('button').click()
    $httpBackend.flush()

  it 'has avatar and some form components', ->
    expect(el.html()).toMatch('http://example.org/my/cool/avatar.png')
    expect(el.find('form').attr('name')).toEqual("commentForm")
    expect(el.find('input').attr('name')).toEqual("commentBody")

  it 'sets the comment body and event start_at', ->
    commentBodyInput.val('cool!').trigger('input')
    expect(ctrl.comment.event_start_at).toEqual(1)
    expect(ctrl.comment.body).toEqual('cool!')

  it 'saves the comment', ->
    spyOn(UserComment.prototype, 'save').and.callThrough()
    sendComment()

    expect(UserComment.prototype.save).toHaveBeenCalled()

  it 'calls the callback function with comment', ->
    sendComment()

    expect(scope.saveCallback).toHaveBeenCalledWith(jasmine.any(UserComment))

  it 'sends a notification', ->
    spyOn(FoundationApi, 'publish')
    sendComment()
    expect(FoundationApi.publish)
      .toHaveBeenCalledWith('main-notifications', content: 'Comentário enviado, continue assim!')


  it 'clears comment after save', ->
    sendComment()
    expect(ctrl.comment.body).toBeUndefined()
    expect(ctrl.comment.event_start_at).toEqual(1)
