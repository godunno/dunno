DunnoApp = angular.module('DunnoApp')

NewUrlMediaCtrl = ($scope, Media) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'url'

  reset = ->
    $scope.url = ''

  reset()

  success = (media) ->
    reset()
    $scope.$broadcast('newMedia', media)

  $scope.submitUrlMedia = ->
    media = new Media(url: $scope.url)
    $scope.submittingMediaPromise = media.create().then(success)

  #$scope.addTopic = ->
  #  superMethod = $scope.$parent.addTopic
  #  if $scope.topic.media?
  #    superMethod()
  #  else
  #    $scope.submitUrlMedia().then superMethod

NewUrlMediaCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'NewUrlMediaCtrl', NewUrlMediaCtrl
