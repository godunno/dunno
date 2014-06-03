DunnoApp = angular.module('DunnoApp')

CoursesIndexCtrl = ($scope, Course, $routeParams)->
  $scope.courses = Course.query()
  $scope.delete = (course)->
    course.$delete().then (response)->
      $scope.courses.splice($scope.courses.indexOf(course), 1)
CoursesIndexCtrl.$inject = ['$scope', 'Course', '$routeParams']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl

CourseCtrl = ($scope, Course, $location, $routeParams)->
  $scope.course = new Course()
  $scope.course = Course.get(id: $routeParams.id) if $routeParams.id
  $scope.course.weekdays ?= []

  $scope.weekdays = [
    { name:'Dom', value: 0 },
    { name:'Seg', value: 1 },
    { name:'Ter', value: 2 },
    { name:'Qua', value: 3 },
    { name:'Qui', value: 4 },
    { name:'Sex', value: 5 },
    { name:'Sáb', value: 6 },
  ]
  $scope.weekdayIndex = (weekday)->
    $scope.course.weekdays.indexOf(weekday.value)
  $scope.toggleWeekday = (weekday)->
    i = $scope.weekdayIndex(weekday)
    if i > -1
      $scope.course.weekdays.splice(i, 1)
    else
      $scope.course.weekdays.push(weekday.value)
    console.log $scope.course.weekdays

  $scope.save = (course)->
    course.$save().then (response)->
      $location.path '#/courses'
CourseCtrl.$inject = ['$scope', 'Course', '$location', '$routeParams']
DunnoApp.controller 'CourseCtrl', CourseCtrl

