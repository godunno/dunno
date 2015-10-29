NotificationCtrl = (
  $scope,
  $timeout,
  $analytics,
  modalInstance,
  Notification,
  ErrorParser,
  FoundationApi,
  course) ->

  vm = @

  vm.course = course

  vm.notification = new Notification()

  success = ->
    FoundationApi.publish 'main-notifications',
      content: """
      Mensagem enviada com sucesso!
      """
      color: 'success'
    $analytics.eventTrack 'Notification Sent',
      courseName: vm.course.name
      courseUuid: vm.course.uuid
      message: vm.notification.message
    modalInstance.destroy()

  failure = (response) ->
    ErrorParser.setErrors(response.data.errors, vm.notificationForm, $scope)
    $analytics.eventTrack 'Notification Error',
      courseName: vm.course.name,
      courseUuid: vm.course.uuid,
      message: vm.notification.message,
      error: response.data.errors

  vm.save = (notification) ->
    notification.course_id = course.uuid
    notification.abbreviation = course.abbreviation
    vm.submitting = notification.save().then(success, failure)

  vm

NotificationCtrl.$inject = [
  '$scope',
  '$timeout',
  '$analytics',
  'modalInstance',
  'Notification',
  'ErrorParser',
  'FoundationApi',
  'course'
]

angular
  .module('app.courses')
  .controller('NotificationCtrl', NotificationCtrl)
