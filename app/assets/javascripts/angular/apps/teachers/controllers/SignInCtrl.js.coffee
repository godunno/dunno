DunnoApp = angular.module('DunnoApp')

SignInCtrl = ($scope, $http, $window)->
  $scope.sign_in = (user)->
    $scope.authentication_failed = false

    # TODO: create a service to manage sessions
    $http.post("/api/v1/users/sign_in.json", user: user).then (response)->
      if response.status == 200
        $window.location.href = response.data.root_path
      else
        $scope.authentication_failed = true

SignInCtrl.$inject = ['$scope', '$http', '$window']
DunnoApp.controller 'SignInCtrl', SignInCtrl

