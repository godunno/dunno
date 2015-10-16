setSystemNotificationsRoutes = (
  $stateProvider,
  SystemNotificationsResolver
) ->
  $stateProvider
    .state 'system-notifications',
      url: '/notifications'
      controller: 'SystemNotificationsCtrl as vm'
      templateUrl: 'system-notifications/system-notifications'
      resolve:
        systemNotifications: SystemNotificationsResolver
        $title: ['$translate', ($translate) ->
          $translate('system-notifications.title.system-notifications')
        ]

setSystemNotificationsRoutes.$inject = [
  '$stateProvider',
  'SystemNotificationsResolver'
]

angular
  .module('app.system-notifications')
  .config(setSystemNotificationsRoutes)
