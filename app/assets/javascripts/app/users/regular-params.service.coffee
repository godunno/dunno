regularParams = ($window) ->

  getParameterByName = (name, url) ->
    url = $window.location.href if !url
    name = name.replace(/[\[\]]/g, "\\$&")
    regex = new $window.RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)")
    results = regex.exec(url)
    return null if !results
    return '' if !results[2]
    return $window.decodeURIComponent(results[2].replace(/\+/g, " "))

  return { get: getParameterByName }

regularParams.$inject = ['$window']

angular
  .module('app.users')
  .factory('regularParams', regularParams)
