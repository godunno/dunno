DunnoApp = angular.module('DunnoApp')

NewTopicCtrl = ($scope, Topic) ->
  $scope.defaultTopicProperties ?= { personal: false }

  $scope.topicTypeDescription = ->
    {
      'text': 'texto',
      'file': 'arquivo',
      'url': 'link',
      'catalog': 'do catálogo'
    }[$scope.topicType]

  reset = ->
    $scope.topicType = null
  reset()

  $scope.$on 'initializeEvent', reset
  $scope.$on 'createdTopic', reset

  $scope.addTopic = -> $scope.$broadcast('newTopic', $scope.topicType)

NewTopicCtrl.$inject = ['$scope', 'Topic']
DunnoApp.controller 'NewTopicCtrl', NewTopicCtrl
