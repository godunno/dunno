angular
  .module 'app.core', [
    'ngResource',
    'rails',
    'ngMessages',
    'ngAnimate',
    'angular.filter',
    'angularFileUpload',
    'angularMoment',
    'angulartics',
    'angulartics.google.analytics',
    'angulartics.intercom',
    'angulartics.mixpanel',
    'cgBusy',
    'datePicker',
    'foundation',
    'ui.router',
    'ui.timepicker',
    'ui.utils.masks']

#WIP
core = angular.module('app.core')

core.config(["railsSerializerProvider", (railsSerializerProvider) ->
  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity)
])

core.value('cgBusyDefaults',
  templateUrl: 'core/components/loading',
  minDuration: 500,
  wrapperClass: 'cg-busy cg-busy-animation ng-animate'
)

core.config ['$animateProvider', ($animateProvider) ->
  $animateProvider.classNameFilter(/ng-animate/)
]

core.run ['amMoment', (amMoment) ->
  amMoment.changeLocale('pt-br')
]

core.constant 'angularMomentConfig',
  timezone: 'America/Sao_Paulo'

checkProfile = ($rootScope, $window, SessionManager, NonLoggedRoutes) ->
  $rootScope.$on '$stateChangeSuccess', (ev, data) ->
    rootPath = SessionManager.currentUser()?.root_path
    if !NonLoggedRoutes.isNonLoggedRoute() && rootPath? && rootPath != $window.location.pathname
      $window.location.href = rootPath

checkProfile.$inject = ['$rootScope', '$window', 'SessionManager', 'NonLoggedRoutes']
core.run checkProfile