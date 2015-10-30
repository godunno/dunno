SystemNotificationsCtrl = ($scope, SystemNotification) ->
  vm = @

  setSystemNotifications = (systemNotifications) ->
    vm.systemNotifications = systemNotifications

  vm.loading = SystemNotification.query().then(setSystemNotifications)

  vm.markAllAsRead = ->
    SystemNotification.markAllAsRead().then (systemNotifications) ->
      vm.systemNotifications = systemNotifications

  vm.close = ->
    $scope.$emit('closeNotifications')

  SystemNotification.viewed().then ->
    $scope.$emit('checkNewNotifications')

  vm

SystemNotificationsCtrl.$inject = ['$scope', 'SystemNotification']

angular
  .module('app.system-notifications')
  .controller('SystemNotificationsCtrl', SystemNotificationsCtrl)
