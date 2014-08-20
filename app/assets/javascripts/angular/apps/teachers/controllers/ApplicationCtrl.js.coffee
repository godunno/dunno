DunnoApp = angular.module('DunnoApp')

ApplicationCtrl = ($scope)->
  $scope.$on '$viewContentLoaded', ()->
    $(document).foundation()

  $scope.currentUser = null
  $scope.setCurrentUser = (user)->
    $scope.currentUser = user
ApplicationCtrl.$inject = ['$scope']
DunnoApp.controller 'ApplicationCtrl', ApplicationCtrl
