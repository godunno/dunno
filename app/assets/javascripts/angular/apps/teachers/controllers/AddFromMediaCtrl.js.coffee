DunnoApp = angular.module('DunnoApp')

AddFromMediaCtrl = ($scope, MediaSearcher)->
  angular.extend($scope, MediaSearcher)
  $scope.perPage = 3

  $scope.fetch()

AddFromMediaCtrl.$inject = ['$scope', 'MediaSearcher']
DunnoApp.controller 'AddFromMediaCtrl', AddFromMediaCtrl
