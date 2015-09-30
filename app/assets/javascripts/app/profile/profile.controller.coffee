ProfileCtrl = ($http, SessionManager) ->
  @user = SessionManager.currentUser()

  @update = ->
    @submitting = $http.patch("/api/v1/users", user: @user).then(successFn, failureFn)

  successFn = (response) ->
    @success = true
    @error = false
    SessionManager.setCurrentUser(response.data)

  failureFn = (response) ->
    @error = true
    @success = false

  @

ProfileCtrl.$inject = ['$http', 'SessionManager']

angular
  .module('app.profile')
  .controller('ProfileCtrl', ProfileCtrl)
