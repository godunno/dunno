DunnoApp = angular.module('DunnoApp')

NotificationCtrl = ($scope, $timeout, $analytics, Notification, ErrorParser)->
  $scope.limit = 140

  ($scope.reset = ->
    $scope.notification = new Notification()
    $scope.notification_form.$setPristine() if $scope.notification_form
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
      $analytics.eventTrack('Notification Sent', courseName: course.name, courseUuid: course.uuid, message: notification.message)
    ).catch((response)->
      $scope.hasError = true
      ErrorParser.setErrors(response.data.errors, $scope.notification_form, $scope)
      $scope.setReady()
      $analytics.eventTrack('Notification Error', courseName: course.name, courseUuid: course.uuid, message: notification.message, error: response.data.errors)
    )

  $scope.sendButtonText = ->
    switch $scope.status
      when 'ready' then 'Enviar mensagem'
      when 'sending' then 'Enviando...'
      when 'sent' then 'Enviado com sucesso!'

NotificationCtrl.$inject = [
  '$scope', '$timeout', '$analytics', 'Notification', 'ErrorParser'
]
DunnoApp.controller 'NotificationCtrl', NotificationCtrl
