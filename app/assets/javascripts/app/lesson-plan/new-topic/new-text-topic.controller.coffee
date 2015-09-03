app.lessonPlan = angular.module('app.lessonPlan')

NewTextTopicCtrl = ($scope, Topic) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'text'

NewTextTopicCtrl.$inject = ['$scope', 'Topic']
app.lessonPlan.controller 'NewTextTopicCtrl', NewTextTopicCtrl
