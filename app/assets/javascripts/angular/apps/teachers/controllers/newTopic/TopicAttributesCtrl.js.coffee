DunnoApp = angular.module('DunnoApp')

TopicAttributesCtrl = ($scope, Topic) ->
  initialize = ->
    $scope.topic = {}
  initialize()

  reset = ->
    finishEditing() if $scope.topic.description?.length > 0
    initialize()

  setMedia = (e, media) ->
    $scope.topic.media = media
    $scope.topic.media_id = media.id
    $scope.topic.description = media.title

  saveTopic = (e, topic) ->
    $scope.topic.event_id = $scope.event.id
    $scope.topic.personal = $scope.defaultTopicProperties.personal
    new Topic($scope.topic).create().then (topic) ->
      $scope.$emit('createdTopic', topic)
      reset()

  $scope.$on 'newMedia', setMedia
  $scope.$on 'saveTopic', saveTopic
  $scope.$on 'cancelTopic', reset
  $scope.$on 'removeMedia', reset

  setNewStartWatcher = ->
    $scope.$watch 'topic.description', (value) ->
      return if value == undefined
      if value.length > 0
        startEditing()

  $scope.$watch 'topic.description', (value) ->
    return if value == undefined
    if value.length == 0
      finishEditing()

  startWatcher = setNewStartWatcher()

  startEditing = ->
    $scope.$emit('startEditing')
    startWatcher()

  finishEditing = ->
    $scope.$emit('finishEditing')
    startWatcher = setNewStartWatcher()

TopicAttributesCtrl.$inject = ['$scope', 'Topic']
DunnoApp.controller 'TopicAttributesCtrl', TopicAttributesCtrl
