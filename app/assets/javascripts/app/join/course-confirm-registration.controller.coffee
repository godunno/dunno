CourseConfirmRegistrationCtrl = ($scope, $state, AnalyticsTracker, PageLoading, course) ->
  $scope.course = course

  $scope.register = (course) ->
    PageLoading.resolve course.register()
    .then(track)
    .then(goToCourses)
    .catch(handleErrors)

  track = (course) ->
    AnalyticsTracker.courseJoined(course)

  goToCourses = ->
    $state.go '^', {}, reload: true

  handleErrors = (err) ->
    switch err.status
      when 404
        $scope.error = "Código de disciplina não existe. Verifique e tente novamente."
      when 422
        $scope.error = err.data.errors.unprocessable
      else
        $scope.error = "Ocorreu um erro. Tente novamente mais tarde ou entre em contato. "


CourseConfirmRegistrationCtrl.$inject = ['$scope', '$state', 'AnalyticsTracker', 'PageLoading', 'course']

angular
  .module('app.join')
  .controller 'CourseConfirmRegistrationCtrl', CourseConfirmRegistrationCtrl

