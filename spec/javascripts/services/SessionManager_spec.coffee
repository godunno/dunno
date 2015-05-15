describe "SessionManager service", ->
  beforeEach module 'DunnoApp'
  beforeEach teacherAppDefaultMocks

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
