DunnoApp = angular.module('DunnoApp')

NewFileMediaCtrl = ($scope, Media) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'file'

  $scope.$on 'createdTopic', reset

  reset = ->
    $scope.$broadcast("file.clean")
    $scope.status = 'newMedia'
  reset()

  success = (media) ->
    $scope.$broadcast('newMedia', media)
    $scope.status = 'createdMedia'

  failure = (response) ->
    if response.error == 'too_large'
      alert 'O arquivo enviado é grande demais.'
    else
      alert 'Ocorreu um erro durante o envio do arquivo.'

  progress = (event) ->
    percentage = parseInt(100.0 * event.loaded / event.total)
    $scope.$broadcast("progress.setValue", "#{percentage}%")

  $scope.submitFileMedia = ($files)->
    $scope.$broadcast("progress.start")
    $scope.status = 'submittingMedia'
    # TODO: Find out why the line bellow doesn't work
    # new Media(file: $files[0]).upload()
    media = new Media()
    media.file = $files[0]
    media.upload()
      .then(success)
      .catch(failure)
      # promise.then(success, failure, notify)
      .then(null, null, progress) # notifying progress
      .finally(->
        $scope.$broadcast("progress.stop")
      )

  #    #$analytics.eventTrack('Media Created', type: media.type, title: media.title, eventUuid: $scope.event.uuid)

NewFileMediaCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'NewFileMediaCtrl', NewFileMediaCtrl
