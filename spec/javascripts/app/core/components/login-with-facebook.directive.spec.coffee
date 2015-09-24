describe "loginWithFacebook directive", ->
  el = null

  beforeEach ->
    module 'app', ($urlRouterProvider) ->
      $urlRouterProvider.deferIntercept()
    inject (_$rootScope_, _$compile_) ->
      $rootScope = _$rootScope_
      $compile = _$compile_
      el = angular.element("<login-with-facebook></login-with-facebook>")
      $compile(el)($rootScope.$new())
      $rootScope.$digest()


  it 'links to the right url', ->
    expect(el.html()).toMatch("/users/auth/facebook")
