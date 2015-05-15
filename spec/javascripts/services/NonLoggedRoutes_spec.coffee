describe "NonLoggedRoutes service", ->
  $window = location: { pathname: '' }
  beforeEach module 'DunnoApp', ($provide) ->
    $provide.value('$window', $window)
    null

  beforeEach teacherAppDefaultMocks

  NonLoggedRoutes = null
  beforeEach ->
    inject (_NonLoggedRoutes_) ->
      NonLoggedRoutes = _NonLoggedRoutes_

  it "knows it's a non logged route", ->
    $window.location.pathname = '/sign_in'
    expect(NonLoggedRoutes.isNonLoggedRoute()).toBe(true)

  it "knows it's a logged route", ->
    $window.location.pathname = '/dashboard/teacher/courses'
    expect(NonLoggedRoutes.isNonLoggedRoute()).toBe(false)
