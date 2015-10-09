SystemNotification = (RailsResource) ->
  class SystemNotification extends RailsResource
    @configure(
      url: '/api/v1/system_notifications'
      name: 'system_notification'
    )

SystemNotification.$inject = ['RailsResource']

angular
  .module('app.core')
  .factory('SystemNotification', SystemNotification)
