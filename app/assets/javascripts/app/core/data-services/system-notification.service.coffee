SystemNotification = (RailsResource, $http) ->
  class SystemNotification extends RailsResource
    @configure(
      url: '/api/v1/system_notifications'
      name: 'system_notification'
    )

    @viewed: ->
      @$patch(@$url('viewed'))

    @markAllAsRead: ->
      @$post(@$url('mark_all_as_read'))

    @newNotifications: ->
      $http.get(@$url('new_notifications')).then (response) ->
        response.data.new_notifications_count

  SystemNotification

SystemNotification.$inject = ['RailsResource', '$http']

angular
  .module('app.core')
  .factory('SystemNotification', SystemNotification)
