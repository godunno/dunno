NewPasswordRecoveryCtrl = ($http, PageLoading, FoundationApi) ->
  @user = {}

  completed = =>
    FoundationApi.publish 'main-notifications',
      content: """
      Instruções enviadas para #{@user.email}.
      Não esqueça de verificar sua caixa de SPAM!
      """
    @user = {}

  @recoverPassword = (user) ->
    PageLoading.resolve($http.post("/dashboard/passwords", user: user))
      .finally(completed)

  @

NewPasswordRecoveryCtrl.$inject = ['$http', 'PageLoading', 'FoundationApi']

angular
  .module('app.profile')
  .controller('NewPasswordRecoveryCtrl', NewPasswordRecoveryCtrl)
