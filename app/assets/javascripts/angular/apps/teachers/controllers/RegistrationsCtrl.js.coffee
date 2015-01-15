DunnoApp = angular.module('DunnoApp')

RegistrationsCtrl = ($scope, $http, $window)->
  $scope.user = {}

  $scope.sign_up = (user)->
    $scope.registration_failed = false

    $http.post("/api/v1/users.json", user: user).then((data)->
      $window.location.href = "/sign_in"
    ).catch(-> $scope.registration_failed = true)

RegistrationsCtrl.$inject = ['$scope', '$http', '$window']
DunnoApp.controller 'RegistrationsCtrl', RegistrationsCtrl

