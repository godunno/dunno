DunnoApp = angular.module('DunnoApp')

NotificationCtrl = ($scope, $timeout, Notification) ->
  $scope.limit = 140

  ($scope.reset = ->
    $scope.notification = new Notification()
    $scope.errors = {}
  )()

  $scope.save = (notification)->
    $scope.sending = true
    $scope.error = false
    notification.course_id = $scope.$parent.course.uuid
    notification.save().then(->
      $scope.reset()
      $scope.$broadcast('modal.dismiss')
    ).catch((response)->
      $scope.errors = response.data.errors
    ).finally(-> $scope.sending = false)

DunnoApp.controller 'NotificationCtrl', NotificationCtrl
