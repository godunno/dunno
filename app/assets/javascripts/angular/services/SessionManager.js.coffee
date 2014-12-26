DunnoApp = angular.module('DunnoApp')

SessionManager = ($http, $q)->

  setCurrentUser = (user)->
    localStorage.setItem 'currentUser', angular.toJson(user)
  removeCurrentUser = -> localStorage.removeItem('currentUser')
  currentUser = -> angular.fromJson(localStorage.getItem('currentUser'))

  signIn = (user)->
    deferred = $q.defer()
    $http.post("/api/v1/users/sign_in.json", user: user).then (response)->
      if response.status == 200
        setCurrentUser(response.data)
        deferred.resolve(response.data)
      else
        deferred.reject(response.data)
    deferred.promise

  signOut = ->
    deferred = $q.defer()
    $http.delete('/api/v1/users/sign_out.json').then ->
      removeCurrentUser()
      deferred.resolve()
    deferred.promise

  fetchUser = ->
    $http.get('/api/v1/users/profile.json').then (response)->
      if response.status == 200
        setCurrentUser(response.data)

  {
    signIn: signIn
    signOut: signOut
    currentUser: currentUser
    fetchUser: fetchUser
  }

SessionManager.$inject = ['$http', '$q']
DunnoApp.factory "SessionManager", SessionManager
