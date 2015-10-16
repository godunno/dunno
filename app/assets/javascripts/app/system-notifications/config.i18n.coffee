I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'system-notifications':
      'title':
        'system-notifications': 'Notificações'

I18nConfig.$inject = ['$translateProvider']
angular
  .module('app.system-notifications')
  .config(I18nConfig)
