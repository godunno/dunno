NotificationCtrl = (
  $scope,
  $timeout,
  $analytics,
  $modalInstance,
  Notification,
  ErrorParser
  course) ->

  @limit = 140
  @course = course

  reset = =>
    @notification = new Notification()
    @notification_form.$setPristine() if @notification_form

  reset()

  status = 'ready'

  @isReady = -> status == 'ready'
  @setReady = -> status = 'ready'

  @isSending = -> status == 'sending'
  @setSending = -> status = 'sending'

  @isSent = -> status == 'sent'
  @setSent = -> status = 'sent'

  @save = (notification) =>
    @hasError = false
    @setSending()
    notification.course_id = course.uuid
    notification.abbreviation = course.abbreviation
    notification.save().then(=>
      @setSent()
      reset()
      $analytics.eventTrack 'Notification Sent',
        courseName: course.name
        courseUuid: course.uuid
        message: notification.message
    ).catch((response) =>
      @hasError = true
      ErrorParser.setErrors(response.data.errors, @notification_form, $scope)
      @setReady()
      $analytics.eventTrack 'Notification Error',
        courseName: course.name,
        courseUuid: course.uuid,
        message: notification.message,
        error: response.data.errors
    )

  @sendButtonText = ->
    switch status
      when 'ready' then 'Enviar mensagem'
      when 'sending' then 'Enviando...'
      when 'sent' then 'Enviado com sucesso!'

  @

NotificationCtrl.$inject = [
  '$scope',
  '$timeout',
  '$analytics',
  '$modalInstance',
  'Notification',
  'ErrorParser',
  'course'
]

angular
  .module('app.courses')
  .controller('NotificationCtrl', NotificationCtrl)
