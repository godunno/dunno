DunnoApp = angular.module('DunnoApp')

RegistrationsCtrl = ($scope, $http, $window, ErrorParser)->
  $scope.user = {}

  $scope.sign_up = (user)->
    $scope.registration_failed = false

    $http.post("/api/v1/users.json", user: user).then((data)->
      $window.location.href = "/sign_in"
    ).catch((response)->
      ErrorParser.setErrors(response.data.errors, $scope.user_form)
      $scope.registration_failed = true
    )

RegistrationsCtrl.$inject = ['$scope', '$http', '$window', 'ErrorParser']
DunnoApp.controller 'RegistrationsCtrl', RegistrationsCtrl
