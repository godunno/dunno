DunnoApp = angular.module('DunnoAppStudent')

CoursesIndexCtrl = ($scope, Course, $location, Utils)->
  Course.query().then (courses)->
    $scope.courses = courses
  $scope.unregister = (course)->
    if confirm("Deseja mesmo sair da disciplina #{course.name}?")
      course.unregister().then ->
        Utils.remove($scope.courses, course)
CoursesIndexCtrl.$inject = ['$scope', 'Course', '$location', 'Utils']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl
