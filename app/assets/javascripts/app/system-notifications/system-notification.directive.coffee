systemNotification = ($compile, $templateCache) ->
  systemNotificationCtrl = ->
    vm = this
    vm.markAsRead = ->
      vm.notification.get().then (notification) ->
        vm.notification = notification

    vm

  controller: systemNotificationCtrl
  controllerAs: 'vm'
  bindToController: true
  restrict: 'E'
  scope:
    notification: '='
  link: (scope, element, attrs) ->
    notificationType = scope.vm.notification.notification_type.replace('_', '-')
    viewPath = "system-notifications/#{notificationType}"
    element.html($templateCache.get(viewPath)).show()
    $compile(element.contents())(scope)

systemNotification.$inject = ['$compile', '$templateCache']

angular
  .module('app.system-notifications')
  .directive('systemNotification', systemNotification)
