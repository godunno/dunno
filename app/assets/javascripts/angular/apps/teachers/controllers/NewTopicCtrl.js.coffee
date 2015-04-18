DunnoApp = angular.module('DunnoApp')

NewTopicCtrl = ($scope, Topic) ->
  $scope.defaultTopicProperties ?= { personal: false }

  setMedia = (e, media) ->
    $scope.topic.media = media
    $scope.topic.media_id = media.id
    $scope.topic.description = media.title

  $scope.$on 'newMedia', setMedia

  reset = ->
    $scope.topic = {}
  reset()

  $scope.addTopic = ->
    $scope.topic.event_id = $scope.event.id
    $scope.topic.personal = $scope.defaultTopicProperties.personal
    new Topic($scope.topic).create().then (topic) ->
      reset()
      $scope.$emit('newTopic', topic)

NewTopicCtrl.$inject = ['$scope', 'Topic']
DunnoApp.controller 'NewTopicCtrl', NewTopicCtrl
