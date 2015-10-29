systemNotifications = ->
  restrict: 'E'
  controller: 'SystemNotificationsCtrl as vm'
  templateUrl: 'system-notifications/system-notifications.directive'

angular
  .module('app.system-notifications')
  .directive('systemNotifications', systemNotifications)
