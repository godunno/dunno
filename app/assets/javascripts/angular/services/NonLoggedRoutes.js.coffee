DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

NonLoggedRoutes = ($window)->
  ROUTES = [/^\/sign_in$/, /^\/sign_up$/, /^\/dashboard\/passwords\/new$/, /^\/dashboard\/passwords\/\d+\/edit$/]

  @isNonLoggedRoute = ->
    ROUTES.filter((route)-> route.exec($window.location.pathname)).length > 0

  @

NonLoggedRoutes.$inject = ['$window']

DunnoApp.service 'NonLoggedRoutes', NonLoggedRoutes
DunnoAppStudent.service 'NonLoggedRoutes', NonLoggedRoutes
