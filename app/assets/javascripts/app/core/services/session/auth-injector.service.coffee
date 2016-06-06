AuthInjector = ($window, $q, NonLoggedRoutes) ->
  responseError: (response) ->
    if response.status == 401 && !NonLoggedRoutes.isNonLoggedRoute()
      $window.location.href = "/sign_in?redirectTo=#{encodeURIComponent($window.location.href)}"
    $q.reject(response)

AuthInjector.$inject = ['$window', '$q', 'NonLoggedRoutes']

config = ($httpProvider) ->
  $httpProvider.interceptors.push('AuthInjector')

config.$inject = ['$httpProvider']

angular
  .module('app.core')
  .factory('AuthInjector', AuthInjector)
  .config(config)
