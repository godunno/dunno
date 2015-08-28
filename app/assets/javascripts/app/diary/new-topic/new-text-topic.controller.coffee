DunnoApp = angular.module('DunnoApp')

NewTextTopicCtrl = ($scope, Topic) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'text'

NewTextTopicCtrl.$inject = ['$scope', 'Topic']
DunnoApp.controller 'NewTextTopicCtrl', NewTextTopicCtrl
