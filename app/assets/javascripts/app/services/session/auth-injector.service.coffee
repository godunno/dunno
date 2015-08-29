DunnoApp = angular.module('DunnoApp')

AuthInjector = ($window, $q, NonLoggedRoutes)->
  responseError: (response)->
    if response.status == 401 && !NonLoggedRoutes.isNonLoggedRoute()
      $window.location.href = '/sign_in'
    $q.reject(response)

AuthInjector.$inject = ['$window', '$q', 'NonLoggedRoutes']
DunnoApp.factory 'AuthInjector',  AuthInjector
DunnoApp.config ['$httpProvider', ($httpProvider)->
  $httpProvider.interceptors.push('AuthInjector')
]
