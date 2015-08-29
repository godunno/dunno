ApplicationCtrl = (
  $scope,
  $window,
  $rootScope,
  SessionManager,
  NonLoggedRoutes,
  NavigationGuard) ->

  $rootScope.$on '$locationChangeStart', (event)->
    event.preventDefault() if NonLoggedRoutes.isNonLoggedRoute()
    $(document).foundation()

  $scope.signOut = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  SessionManager.fetchUser()
  $scope.currentUser = SessionManager.currentUser

  $scope.$on 'wholePageLoading', (_, promise)->
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
  .module('DunnoApp')
  .controller('ApplicationCtrl', ApplicationCtrl)
