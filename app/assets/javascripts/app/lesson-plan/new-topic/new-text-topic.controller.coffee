NewTextTopicCtrl = ($scope, Topic) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'text'

NewTextTopicCtrl.$inject = ['$scope', 'Topic']

angular
  .module('app.lessonPlan')
  .controller('NewTextTopicCtrl', NewTextTopicCtrl)
