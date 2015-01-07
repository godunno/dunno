DunnoApp = angular.module('DunnoApp')

ProfileCtrl = ($scope, $http, SessionManager)->
  $scope.user = SessionManager.currentUser()

  $scope.update = (user)->
    $http.patch("/api/v1/users", user: user).then (response)->
      $scope.success = true
      SessionManager.setCurrentUser(response.data)

ProfileCtrl.$inject = ['$scope', '$http', 'SessionManager']
DunnoApp.controller 'ProfileCtrl', ProfileCtrl
