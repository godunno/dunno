DunnoApp = angular.module('DunnoApp')

AddFromMediaCtrl = ($scope, Media, Utils, MediaSearcher)->
  MediaSearcher.inject($scope)
  $scope.perPage = 3

  $scope.fetch()

AddFromMediaCtrl.$inject = ['$scope', 'Media', 'Utils', 'MediaSearcher']
DunnoApp.controller 'AddFromMediaCtrl', AddFromMediaCtrl
