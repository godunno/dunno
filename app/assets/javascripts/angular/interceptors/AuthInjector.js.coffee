DunnoApp = angular.module('DunnoApp')

AuthInjector = ($window, $q)->
  responseError: (response)->
    sign_in_path = '/sign_in'
    if response.status == 401 && $window.location.pathname != sign_in_path
      $window.location.href = sign_in_path
    $q.reject(response)

AuthInjector.$inject = ['$window', '$q']
DunnoApp.factory 'AuthInjector',  AuthInjector
DunnoApp.config ['$httpProvider', ($httpProvider)->
  $httpProvider.interceptors.push('AuthInjector')
]
