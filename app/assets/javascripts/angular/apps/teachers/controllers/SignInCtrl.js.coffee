DunnoApp = angular.module('DunnoApp')

SignInCtrl = ($scope, $window, SessionManager)->
  $scope.user = {}

  $scope.sign_in = (user)->
    $scope.authentication_failed = false

    SessionManager.signIn(user).then((data)->
      $window.location.href = data.root_path
    , ->
      $scope.authentication_failed = true
    )

  $scope.show_error = (field, error)->
    field = $scope.user[field]
    field.$errors[error] && field.$dirty

SignInCtrl.$inject = ['$scope', '$window', 'SessionManager']
DunnoApp.controller 'SignInCtrl', SignInCtrl

