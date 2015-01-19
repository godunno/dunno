DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ProfileCtrl = ($scope, $http, SessionManager)->
  $scope.user = SessionManager.currentUser()

  success = (response)->
    $scope.success = true
    $scope.error = false
    SessionManager.setCurrentUser(response.data)

  failure = (response)->
    for key, errors of response.data.errors
      for error in errors
        $scope.form[key].$setValidity(error, false)
    $scope.error = true
    $scope.success = false

  $scope.update = (user)->
    $http.patch("/api/v1/users", user: user).then(success, failure)

  $scope.update_password = (user)->
    $http.patch("/api/v1/users/password", user: user).then(success, failure)

ProfileCtrl.$inject = ['$scope', '$http', 'SessionManager']
DunnoApp.controller 'ProfileCtrl', ProfileCtrl
DunnoAppStudent.controller 'ProfileCtrl', ProfileCtrl
