NewPasswordRecoveryCtrl = ($http, PageLoading, FoundationApi) ->
  @user = {}

  @recoverPassword = (user) =>
    PageLoading.resolve($http.post("/users/password", user: user)).finally =>
      FoundationApi.publish 'main-notifications',
        content: """
        Instruções enviadas para #{user.email}.
        Não esqueça de verificar sua caixa de SPAM!
        """
      @user = {}

  @

NewPasswordRecoveryCtrl.$inject = ['$http', 'PageLoading', 'FoundationApi']

angular
  .module('app.profile')
  .controller('NewPasswordRecoveryCtrl', NewPasswordRecoveryCtrl)
