courseCard = ->
  courseCardCtrl = ($scope, $state, PageLoading) ->
    window.$state = $state
    $scope.isStudent = (course) ->
      course.user_role == 'student'

    $scope.unregister = ($event, course) ->
      $event.stopPropagation()
      PageLoading.resolve course.unregister().then -> $state.reload()

  courseCardCtrl.$inject = ['$scope', '$state', 'PageLoading']
  templateUrl: 'core/components/course-card.directive'
  restrict: 'E'
  controller: courseCardCtrl

angular
  .module('app.core')
  .directive('courseCard', courseCard)
