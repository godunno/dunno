DunnoApp = angular.module('DunnoApp')

NotificationCtrl = ($scope, $timeout, Notification)->
  $scope.limit = 140

  ($scope.reset = ->
    $scope.notification = new Notification()
    $scope.errors = {}
  )()

  $scope.status = 'ready'

  $scope.isReady = -> $scope.status == 'ready'
  $scope.setReady = -> $scope.status = 'ready'

  $scope.isSending = -> $scope.status == 'sending'
  $scope.setSending = -> $scope.status = 'sending'

  $scope.isSent = -> $scope.status == 'sent'
  $scope.setSent = -> $scope.status = 'sent'

  $scope.save = (notification)->
    $scope.hasError = false
    $scope.setSending()
    course = $scope.$parent.course
    notification.course_id = course.uuid
    notification.abbreviation = course.abbreviation
    notification.save().then(->
      $scope.reset()
      $scope.setSent()
    ).catch((response)->
      $scope.hasError = true
      $scope.errors = response.data.errors
      $scope.setReady()
    )

  $scope.sendButtonText = ->
    switch $scope.status
      when 'ready' then 'Enviar'
      when 'sending' then 'Enviando...'
      when 'sent' then 'Enviado com sucesso!'

NotificationCtrl.$inject = [
  '$scope', '$timeout', 'Notification'
]
DunnoApp.controller 'NotificationCtrl', NotificationCtrl
