DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

SessionManager = ($http, $q, $analytics)->

  setCurrentUser = (user)->
    $analytics.setUsername(user.id)
    $analytics.setUserPropertiesOnce
      $email: user.email
      $name: user.name
      $phone: user.phone_number
      profile: user.profile
      coursesCount: user.courses_count
      studentsCount: user.students_count
      notificationsCount: user.notifications_count
    localStorage.setItem 'currentUser', angular.toJson(user)
  removeCurrentUser = -> localStorage.removeItem('currentUser')
  currentUser = -> angular.fromJson(localStorage.getItem('currentUser'))

  signIn = (user)->
    deferred = $q.defer()
    $http.post("/api/v1/users/sign_in.json", user: user).then((response)->
      setCurrentUser(response.data)
      deferred.resolve(response.data)
    ).catch((response)-> deferred.reject(response.data))
    deferred.promise

  signOut = ->
    deferred = $q.defer()
    $http.delete('/api/v1/users/sign_out.json').then ->
      removeCurrentUser()
      deferred.resolve()
    deferred.promise

  fetchUser = ->
    $http.get('/api/v1/users/profile.json').then (response)->
      setCurrentUser(response.data)

  {
    signIn: signIn
    signOut: signOut
    currentUser: currentUser
    setCurrentUser: setCurrentUser
    fetchUser: fetchUser
  }

SessionManager.$inject = ['$http', '$q', '$analytics']
DunnoApp.factory "SessionManager", SessionManager
DunnoAppStudent.factory "SessionManager", SessionManager
