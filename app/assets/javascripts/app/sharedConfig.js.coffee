DunnoApp = angular.module('DunnoApp')

setClassFromController = ($rootScope) ->
  $rootScope.$on '$stateChangeSuccess', (ev, data) ->
    if data.controller?
      controller = data.controller
      controller = controller.replace(/Ctrl$/, '').replace(/([a-z\d])([A-Z])/g, '$1-$2').toLowerCase()
      $rootScope.controller = "#{controller}-page"

setClassFromController.$inject = ['$rootScope']

DunnoApp.run setClassFromController

checkProfile = ($rootScope, $window, SessionManager, NonLoggedRoutes)->
  $rootScope.$on '$stateChangeSuccess', (ev, data) ->
    rootPath = SessionManager.currentUser()?.root_path
    if !NonLoggedRoutes.isNonLoggedRoute() && rootPath? && rootPath != $window.location.pathname
      $window.location.href = rootPath

checkProfile.$inject = ['$rootScope', '$window', 'SessionManager', 'NonLoggedRoutes']
DunnoApp.run checkProfile