systemNotification = ($compile, $templateCache) ->
  systemNotificationCtrl = ($state, AnalyticsTracker) ->
    vm = this
    markAsRead = ->
      vm.notification.get().then (notification) ->
        vm.notification = notification

    trackClick = ->
      AnalyticsTracker.systemNotificationClicked(vm.notification)

    vm.trackAndMarkAsRead = ->
      trackClick()
      markAsRead()

    vm.reload = ->
      $state.go($state.current.name, $state.params, { reload: true })

    vm

  systemNotificationCtrl.$inject = ['$state', 'AnalyticsTracker']

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
