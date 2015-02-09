DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'firstAccessModalCtrl', ($scope, $http, SessionManager) ->
  $scope.user = SessionManager.currentUser()

  $scope.updatePassword = (user)->
    $http.patch('/users', user: user).then ->
      $scope.element.foundation('reveal', 'close')

DunnoApp.directive 'firstAccessModal', ($location) ->
  restrict: 'A'
  scope: true
  controller: 'firstAccessModalCtrl'
  link: (scope, element, attrs) ->
    scope.element = element
    if $location.search().first_access
      element.foundation('reveal', 'open', close_on_background_click: false)

