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
    notification.save().then((response)->
      $scope.reset()
      $scope.setSent()

      # Adapted from: http://goo.gl/w4QP8W
      if response && response.status && response.status == 200 && response.data
        i = 0
        while i < course.events.length
          event = course.events[i]
          i++
          if event.status == 'published' && new Date(event.start_at) > new Date()
            configuration = $analytics.config(api_token: 'ba7c28ba8ca86f15b248f7cccff21525', group: 'Notification')
            $analytics.eventTrack('Notification Sent', courseName: course.name, courseUuid: course.uuid, message: notification.message, eventUuid: event.uuid, configuration: configuration)
            configuration.$finish()
    ).catch((response)->
      $scope.hasError = true
      ErrorParser.setErrors(response.data.errors, $scope.notification_form, $scope)
      $scope.setReady()
      $analytics.eventTrack('Notification Error', courseName: course.name, courseUuid: course.uuid, message: notification.message, error: response.data.errors)
    )

  $scope.sendButtonText = ->
    switch $scope.status
      when 'ready' then 'Enviar'
      when 'sending' then 'Enviando...'
      when 'sent' then 'Enviado com sucesso!'

NotificationCtrl.$inject = [
  '$scope', '$timeout', '$analytics', 'Notification', 'ErrorParser'
]
DunnoApp.controller 'NotificationCtrl', NotificationCtrl
