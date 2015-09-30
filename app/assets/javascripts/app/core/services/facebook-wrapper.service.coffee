FacebookWrapper = ($http, Facebook, SessionManager) ->
  login = ->
    Facebook.login (response) ->
      $http.post('/users/auth/facebook/callback', response).then (response) ->
        SessionManager.setCurrentUser(response.data)

  login: login

FacebookWrapper.$inject = ['$http', 'Facebook', 'SessionManager']

angular
  .module('app.core')
  .factory('FacebookWrapper', FacebookWrapper)
