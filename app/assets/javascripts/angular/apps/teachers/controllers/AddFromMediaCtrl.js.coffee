DunnoApp = angular.module('DunnoApp')

AddFromMediaCtrl = ($scope, Media, Utils, MediaSearcher)->
  angular.extend($scope, MediaSearcher)
  $scope.perPage = 3

  $scope.fetch()

AddFromMediaCtrl.$inject = ['$scope', 'Media', 'Utils', 'MediaSearcher']
DunnoApp.controller 'AddFromMediaCtrl', AddFromMediaCtrl
