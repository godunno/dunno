ProfileCtrl = ($scope, $http, SessionManager, ErrorParser)->
  $scope.user = SessionManager.currentUser()

  success = (response)->
    $scope.success = true
    $scope.error = false
    SessionManager.setCurrentUser(response.data)

  failure = (response)->
    ErrorParser.setErrors(response.data.errors, $scope.form, $scope)
    $scope.error = true
    $scope.success = false

  $scope.update = (user)->
    $http.patch("/api/v1/users", user: user).then(success, failure)

  $scope.update_password = (user)->
    $http.patch("/api/v1/users/password", user: user).then(success, failure)

ProfileCtrl.$inject = ['$scope', '$http', 'SessionManager', 'ErrorParser']

angular
  .module('app.profile')
  .controller('ProfileCtrl', ProfileCtrl)
