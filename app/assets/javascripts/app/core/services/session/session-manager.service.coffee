SessionManager = ($http, $q, $analytics, LocalStorageWrapper) ->
  setCurrentUser = (user) ->
    $analytics.setUsername(user.id)
    $analytics.setUserProperties
      $email: user.email
      $name: user.name
      $created: user.created_at
      profile: user.profile
      coursesCount: user.courses_count
      studentsCount: user.students_count
      notificationsCount: user.notifications_count
    LocalStorageWrapper.set 'currentUser', user
  removeCurrentUser = -> LocalStorageWrapper.remove('currentUser')
  currentUser = -> LocalStorageWrapper.get('currentUser')

  signIn = (user) ->
    deferred = $q.defer()
    $http.post("/api/v1/users/sign_in.json", user: user).then((response) ->
      setCurrentUser(response.data)
      deferred.resolve(response.data)
    ).catch((response) -> deferred.reject(response.data))
    deferred.promise

  signOut = ->
    deferred = $q.defer()
    $http.delete('/api/v1/users/sign_out.json').then ->
      removeCurrentUser()
      deferred.resolve()
    deferred.promise

  fetchUser = ->
    $http.get('/api/v1/users/profile.json').then (response) ->
      setCurrentUser(response.data)

  {
    signIn: signIn
    signOut: signOut
    currentUser: currentUser
    setCurrentUser: setCurrentUser
    fetchUser: fetchUser
  }

SessionManager.$inject = ['$http', '$q', '$analytics', 'LocalStorageWrapper']

angular
  .module('app.core')
  .factory('SessionManager', SessionManager)
