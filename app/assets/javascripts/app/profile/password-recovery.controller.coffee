PasswordRecoveryCtrl = ($http, $window, FoundationApi, PageLoading) ->
  MATCH_RESET_PASSWORD_TOKEN = /reset_password_token=(.*)/

  @resetPasswordToken = MATCH_RESET_PASSWORD_TOKEN.exec(location.search)[1]
  @user = { reset_password_token: @resetPasswordToken }

  success = ->
    FoundationApi.publish 'main-notifications',
      content: 'Recuperação feita com sucesso! Redirecionando...'
    $window.location.href = '/dashboard'

  failure = (response) =>
    @error = if response.data?.errors?.reset_password_token?
               'reset_password_token'
             else
               'unexpected'

  @recoverPassword = (user) ->
    PageLoading.resolve($http.patch("/dashboard/password.json", user: user))
      .success(success).catch(failure)

  @

PasswordRecoveryCtrl.$inject = [
  '$http',
  '$window',
  'FoundationApi',
  'PageLoading'
]

angular
  .module('app.profile')
  .controller('PasswordRecoveryCtrl', PasswordRecoveryCtrl)
