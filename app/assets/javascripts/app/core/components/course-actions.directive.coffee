courseActions = ->
  courseActionsCtrl = ($scope, $state, PageLoading, ModalFactory) ->
    $scope.isStudent = (course) ->
      course.user_role == 'student'

    $scope.isTeacher = (course) ->
      course.user_role == 'teacher'

    $scope.unregister = (course) ->
      if confirm('Você tem certeza que deseja sair dessa disciplina?')
        PageLoading.resolve course.unregister().then ->
          $state.go('.', $state.params, reload: true)

    $scope.openEditCourseForm = (course) ->
      new ModalFactory
        templateUrl: 'courses/course-edit'
        controller: 'EditCourseCtrl'
        class: 'medium course__edit'
        controllerAs: 'vm'
        bindToController: true
        resolve: { course: -> angular.copy(course) }
        scope: $scope
      .activate()

  courseActionsCtrl.$inject = ['$scope', '$state', 'PageLoading', 'ModalFactory']
  templateUrl: 'core/components/course-actions.directive'
  restrict: 'E'
  controller: courseActionsCtrl

angular
  .module('app.core')
  .directive('courseActions', courseActions)
