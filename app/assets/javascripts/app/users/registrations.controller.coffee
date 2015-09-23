RegistrationsCtrl = ($scope, $http, $window, ErrorParser) ->
  $scope.user = {}

  $scope.sign_up = (user) ->
    $scope.hasError = false

    $scope.submitting = $http.post("/api/v1/users.json", user: user).then((data) ->
      $window.location.href = "/sign_in"
    ).catch((response) ->
      ErrorParser.setErrors(response.data.errors, $scope.signUpForm, $scope)
      $scope.hasError = true
    )

RegistrationsCtrl.$inject = ['$scope', '$http', '$window', 'ErrorParser']

angular
  .module('app.users')
  .controller('RegistrationsCtrl', RegistrationsCtrl)
