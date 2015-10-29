ApplicationCtrl = (
  $scope,
  $window,
  $rootScope,
  $state,
  SessionManager,
  NonLoggedRoutes,
  NavigationGuard,
  NewNotifications,
  AnalyticsTracker,
  FoundationPanel
) ->

  $rootScope.$on '$locationChangeStart', (event) ->
    event.preventDefault() if NonLoggedRoutes.isNonLoggedRoute()

  $rootScope.$on "$stateChangeStart", (evt, toState, toParams, fromState, fromParams) ->
    if fromState.name == "" && toState.name.startsWith('panel.')
      evt.preventDefault()
      $state.go("app.courses").then ->
        $state.go(toState, toParams)

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

  $scope.trackAndOpenNotifications = ->
    AnalyticsTracker.systemNotificationsAccessed()
    FoundationPanel.activate('notifications-panel')
    $scope.showNotifications = true

  $scope.closeNotifications = ->
    FoundationPanel.deactivate('notifications-panel')
    $scope.showNotifications = false

  NavigationGuard.guard()

ApplicationCtrl.$inject = [
  '$scope',
  '$window',
  '$rootScope',
  '$state',
  'SessionManager',
  'NonLoggedRoutes',
  'NavigationGuard',
  'NewNotifications',
  'AnalyticsTracker',
  'FoundationPanel'
]

angular
  .module('app')
  .controller('ApplicationCtrl', ApplicationCtrl)
