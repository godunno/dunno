DunnoApp = angular.module('DunnoApp')

NewTopicCtrl = ($scope, Topic, $analytics) ->
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


  track = ($event, topic) ->
    $analytics.eventTrack 'Topic Created',
      private: topic.personal
      eventId: topic.event_id
      type: $scope.topicType

  $scope.$on 'initializeEvent', reset
  $scope.$on 'createdTopic', reset
  $scope.$on 'createdTopic', track

  $scope.addTopic = -> $scope.$broadcast('newTopic', $scope.topicType)

NewTopicCtrl.$inject = ['$scope', 'Topic', '$analytics']
DunnoApp.controller 'NewTopicCtrl', NewTopicCtrl
