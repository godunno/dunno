SystemNotificationsResolver = (PageLoading, SystemNotification) ->
  PageLoading.resolve SystemNotification.query()

SystemNotificationsResolver.$inject = ['PageLoading', 'SystemNotification']

angular
  .module('app.system-notifications')
  .constant('SystemNotificationsResolver', SystemNotificationsResolver)
