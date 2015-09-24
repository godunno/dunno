ProfileCtrl = ($scope, $http, SessionManager) ->
  $scope.user = SessionManager.currentUser()

  success = (response) ->
    $scope.success = true
    $scope.error = false
    SessionManager.setCurrentUser(response.data)

  failure = (response) ->
    $scope.error = true
    $scope.success = false

  $scope.update = (user) ->
    $scope.submitting = $http.patch("/api/v1/users", user: user).then(success, failure)

ProfileCtrl.$inject = ['$scope', '$http', 'SessionManager']

angular
  .module('app.profile')
  .controller('ProfileCtrl', ProfileCtrl)
