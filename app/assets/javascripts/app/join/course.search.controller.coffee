CourseSearchCtrl = ($scope, $state, Course, PageLoading) ->
  $scope.search = (accessCode) ->
    PageLoading.resolve Course.search(accessCode)
    .then(goToConfirmation(accessCode))
    .catch(handleErrors)

  goToConfirmation = (accessCode) ->
    $state.go '^.confirm_registration', { id: accessCode }

  handleErrors = (err) ->
    switch err.status
      when 404
        $scope.error = "Código de disciplina não existe. Verifique e tente novamente."
      when 422
        $scope.error = err.data.errors.unprocessable
      else
        $scope.error = "Ocorreu um erro. Tente novamente mais tarde ou entre em contato. "

CourseSearchCtrl.$inject = ['$scope', '$state', 'Course', 'PageLoading']

angular
  .module('app.join')
  .controller 'CourseSearchCtrl', CourseSearchCtrl
