DunnoApp = angular.module('DunnoApp')

NotificationCtrl = ($scope, $timeout, Notification)->
  $scope.limit = 140

  ($scope.reset = ->
    $scope.notification = new Notification()
  )()

  $scope.save = (notification)->
    notification.course_id = $scope.$parent.course.uuid
    notification.save().then(->
      $scope.reset()
      # TODO: broadcast event instead of calling a function directly
      $scope.dismiss()
    ).catch(->
      $scope.error = true
      $timeout (-> $scope.error = false), 2000
    )


NotificationCtrl.$inject = [
  '$scope', '$timeout', 'Notification'
]
DunnoApp.controller 'NotificationCtrl', NotificationCtrl
