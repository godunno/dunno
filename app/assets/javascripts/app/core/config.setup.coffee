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
  $sceDelegateProvider) ->

  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity)
  $urlRouterProvider.otherwise('/courses')
  $translateProvider.preferredLanguage('pt-BR')
  $translateProvider.useSanitizeValueStrategy('escape')

  $sceDelegateProvider.resourceUrlWhitelist [
    'self'
    'http://dunno-*.s3.amazonaws.com/assets/**'
  ]

configure.$inject = [
  'railsSerializerProvider',
  '$animateProvider',
  '$urlRouterProvider',
  '$translateProvider',
  '$sceDelegateProvider']

run = (amMoment, $rootScope, $window, SessionManager, NonLoggedRoutes) ->
  redirectIfNotLoggedIn = ->
    $rootScope.$on '$stateChangeSuccess', (ev, data) ->
      rootPath = SessionManager.currentUser()?.root_path
      if !NonLoggedRoutes.isNonLoggedRoute() && rootPath? && rootPath != $window.location.pathname
        $window.location.href = rootPath

  redirectIfNotLoggedIn()

  amMoment.changeLocale 'pt-br',
    months:
      'Janeiro_Fevereiro_Março_Abril_Maio_Junho_Julho_Agosto_Setembro_Outubro_Novembro_Dezembro'
        .split('_')
    monthsShort: 'Jan_Fev_Mar_Abr_Mai_Jun_Jul_Ago_Set_Out_Nov_Dez'.split('_')
    weekdays:
      'Domingo_Segunda-Feira_Terça-Feira_Quarta-Feira_Quinta-Feira_Sexta-Feira_Sábado'
        .split('_')
    weekdaysShort: 'Dom_Seg_Ter_Qua_Qui_Sex_Sáb'.split('_')
    weekdaysMin: 'Dom_2ª_3ª_4ª_5ª_6ª_Sáb'.split('_')
    longDateFormat:
      LT: 'HH:mm'
      LTS: 'HH:mm:ss'
      L: 'DD/MM/YYYY'
      LL: 'D [de] MMMM [de] YYYY'
      LLL: 'D [de] MMMM [de] YYYY [às] HH:mm'
      LLLL: 'dddd, D [de] MMMM [de] YYYY [às] HH:mm'
    calendar:
      sameDay: '[Hoje às] LT'
      nextDay: '[Amanhã às] LT'
      nextWeek: 'dddd [às] LT'
      lastDay: '[Ontem às] LT'
      lastWeek: ->
        if @day() == 0 or @day() == 6
          '[Último] dddd [às] LT'
        else
          '[Última] dddd [às] LT'
      sameElse: 'L'
    relativeTime:
      future: 'em %s'
      past: 'há %s atrás'
      s: 'poucos segundos'
      m: 'um minuto'
      mm: '%d minutos'
      h: 'uma hora'
      hh: '%d horas'
      d: 'um dia'
      dd: '%d dias'
      M: 'um mês'
      MM: '%d meses'
      y: 'um ano'
      yy: '%d anos'
    ordinalParse: /\d{1,2}º/
    ordinal: '%dº'

run.$inject = ['amMoment', '$rootScope', '$window', 'SessionManager', 'NonLoggedRoutes']

angular
  .module('app.core')
  .value('cgBusyDefaults', cgBusyDefaults)
  .constant('angularMomentConfig', angularMomentConfig)
  .config(configure)
  .run(run)
