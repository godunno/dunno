CourseConfirmRegistrationCtrl = ($scope, $state, PageLoading, course) ->
  $scope.course = course

  $scope.register = (course) ->
    PageLoading.resolve course.register()
    .then(goToCourses)
    .catch(handleErrors)

  goToCourses = ->
    $state.go 'courses', {}, reload: true

  handleErrors = (err) ->
    switch err.status
      when 404
        $scope.error = "Código de disciplina não existe. Verifique e tente novamente."
      when 422
        $scope.error = err.data.errors.unprocessable
      else
        $scope.error = "Ocorreu um erro. Tente novamente mais tarde ou entre em contato. "


CourseConfirmRegistrationCtrl.$inject = ['$scope', '$state', 'PageLoading', 'course']

angular
  .module('DunnoApp')
  .controller 'CourseConfirmRegistrationCtrl', CourseConfirmRegistrationCtrl

