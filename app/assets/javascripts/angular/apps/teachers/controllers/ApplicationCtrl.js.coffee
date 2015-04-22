DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ApplicationCtrl = ($scope, $window, $rootScope, SessionManager, TutorialsManager, NonLoggedRoutes, NavigationGuard)->
  $rootScope.$on '$locationChangeStart', (event)->
    event.preventDefault() if NonLoggedRoutes.isNonLoggedRoute()

  $scope.$on '$viewContentLoaded', ()->
    $(document).foundation()

  $scope.sign_out = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  SessionManager.fetchUser()

  $scope.currentUser = SessionManager.currentUser
  $scope.tutorialEnabled = TutorialsManager.tutorialEnabled
  $scope.tutorialClosed = TutorialsManager.tutorialClosed

  $scope.$on 'wholePageLoading', (ev, promise)->
    $scope.wholePageLoading = promise

  NavigationGuard.guard()

ApplicationCtrl.$inject = ['$scope', '$window', '$rootScope', 'SessionManager', 'TutorialsManager', 'NonLoggedRoutes', 'NavigationGuard']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
DunnoAppStudent.controller 'ApplicationCtrl', ApplicationCtrl
