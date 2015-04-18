DunnoApp = angular.module('DunnoApp')

TopicAttributesCtrl = ($scope, Topic) ->
  reset = ->
    $scope.topic = {}
  reset()

  setMedia = (e, media) ->
    $scope.topic.media = media
    $scope.topic.media_id = media.id
    $scope.topic.description = media.title

  saveTopic = (e, topic) ->
    $scope.topic.event_id = $scope.event.id
    $scope.topic.personal = $scope.defaultTopicProperties.personal
    new Topic($scope.topic).create().then (topic) ->
      reset()
      $scope.$emit('createdTopic', topic)

  $scope.$on 'newMedia', setMedia
  $scope.$on 'saveTopic', saveTopic

TopicAttributesCtrl.$inject = ['$scope', 'Topic']
DunnoApp.controller 'TopicAttributesCtrl', TopicAttributesCtrl
