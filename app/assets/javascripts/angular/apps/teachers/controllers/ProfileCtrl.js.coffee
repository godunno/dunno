DunnoApp = angular.module('DunnoApp')

ProfileCtrl = ($scope, $http, SessionManager)->
  $scope.user = SessionManager.currentUser()

  after_update = (response)->
    if response.status == 200
      $scope.success = true
      $scope.error = false
      SessionManager.setCurrentUser(response.data)
    else
      $scope.error = true
      $scope.success = false

  $scope.update = (user)->
    $http.patch("/api/v1/users", user: user).then(after_update)

  $scope.update_password = (user)->
    $http.patch("/api/v1/users/password", user: user).then(after_update)

ProfileCtrl.$inject = ['$scope', '$http', 'SessionManager']
DunnoApp.controller 'ProfileCtrl', ProfileCtrl
