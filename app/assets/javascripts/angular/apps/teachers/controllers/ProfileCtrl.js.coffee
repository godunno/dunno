DunnoApp = angular.module('DunnoApp')

ProfileCtrl = ($scope, $http, SessionManager)->
  $scope.user = SessionManager.currentUser()

  $scope.update = (user)->
    $http.patch("/api/v1/users", user: user).then ->
      $scope.success = true
      SessionManager.fetchUser()

ProfileCtrl.$inject = ['$scope', '$http', 'SessionManager']
DunnoApp.controller 'ProfileCtrl', ProfileCtrl
