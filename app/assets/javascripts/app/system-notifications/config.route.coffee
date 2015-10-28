setSystemNotificationsRoutes = (
  $stateProvider,
  SystemNotificationsResolver,
) ->
  $stateProvider
    .state 'panel.system-notifications',
      url: '/notifications'
      views:
        "panel":
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
