DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ApplicationCtrl = ($scope, $http, $window, $cookieStore, SessionManager)->
  $scope.$on '$viewContentLoaded', ()->
    $(document).foundation()

  $scope.sign_out = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  if SessionManager.currentUser() == null
    SessionManager.fetchUser()

  $scope.currentUser = SessionManager.currentUser

  $scope.tutorialEnabled = (tutorialId)->
    return false if SessionManager.currentUser().completed_tutorial
    return true unless $cookieStore.get("tutorial_#{tutorialId}")
    false

  TUTORIALS = [1, 2, 3]
  $scope.tutorialClosed = (tutorialId)->
    $cookieStore.put("tutorial_#{tutorialId}", true)
    finished = TUTORIALS
      .map((id)-> $cookieStore.get("tutorial_#{id}"))
      .reduce((previous, current)-> previous && current)
    if finished
      $http.patch("/api/v1/users", user: {completed_tutorial: true}).then (response)->
        SessionManager.setCurrentUser(response.data)

ApplicationCtrl.$inject = ['$scope', '$http', '$window', '$cookieStore', 'SessionManager']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
DunnoAppStudent.controller 'ApplicationCtrl', ApplicationCtrl
