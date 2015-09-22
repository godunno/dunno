PasswordCtrl = ($scope, $http, SessionManager, ErrorParser) ->
  $scope.user = SessionManager.currentUser()

  success = (response) ->
    $scope.success = true
    $scope.error = false

  failure = (response) ->
    ErrorParser.setErrors(response.data.errors, $scope.passwordForm, $scope)
    $scope.error = true
    $scope.success = false

  $scope.update = (user) ->
    $http.patch("/api/v1/users/password", user: user).then(success, failure)

PasswordCtrl.$inject = ['$scope', '$http', 'SessionManager', 'ErrorParser']

angular
  .module('app.profile')
  .controller('PasswordCtrl', PasswordCtrl)
