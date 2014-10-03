DunnoApp = angular.module('DunnoApp')

ApplicationCtrl = ($scope, $http, $window)->
  $scope.$on '$viewContentLoaded', ()->
    $(document).foundation()

  $scope.currentUser = null
  $scope.setCurrentUser = (user)->
    $scope.currentUser = user

  $scope.sign_out = ->
    $http.delete('/api/v1/users/sign_out.json').then ->
      $window.location.href = '/'
ApplicationCtrl.$inject = ['$scope', '$http', '$window']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
