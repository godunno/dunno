SystemNotification = (RailsResource, $q) ->
  class SystemNotification extends RailsResource
    @configure(
      url: '/api/v1/system_notifications'
      name: 'system_notification'
    )

    @viewed: ->
      @$patch(@$url('viewed'))

    @newNotifications: ->
      deferred = $q.defer()
      SystemNotification.configure(fullResponse: true)

      @$get(@$url('new_notifications')).then (response) ->
        deferred.resolve(response.data.new_notifications_count)
      .catch ->
        deferred.reject(arguments...)
      .finally ->
        SystemNotification.configure(fullResponse: false)

      deferred.promise

    window.bla = @
  SystemNotification

SystemNotification.$inject = ['RailsResource', '$q']

angular
  .module('app.core')
  .factory('SystemNotification', SystemNotification)
