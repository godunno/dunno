DunnoApp = angular.module('DunnoApp')

CourseCtrl = ($scope, Course, $location, $routeParams, Utils, DateUtils)->
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  $scope.course = new Course()
  $scope.course.weekly_schedules = [{}]
  if $routeParams.id
    Course.get(uuid: $routeParams.id).then (course)->
      $scope.course = formatToView(course)
  $scope.save = (course)->
    $scope.isSending = true
    course.save().then(->
      $location.path '#/courses'
    ).finally(-> $scope.isSending = false)

  $scope.delete = (course)->
    if confirm("Deseja mesmo remover a disciplina #{course.name}? Esta operação não poderá ser desfeita.")
      course.delete().then ->
        $location.path '#/courses'

  $scope.newRecord = ->
    !$scope.course.uuid

  $scope.teste = "2014-11-30"
  formatToView = (course)->
      course.start_date = $scope.formattedDate(course.start_date, 'dd/MM/yyyy')
      course.end_date   = $scope.formattedDate(course.end_date,   'dd/MM/yyyy')
      course

CourseCtrl.$inject = [
  '$scope', 'Course', '$location', '$routeParams', 'Utils', 'DateUtils'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

