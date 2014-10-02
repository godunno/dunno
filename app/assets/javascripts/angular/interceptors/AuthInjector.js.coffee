DunnoApp = angular.module('DunnoApp')

AuthInjector = ($window)->
  responseError: (response)->
    if response.status == 401
      $window.location.href = '/sign_in'

AuthInjector.$inject = ['$window']
DunnoApp.factory 'AuthInjector',  AuthInjector
DunnoApp.config ['$httpProvider', ($httpProvider)->
  $httpProvider.interceptors.push('AuthInjector')
]
