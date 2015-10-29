SystemNotificationsCtrl = ($scope, $state, SystemNotification, systemNotifications) ->
  vm = @

  vm.systemNotifications = systemNotifications

  vm.markAllAsRead = ->
    SystemNotification.markAllAsRead().then (systemNotifications) ->
      vm.systemNotifications = systemNotifications

  window.$state = $state
  SystemNotification.viewed().then ->
    $scope.$emit('checkNewNotifications')

  vm

SystemNotificationsCtrl.$inject = ['$scope', '$state', 'SystemNotification', 'systemNotifications']

angular
  .module('app.system-notifications')
  .controller('SystemNotificationsCtrl', SystemNotificationsCtrl)
