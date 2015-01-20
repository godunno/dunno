DunnoApp = angular.module('DunnoAppStudent')

CourseCtrl = ($scope, $location, $routeParams, Course, DateUtils)->
  angular.extend($scope, DateUtils)

  $scope.course = new Course()
  if $routeParams.id
    Course.get(access_code: $routeParams.id).then (course)->
      $scope.course = course
  $scope.search = (access_code)->
    $scope.error = false
    Course.get(access_code: access_code).then((course)->
      $location.path "/courses/#{access_code}/confirm_registration"
    , -> $scope.error = true
    )
  $scope.register = (course)->
    course.register().then ->
      $location.path "/courses"
  $scope.eventPath = (event)-> "#/events/#{event.uuid}"
CourseCtrl.$inject = [
  '$scope', '$location', '$routeParams', 'Course', 'DateUtils'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

