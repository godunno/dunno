DunnoApp = angular.module('DunnoApp')

AuthInjector = ($window, $q)->
  responseError: (response)->
    whitelistedPaths = ['/sign_in', '/sign_up']
    if response.status == 401 && whitelistedPaths.indexOf($window.location.pathname) == -1
      $window.location.href = '/sign_in'
    $q.reject(response)

AuthInjector.$inject = ['$window', '$q']
DunnoApp.factory 'AuthInjector',  AuthInjector
DunnoApp.config ['$httpProvider', ($httpProvider)->
  $httpProvider.interceptors.push('AuthInjector')
]
