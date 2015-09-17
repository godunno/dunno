NewFileMediaCtrl = ($scope, Media) ->
  $scope.$on 'newTopic', ($event, topicType) ->
    $scope.$broadcast 'saveTopic' if topicType == 'file'

  reset = ->
    $scope.$broadcast("file.clean")
    $scope.status = 'newMedia'
  reset()

  $scope.$on 'createdTopic', reset
  $scope.$on 'removeMedia', reset
  $scope.$on 'cancelTopic', reset

  success = (media) ->
    $scope.$broadcast('newMedia', media)
    $scope.status = 'createdMedia'

  failure = (response) ->
    if response.error == 'too_large'
      alert 'O arquivo enviado é grande demais.'
    else
      alert 'Ocorreu um erro durante o envio do arquivo.'
    reset()

  progress = (event) ->
    percentage = parseInt(100.0 * event.loaded / event.total)
    $scope.$broadcast("progress.setValue", "#{percentage}%")

  $scope.submitFileMedia = ($files) ->
    $scope.$broadcast("progress.start")
    $scope.status = 'submittingMedia'
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

NewFileMediaCtrl.$inject = ['$scope', 'Media']

angular
  .module('app.lessonPlan')
  .controller('NewFileMediaCtrl', NewFileMediaCtrl)
