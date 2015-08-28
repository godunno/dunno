DunnoApp = angular.module('DunnoApp')

SignInCtrl = ($scope, $window, SessionManager)->
  $scope.user = {}

  $scope.sign_in = (user)->
    $scope.authentication_failed = false

    SessionManager.signIn(user).then((data)->
      $window.location.href = data.root_path
    ).catch(-> $scope.authentication_failed = true)

SignInCtrl.$inject = ['$scope', '$window', 'SessionManager']
DunnoApp.controller 'SignInCtrl', SignInCtrl

