DunnoApp = angular.module('DunnoApp')

CourseCtrl = ($scope, Course, $location, $routeParams, Utils)->
  angular.extend($scope, Utils)

  $scope.course = new Course()
  $scope.course.weekly_schedules = [{}]
  if $routeParams.id
    Course.get(uuid: $routeParams.id).then (course)->
      $scope.course = course
  $scope.save = (course)->
    course.save().then ->
      $location.path '#/courses'
CourseCtrl.$inject = ['$scope', 'Course', '$location', '$routeParams', 'Utils']
DunnoApp.controller 'CourseCtrl', CourseCtrl

