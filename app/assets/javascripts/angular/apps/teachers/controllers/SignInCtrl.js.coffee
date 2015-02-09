DunnoApp = angular.module('DunnoApp')

SignInCtrl = ($scope, $window, SessionManager) ->
  $scope.user = {}

  $scope.sign_in = (user)->
    $scope.authentication_failed = false

    SessionManager.signIn(user)
    .then (data) ->
      $window.location.href = data.root_path
    .catch ->
      $scope.authentication_failed = true

DunnoApp.controller 'SignInCtrl', SignInCtrl

