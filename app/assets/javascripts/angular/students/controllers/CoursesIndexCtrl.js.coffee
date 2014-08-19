DunnoApp = angular.module('DunnoAppStudent')

CoursesIndexCtrl = ($scope, Course, $routeParams)->
  Course.query().then (courses)->
    $scope.courses = courses
CoursesIndexCtrl.$inject = ['$scope', 'Course', '$routeParams']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl
