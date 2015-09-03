AuthInjector = ($window, $q, NonLoggedRoutes) ->
  responseError: (response) ->
    if response.status == 401 && !NonLoggedRoutes.isNonLoggedRoute()
      $window.location.href = '/sign_in'
    $q.reject(response)

AuthInjector.$inject = ['$window', '$q', 'NonLoggedRoutes']

angular
  .module('app.core')
  .factory('AuthInjector', AuthInjector)
  .config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push('AuthInjector')
]
