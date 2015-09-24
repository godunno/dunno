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

  $scope.addTopic = (e, topic) ->
    $scope.topic.event = $scope.event
    $scope.topic.personal = $scope.defaultTopicProperties.personal
    $scope.submitting = new Topic($scope.topic).create().then (topic) ->
      $scope.$emit('createdTopic', topic)
      reset()

  $scope.$on 'newMedia', setMedia
  $scope.$on 'cancelTopic', reset
  $scope.$on 'removeMedia', reset

  setNewStartWatcher = ->
    $scope.$watch 'topic.description', (value) ->
      return if value == undefined
      if value.length > 0
        startEditing()

  $scope.$watch 'topic.description', (value) ->
    return if !started
    unless value?
      finishEditing()

  startWatcher = setNewStartWatcher()

  started = false
  startEditing = ->
    $scope.$emit('startEditing')
    started = true
    startWatcher()

  finishEditing = ->
    $scope.$emit('finishEditing')
    started = false
    startWatcher = setNewStartWatcher()

TopicAttributesCtrl.$inject = ['$scope', 'Topic']

angular
  .module('app.lessonPlan')
  .controller('TopicAttributesCtrl', TopicAttributesCtrl)
