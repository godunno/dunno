ConfirmCloneCourseCtrl = (
  $scope,
  $state,
  $stateParams,
  Course,
  AnalyticsTracker,
  course
) ->
  course.name = $stateParams.name if $stateParams.name?
  course.start_date = $stateParams.startDate if $stateParams.startDate?
  course.end_date = $stateParams.endDate if $stateParams.endDate?

  AnalyticsTracker.courseCloneConfirmationAccessed(course)

  $scope.course = new Course(course)

  success = (course) ->
    $state.go('app.courses.show.events', { courseId: course.uuid }, { reload: true })

  failure = -> $scope.error = "Ocorreu um erro ao clonar essa disciplina"

  $scope.clone = ->
    AnalyticsTracker.courseCloneConfirmed(course)
    $scope.submitting = course.clone().then success, failure

ConfirmCloneCourseCtrl.$inject = [
  '$scope',
  '$state',
  '$stateParams',
  'Course',
  'AnalyticsTracker',
  'course'
]

angular
  .module('app.courses')
  .controller('ConfirmCloneCourseCtrl', ConfirmCloneCourseCtrl)
