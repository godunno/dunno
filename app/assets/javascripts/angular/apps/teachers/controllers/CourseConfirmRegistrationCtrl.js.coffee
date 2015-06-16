DunnoApp = angular.module('DunnoApp')

CourseConfirmRegistrationCtrl = ($scope, $location, Course, SessionManager, course)->
  $scope.course = course

  $scope.register = (course)->
    $scope.$emit('wholePageLoading', course.register().then ->
      SessionManager.fetchUser().then ->
        $location.path "/courses"
    )

CourseConfirmRegistrationCtrl.$inject = ['$scope', '$location', 'Course', 'SessionManager', 'course']
DunnoApp.controller 'CourseConfirmRegistrationCtrl', CourseConfirmRegistrationCtrl

