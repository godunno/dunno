DunnoApp = angular.module('DunnoApp')

ApplicationCtrl = ($scope, $http, $window, SessionManager)->
  $scope.$on '$viewContentLoaded', ()->
    $(document).foundation()

  $scope.sign_out = ->
    SessionManager.signOut().then ->
      $window.location.href = '/'

  if SessionManager.currentUser() == null
    SessionManager.fetchUser()

ApplicationCtrl.$inject = ['$scope', '$http', '$window', 'SessionManager']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
