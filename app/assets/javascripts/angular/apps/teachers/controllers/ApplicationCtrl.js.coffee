DunnoApp = angular.module('DunnoApp')

ApplicationCtrl = ($scope, $window, $rootScope, SessionManager, TutorialsManager, NonLoggedRoutes, NavigationGuard)->
  $rootScope.$on '$locationChangeStart', (event)->
    event.preventDefault() if NonLoggedRoutes.isNonLoggedRoute()

    $(document).foundation()
  $scope.$on '$viewContentLoaded', ->

  $scope.signOut = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  SessionManager.fetchUser()

  $scope.currentUser = SessionManager.currentUser
  $scope.tutorialEnabled = TutorialsManager.tutorialEnabled
  $scope.tutorialClosed = TutorialsManager.tutorialClosed

  $scope.$on 'wholePageLoading', (_, promise)->
    $scope.wholePageLoading = promise

  NavigationGuard.guard()

ApplicationCtrl.$inject = ['$scope', '$window', '$rootScope', 'SessionManager', 'TutorialsManager', 'NonLoggedRoutes', 'NavigationGuard']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
