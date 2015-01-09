DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ApplicationCtrl = ($scope, $http, $window, SessionManager)->
  $scope.$on '$viewContentLoaded', ()->
    $(document).foundation()

  $scope.sign_out = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  if SessionManager.currentUser() == null
    SessionManager.fetchUser()

  $scope.currentUser = SessionManager.currentUser

ApplicationCtrl.$inject = ['$scope', '$http', '$window', 'SessionManager']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
DunnoAppStudent.controller 'ApplicationCtrl', ApplicationCtrl
