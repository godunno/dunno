NewTopicCtrl = ($scope, Topic, AnalyticsTracker) ->
  $scope.defaultTopicProperties ?= { personal: false }

  $scope.topicTypeDescription = ->
    {
      'text': 'texto',
      'file': 'arquivo',
      'url': 'link',
      'catalog': 'do catálogo'
    }[$scope.topicType]

  setCanAddTopic = (value) -> $scope.canAddTopic = value

  reset = ->
    setCanAddTopic(false)
    $scope.topicType = null
  reset()

  $scope.selectTopicType = (type) ->
    setCanAddTopic(false)
    $scope.topicType = type

  track = ($event, topic) ->
    AnalyticsTracker.topicCreated(topic, $scope.topicType)

  $scope.$on 'initializeEvent', reset
  $scope.$on 'createdTopic', track
  $scope.$on 'createdTopic', reset
  $scope.$on 'startEditing', -> setCanAddTopic(true)
  $scope.$on 'finishEditing', -> setCanAddTopic(false)

  $scope.addTopic = -> $scope.$broadcast('newTopic', $scope.topicType)
  $scope.cancel = ->
    $scope.$broadcast('cancelTopic')
    reset()

NewTopicCtrl.$inject = ['$scope', 'Topic', 'AnalyticsTracker']

angular
  .module('app.lessonPlan')
  .controller('NewTopicCtrl', NewTopicCtrl)
