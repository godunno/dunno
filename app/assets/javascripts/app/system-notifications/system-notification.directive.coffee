systemNotification = ->
  systemNotificationCtrl = ->
    @viewPath = "system-notifications/#{@notification.notification_type.replace('_', '-')}"
    @author = @notification.author

    if @notification.notification_type == 'new_comment'
      @comment = @notification.notifiable
      @event = @comment.event
      @course = @event.course

    if @notification.notification_type.match /^event_published|event_canceled$/
      @event = @notification.notifiable
      @course = @event.course

  restrict: 'E'
  templateUrl: 'system-notifications/system-notification.directive'
  controller: systemNotificationCtrl
  controllerAs: 'vm'
  bindToController: true
  scope:
    notification: '='

angular
  .module('app.system-notifications')
  .directive('systemNotification', systemNotification)
