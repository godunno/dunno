SystemNotificationsCtrl = ($scope, $http, systemNotifications) ->
  vm = @

  vm.systemNotifications = systemNotifications

  $http.patch('/api/v1/system_notifications/viewed.json').then ->
    $scope.$emit('$stateChangeStart')

  vm

SystemNotificationsCtrl.$inject = ['$scope', '$http', 'systemNotifications']

angular
  .module('app.system-notifications')
  .controller('SystemNotificationsCtrl', SystemNotificationsCtrl)
