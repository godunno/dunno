cgBusyDefaults =
  templateUrl: 'core/components/loading',
  wrapperClass: 'cg-busy cg-busy-animation'

angularMomentConfig =
  timezone: 'America/Sao_Paulo'

configure = (
  railsSerializerProvider,
  $animateProvider,
  $urlRouterProvider,
  $translateProvider,
  $sceDelegateProvider,
  FacebookProvider,
  ENV) ->

  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity)
  $urlRouterProvider.otherwise('/courses')
  $translateProvider.preferredLanguage('pt-BR')
  $translateProvider.useSanitizeValueStrategy('escape')
  FacebookProvider.init
    appId: ENV.FACEBOOK_APP_ID
    locale: 'pt_BR'

  $sceDelegateProvider.resourceUrlWhitelist [
    'self'
    'http://dunno-*.s3.amazonaws.com/assets/**'
  ]

configure.$inject = [
  'railsSerializerProvider',
  '$animateProvider',
  '$urlRouterProvider',
  '$translateProvider',
  '$sceDelegateProvider',
  'FacebookProvider',
  'ENV']

run = (amMoment, $rootScope, $window, SessionManager, NonLoggedRoutes) ->
  redirectIfNotLoggedIn = ->
    $rootScope.$on '$stateChangeSuccess', (ev, data) ->
      rootPath = SessionManager.currentUser()?.root_path
      if !NonLoggedRoutes.isNonLoggedRoute() && rootPath? && rootPath != $window.location.pathname
        $window.location.href = rootPath

  amMoment.changeLocale('pt-br')
  redirectIfNotLoggedIn()

run.$inject = ['amMoment', '$rootScope', '$window', 'SessionManager', 'NonLoggedRoutes']

window.ENV = window.ENV || {}

angular
  .module('app.core')
  .constant('ENV', window.ENV)
  .value('cgBusyDefaults', cgBusyDefaults)
  .constant('angularMomentConfig', angularMomentConfig)
  .config(configure)
  .run(run)
