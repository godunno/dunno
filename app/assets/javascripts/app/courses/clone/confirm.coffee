ConfirmCloneCourseCtrl = (
  $scope,
  $state,
  $stateParams,
  Course,
  course
) ->
  course.name = $stateParams.name if $stateParams.name?
  course.start_date = $stateParams.startDate if $stateParams.startDate?
  course.end_date = $stateParams.endDate if $stateParams.endDate?

  $scope.course = new Course(course)

  success = (course) ->
    $state.go('app.courses.show.events', { courseId: course.uuid })

  failure = -> $scope.error = "Ocorreu um erro ao clonar essa disciplina"

  $scope.clone = ->
    $scope.submitting = course.clone().then success, failure

ConfirmCloneCourseCtrl.$inject = [
  '$scope',
  '$state',
  '$stateParams',
  'Course',
  'course'
]

angular
  .module('app.courses')
  .controller('ConfirmCloneCourseCtrl', ConfirmCloneCourseCtrl)
