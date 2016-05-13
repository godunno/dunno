RegistrationsCtrl = (
  $scope,
  $http,
  $window,
  ErrorParser,
  regularParams
) ->
  $scope.user = {}

  $scope.redirectTo = regularParams.get('redirectTo')

  $scope.sign_up = (user) ->
    $scope.hasError = false

    $scope.submitting = $http.post("/api/v1/users.json", user: user).then((data) ->
      $window.location.href = $scope.redirectTo || "/sign_in"
    ).catch((response) ->
      ErrorParser.setErrors(response.data.errors, $scope.signUpForm, $scope)
      $scope.hasError = true
    )

RegistrationsCtrl.$inject = [
  '$scope',
  '$http',
  '$window',
  'ErrorParser',
  'regularParams'
]

angular
  .module('app.users')
  .controller('RegistrationsCtrl', RegistrationsCtrl)
