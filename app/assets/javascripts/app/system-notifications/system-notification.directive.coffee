systemNotification = ($compile, $templateCache) ->
  restrict: 'E'
  scope:
    notification: '='
  link: (scope, element, attrs) ->
    notificationType = scope.notification.notification_type.replace('_', '-')
    viewPath = "system-notifications/#{notificationType}"
    element.html($templateCache.get(viewPath)).show()
    $compile(element.contents())(scope)

systemNotification.$inject = ['$compile', '$templateCache']

angular
  .module('app.system-notifications')
  .directive('systemNotification', systemNotification)
