DunnoApp = angular.module('DunnoAppStudent')

CoursesIndexCtrl = ($scope, Course, $location, Utils)->
  $scope.$emit('wholePageLoading', Course.query().then (courses)->
    $scope.courses = courses
    $location.path '/courses/search' unless courses.length > 0
  )

  $scope.unregister = (course)->
    if confirm("Deseja mesmo sair da disciplina #{course.name}?")
      course.unregister().then ->
        Utils.remove($scope.courses, course)
CoursesIndexCtrl.$inject = ['$scope', 'Course', '$location', 'Utils']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl
