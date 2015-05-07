DunnoApp = angular.module('DunnoAppStudent')

CoursesIndexCtrl = ($scope, $location, courses, Utils)->
  $scope.courses = courses

  $scope.unregister = (course)->
    if confirm("Deseja mesmo sair da disciplina #{course.name}?")
      course.unregister().then ->
        Utils.remove($scope.courses, course)
CoursesIndexCtrl.$inject = ['$scope', '$location', 'courses', 'Utils']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl
