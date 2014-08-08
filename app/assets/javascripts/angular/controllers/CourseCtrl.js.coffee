DunnoApp = angular.module('DunnoApp')

CourseCtrl = ($scope, Course, $location, $routeParams, Utils, DateUtils)->
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  $scope.course = new Course()
  $scope.course.weekly_schedules = [{}]
  if $routeParams.id
    Course.get(uuid: $routeParams.id).then (course)->
      window.course = $scope.course = course
  $scope.save = (course)->
    course.save().then ->
      $location.path '#/courses'
CourseCtrl.$inject = [
  '$scope', 'Course', '$location', '$routeParams', 'Utils', 'DateUtils'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

