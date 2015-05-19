describe "SessionManager service", ->
  LocalStorageWrapper =
    set: (key, item) -> LocalStorageWrapper[key] = item
    get: (key) -> LocalStorageWrapper[key] || null
    remove: (key) -> LocalStorageWrapper[key] = null

  $analytics =
    eventTrack: angular.noop
    setUsername: angular.noop
    setUserProperties: angular.noop
    settings:
      pageTracking: {}

  beforeEach module 'DunnoApp', ($provide) ->
    $provide.value('LocalStorageWrapper', LocalStorageWrapper)
    $provide.value('$analytics', $analytics)
    null

  beforeEach teacherAppMockDefaultRoutes

  user = name: "John Doe"
  SessionManager = null
  $httpBackend = null
  beforeEach ->
    inject (_$httpBackend_, _SessionManager_) ->
      $httpBackend = _$httpBackend_
      SessionManager = _SessionManager_

  it "starts without user", ->
    expect(SessionManager.currentUser()).toEqual(null)

  it "sets current user", ->
    SessionManager.setCurrentUser(user)
    expect(SessionManager.currentUser()).toEqual(user)

  it "fetches the user", ->
    $httpBackend.whenGET('/api/v1/users/profile.json').respond(user)
    $httpBackend.expectGET('/api/v1/users/profile.json')
    SessionManager.fetchUser()
    $httpBackend.flush()
    expect(SessionManager.currentUser()).toEqual(user)

  it "signs in", ->
    $httpBackend.whenPOST('/api/v1/users/sign_in.json').respond(user)
    $httpBackend.expectPOST('/api/v1/users/sign_in.json', user: user)
    SessionManager.signIn(user)
    $httpBackend.flush()
    expect(SessionManager.currentUser()).toEqual(user)

  it "signs out", ->
    $httpBackend.whenDELETE('/api/v1/users/sign_out.json').respond(200)
    $httpBackend.expectDELETE('/api/v1/users/sign_out.json')
    SessionManager.signOut()
    $httpBackend.flush()
    expect(SessionManager.currentUser()).toEqual(null)
