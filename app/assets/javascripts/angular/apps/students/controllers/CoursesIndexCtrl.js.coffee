DunnoApp = angular.module('DunnoAppStudent')

CoursesIndexCtrl = ($scope, Course, $location, Utils) ->
  $scope.$emit 'wholePageLoading', Course.query().then (courses) ->
    $scope.courses = courses

  $scope.unregister = (course) ->
    if confirm("Deseja mesmo sair da disciplina #{course.name}?")
      course.unregister().then ->
        Utils.remove($scope.courses, course)
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl
