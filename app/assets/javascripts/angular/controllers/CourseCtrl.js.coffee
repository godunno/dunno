DunnoApp = angular.module('DunnoApp')

CourseCtrl = ($scope, Course, $location, $routeParams)->
  $scope.course = new Course()
  if $routeParams.id
    $scope.course = Course.get(uuid: $routeParams.id)
    $scope.course.then (course)->
      $scope.course = course

  $scope.course.weekdays ?= []
  $scope.weekdays = ({ name: name, value: i } for name, i in ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'])
  $scope.weekdayIndex = (weekday)->
    $scope.course.weekdays.indexOf(weekday.value)
  $scope.toggleWeekday = (weekday)->
    i = $scope.weekdayIndex(weekday)
    if i > -1
      $scope.course.weekdays.splice(i, 1)
    else
      $scope.course.weekdays.push(weekday.value)

  $scope.save = (course)->
    course.save().then ->
      $location.path '#/courses'
CourseCtrl.$inject = ['$scope', 'Course', '$location', '$routeParams']
DunnoApp.controller 'CourseCtrl', CourseCtrl

