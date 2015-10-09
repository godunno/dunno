systemNotification = ->
  restrict: 'E'
  templateUrl: 'system-notifications/system-notification.directive'
  scope:
    notification: '='

angular
  .module('app.system-notifications')
  .directive('systemNotification', systemNotification)
