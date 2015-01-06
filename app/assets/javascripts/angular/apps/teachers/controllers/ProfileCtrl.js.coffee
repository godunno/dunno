DunnoApp = angular.module('DunnoApp')

ProfileCtrl = ($scope, SessionManager)->
  $scope.user = SessionManager.currentUser()

ProfileCtrl.$inject = ['$scope', 'SessionManager']
DunnoApp.controller 'ProfileCtrl', ProfileCtrl
