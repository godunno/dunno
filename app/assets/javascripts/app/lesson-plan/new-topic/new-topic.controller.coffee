NewTopicCtrl = ($scope, Topic, AnalyticsTracker) ->
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

  $scope.selectTopicType = (type) ->
    $scope.topicType = type

  track = (topic) ->
    AnalyticsTracker.topicCreated(topic, $scope.topicType)

  $scope.$on 'initializeEvent', reset
  $scope.$on 'createdTopic', ($event, topic) ->
    track(topic)
    reset()

  $scope.cancel = ->
    $scope.$broadcast('cancelTopic')
    reset()

NewTopicCtrl.$inject = ['$scope', 'Topic', 'AnalyticsTracker']

angular
  .module('app.lessonPlan')
  .controller('NewTopicCtrl', NewTopicCtrl)
