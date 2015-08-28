DunnoApp = angular.module('DunnoApp')

AddFromMediaCtrl = ($scope, MediaSearcher)->
  MediaSearcher.extend($scope)

  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'catalog'

  $scope.perPage = 3

  $scope.fetch()

  $scope.result = {}

  $scope.selectMedia = ->
    $scope.$broadcast 'newMedia', $scope.result.media

AddFromMediaCtrl.$inject = ['$scope', 'MediaSearcher']
DunnoApp.controller 'AddFromMediaCtrl', AddFromMediaCtrl
