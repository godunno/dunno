describe "FacebookWrapper service", ->
  Facebook = ->
    login = (fn) ->
      fn({uid: 'NEW_FACEBOOK_UID'})

    login: login

  ENV =
    FACEBOOK_APP_ID: 1234

  userFromBackend =
    id: 1
    name: 'Darth Vader'

  FacebookWrapper = null
  $httpBackend = null
  facebookCallbackRequest = null
  SessionManager = null

  beforeEach ->
    module 'app.core', ($provide) ->
      $provide.factory('Facebook', Facebook)
      $provide.constant('ENV', ENV)
      null
    inject (_FacebookWrapper_, _$httpBackend_, _SessionManager_) ->
      FacebookWrapper = _FacebookWrapper_
      $httpBackend = _$httpBackend_
      SessionManager = _SessionManager_
      $httpBackend.whenPOST('/users/auth/facebook/callback')
        .respond(userFromBackend)

  describe 'login', ->
    it 'asks for e-mail permission', ->
      expect(Facebook.login()).toHaveBeenCalledWith('', scope: 'email')
      FacebookWrapper.login()

    it 'pings the backend correctly', ->
      $httpBackend.expectPOST '/users/auth/facebook/callback', uid: "NEW_FACEBOOK_UID"
      FacebookWrapper.login()
      $httpBackend.flush()

    it 'sets the user on the session', ->
      FacebookWrapper.login()
      $httpBackend.flush()
      expect(SessionManager.currentUser()).toEqual({id: 1, name: 'Darth Vader'})
