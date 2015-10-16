SystemNotificationsCtrl = ($scope, SystemNotification, systemNotifications) ->
  vm = @

  vm.systemNotifications = systemNotifications

  vm.markAllAsRead = ->
    SystemNotification.markAllAsRead().then (systemNotifications) ->
      vm.systemNotifications = systemNotifications

  SystemNotification.viewed().then ->
    $scope.$emit('$stateChangeStart')

  vm

SystemNotificationsCtrl.$inject = ['$scope', 'SystemNotification', 'systemNotifications']

angular
  .module('app.system-notifications')
  .controller('SystemNotificationsCtrl', SystemNotificationsCtrl)
