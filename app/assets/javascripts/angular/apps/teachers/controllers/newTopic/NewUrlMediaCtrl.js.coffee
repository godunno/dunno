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
    $scope.url = undefined
    $scope.media = null

  reset()

  $scope.$on 'createdTopic', ->
    reset()
    finishEditing()

  $scope.$on 'removeMedia', ->
    reset()
    finishEditing()

  success = (media) ->
    $scope.media = media
    $scope.$broadcast('newMedia', media)

  $scope.submitUrlMedia = ->
    media = new Media(url: $scope.url)
    $scope.submittingMediaPromise = media.create().then(success)

  setNewStartWatcher = ->
    $scope.$watch 'url', (value) ->
      return if value == undefined
      if value.length > 0
        startEditing()

  $scope.$watch 'url', (value) ->
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
NewUrlMediaCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'NewUrlMediaCtrl', NewUrlMediaCtrl
