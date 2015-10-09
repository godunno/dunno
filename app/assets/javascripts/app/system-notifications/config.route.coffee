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

# TODO: Find out why isn't this working on the config.i18n.coffee file
I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'system-notifications':
      'title':
        'system-notifications': 'Notificações'

I18nConfig.$inject = ['$translateProvider']
angular
  .module('app.system-notifications')
  .config(I18nConfig)
