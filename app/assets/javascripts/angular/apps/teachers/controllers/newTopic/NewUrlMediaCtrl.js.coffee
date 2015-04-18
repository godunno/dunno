DunnoApp = angular.module('DunnoApp')

NewUrlMediaCtrl = ($scope, Media) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    return unless topicType == 'url'
    saveTopic = -> $scope.$broadcast 'saveTopic'
    if !$scope.media
      $scope.submitUrlMedia().then(saveTopic)
    else
      saveTopic()

  reset = ->
    $scope.url = ''
    $scope.media = null

  reset()

  $scope.$on 'createdTopic', reset

  success = (media) ->
    $scope.media = media
    $scope.$broadcast('newMedia', media)

  $scope.submitUrlMedia = ->
    media = new Media(url: $scope.url)
    $scope.submittingMediaPromise = media.create().then(success)

NewUrlMediaCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'NewUrlMediaCtrl', NewUrlMediaCtrl
