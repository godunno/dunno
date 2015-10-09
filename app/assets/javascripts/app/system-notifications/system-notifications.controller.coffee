SystemNotificationsCtrl = (systemNotifications) ->
  vm = @

  vm.systemNotifications = systemNotifications

  vm

SystemNotificationsCtrl.$inject = ['systemNotifications']

angular
  .module('app.system-notifications')
  .controller('SystemNotificationsCtrl', SystemNotificationsCtrl)
