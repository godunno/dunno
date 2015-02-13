DunnoApp = angular.module('DunnoAppStudent')

CourseCtrl = ($scope, $location, $routeParams, Course, DateUtils)->
  angular.extend($scope, DateUtils)

  $scope.hideEvent = (event)-> event.formatted_status == 'empty'
  $scope.course = new Course()

  $scope.fetch = (month)->
    $scope.$emit('wholePageLoading', Course.get({ access_code: $routeParams.id }, { month: month || $routeParams.month }).then (course)->
      $scope.course = course
      $location.search('month', month)
    )

  if $routeParams.id
    $scope.fetch()

  $scope.search = (access_code)->
    $scope.error = false
    $scope.$emit('wholePageLoading', Course.get(access_code: access_code).then (course)->
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

