DunnoApp = angular.module('DunnoApp')

NotificationCtrl = ($scope, $timeout, Notification)->
  $scope.limit = 140

  ($scope.reset = ->
    $scope.notification = new Notification()
  )()

  $scope.save = (notification)->
    $scope.sending = true
    $scope.error = false
    notification.course_id = $scope.$parent.course.uuid
    notification.save().then(->
      $scope.reset()
      # TODO: broadcast event instead of calling a function directly
      $scope.$broadcast('modal.dismiss')
    ).catch(->
      $scope.error = true
    ).finally(-> $scope.sending = false)


NotificationCtrl.$inject = [
  '$scope', '$timeout', 'Notification'
]
DunnoApp.controller 'NotificationCtrl', NotificationCtrl
