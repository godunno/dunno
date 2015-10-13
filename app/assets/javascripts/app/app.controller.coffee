ApplicationCtrl = (
  $scope,
  $window,
  $rootScope,
  SessionManager,
  NonLoggedRoutes,
  NavigationGuard) ->

  $rootScope.$on '$locationChangeStart', (event) ->
    event.preventDefault() if NonLoggedRoutes.isNonLoggedRoute()

  $scope.signOut = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  SessionManager.fetchUser()

  $scope.$watchCollection (-> SessionManager.currentUser()), (updatedUser) ->
    if updatedUser
      $scope.currentUser = updatedUser

  $scope.$on 'wholePageLoading', (_, promise) ->
    $scope.wholePageLoading = promise

  NavigationGuard.guard()

ApplicationCtrl.$inject = [
  '$scope',
  '$window',
  '$rootScope',
  'SessionManager',
  'NonLoggedRoutes',
  'NavigationGuard']

angular
  .module('app')
  .controller('ApplicationCtrl', ApplicationCtrl)
