cgBusyDefaults =
  templateUrl: 'core/components/loading',
  wrapperClass: 'cg-busy cg-busy-animation'

angularMomentConfig =
  timezone: 'America/Sao_Paulo'

configure = (railsSerializerProvider, $animateProvider, $urlRouterProvider) ->
  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity)
  $urlRouterProvider.otherwise('/courses')

configure.$inject = ['railsSerializerProvider', '$animateProvider', '$urlRouterProvider']

run = (amMoment, $rootScope, $window, SessionManager, NonLoggedRoutes) ->
  redirectIfNotLoggedIn = ->
    $rootScope.$on '$stateChangeSuccess', (ev, data) ->
      rootPath = SessionManager.currentUser()?.root_path
      if !NonLoggedRoutes.isNonLoggedRoute() && rootPath? && rootPath != $window.location.pathname
        $window.location.href = rootPath

  amMoment.changeLocale('pt-br')
  redirectIfNotLoggedIn()

run.$inject = ['amMoment', '$rootScope', '$window', 'SessionManager', 'NonLoggedRoutes']

angular
  .module('app.core')
  .value('cgBusyDefaults', cgBusyDefaults)
  .constant('angularMomentConfig', angularMomentConfig)
  .config(configure)
  .run(run)
