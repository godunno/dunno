DunnoApp = angular.module('DunnoApp')

NewFileMediaCtrl = ($scope, Media) ->
  reset = ->
    $scope.$broadcast("file.clean")

  success = (media) ->
    $scope.$emit('newMedia', media)

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
        reset()
        $scope.$broadcast("progress.stop")
      )

  #submitMedia = (callback, showProgress)->
  #  #return if item.media? && !confirm("Deseja substituir o anexo atual?")
  #  #item._submittingMedia = true
  #  #if showProgress
  #  $scope.$broadcast("progress.start")
  #  callback.then((media)->
  #    #media = if response.data? # response may be wrapped
  #    #    response.data
  #    #  else if Array.isArray(response)
  #    #    response[0]
  #    #  else
  #    #    response
  #    #$analytics.eventTrack('Media Created', type: media.type, title: media.title, eventUuid: $scope.event.uuid)
  #  ).finally(->
  #    #item._submittingMedia = false
  #    $scope.$broadcast("progress.stop")
  #  )

NewFileMediaCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'NewFileMediaCtrl', NewFileMediaCtrl
