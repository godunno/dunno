NewUrlMediaCtrl = ($scope, Media) ->
  initialize = ->
    $scope.url = undefined
    $scope.media = undefined

  initialize()

  reset = ->
    finishEditing() if $scope.url?.length > 0
    initialize()

  $scope.$on 'createdTopic', reset
  $scope.$on 'cancelTopic', reset
  $scope.$on 'removeMedia', reset

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

angular
  .module('app.lessonPlan')
  .controller('NewUrlMediaCtrl', NewUrlMediaCtrl)
