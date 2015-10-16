ApplicationCtrl = (
  $scope,
  $window,
  $rootScope,
  SessionManager,
  NonLoggedRoutes,
  NavigationGuard
  NewNotifications) ->

  $rootScope.$on '$locationChangeStart', (event) ->
    event.preventDefault() if NonLoggedRoutes.isNonLoggedRoute()

  $scope.signOut = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  SessionManager.fetchUser()

  $scope.$watchCollection (-> SessionManager.currentUser()), (updatedUser) ->
    if updatedUser
      $scope.currentUser = updatedUser

  $scope.$watch (-> NewNotifications.getCount()), (newNotificationsCount) ->
    $scope.newNotificationsCount = newNotificationsCount

  $scope.$on 'wholePageLoading', (_, promise) ->
    $scope.wholePageLoading = promise

  NavigationGuard.guard()

ApplicationCtrl.$inject = [
  '$scope',
  '$window',
  '$rootScope',
  'SessionManager',
  'NonLoggedRoutes',
  'NavigationGuard'
  'NewNotifications']

angular
  .module('app')
  .controller('ApplicationCtrl', ApplicationCtrl)
