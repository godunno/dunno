DunnoApp = angular.module('DunnoApp')

CoursesIndexCtrl = ($scope, Course, $routeParams)->
  Course.query().then (courses)->
    $scope.courses = courses
  $scope.delete = (course)->
    course.delete().then (response)->
      $scope.courses.splice($scope.courses.indexOf(course), 1)
CoursesIndexCtrl.$inject = ['$scope', 'Course', '$routeParams']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl

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

