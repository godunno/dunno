DunnoApp = angular.module('DunnoApp')

CourseCtrl = ($scope, Course, $location, $routeParams, Utils, DateUtils)->
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  $scope.course = new Course()
  $scope.course.weekly_schedules = [{}]
  if $routeParams.id
    Course.get(uuid: $routeParams.id).then (course)->
      $scope.course = course
  $scope.save = (course)->
    course.save().then ->
      $location.path '#/courses'

  $scope.delete = (course)->
    if confirm("Deseja mesmo remover a disciplina #{course.name}? Esta operação não poderá ser desfeita.")
      course.delete().then ->
        $location.path '#/courses'

CourseCtrl.$inject = [
  '$scope', 'Course', '$location', '$routeParams', 'Utils', 'DateUtils'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

