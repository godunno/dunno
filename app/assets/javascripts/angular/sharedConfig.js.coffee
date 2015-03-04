DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

setClassFromController = ($rootScope) ->
  $rootScope.$on '$routeChangeSuccess', (ev, data) ->
    if data.$$route?.controller?
      controller = data.$$route.controller
      controller = controller.replace(/Ctrl$/, '').replace(/([a-z\d])([A-Z])/g, '$1-$2').toLowerCase()
      $rootScope.controller = "#{controller}-page"

setClassFromController.$inject = ['$rootScope']

DunnoApp.run setClassFromController
DunnoAppStudent.run setClassFromController

checkProfile = ($rootScope, $window, SessionManager, NonLoggedRoutes)->
  $rootScope.$on '$routeChangeSuccess', (ev, data) ->
    rootPath = SessionManager.currentUser()?.root_path
    if !NonLoggedRoutes.isNonLoggedRoute() && rootPath? && rootPath != $window.location.pathname
      $window.location.href = rootPath

checkProfile.$inject = ['$rootScope', '$window', 'SessionManager', 'NonLoggedRoutes']
DunnoApp.run checkProfile
DunnoAppStudent.run checkProfile