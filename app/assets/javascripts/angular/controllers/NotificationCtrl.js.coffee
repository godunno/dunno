DunnoApp = angular.module('DunnoApp')

NotificationCtrl = ($scope, Notification)->
  $scope.notification = new Notification()
  $scope.limit = 140

  $scope.save = (notification)->
    notification.course_id = $scope.$parent.course.uuid
    notification.save().then ->
      $scope.notification = new Notification()
      # TODO: broadcast event instead of calling a function directly
      $scope.dismiss()

NotificationCtrl.$inject = [
  '$scope', 'Notification'
]
DunnoApp.controller 'NotificationCtrl', NotificationCtrl
