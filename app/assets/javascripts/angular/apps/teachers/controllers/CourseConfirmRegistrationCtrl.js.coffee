DunnoApp = angular.module('DunnoApp')

CourseConfirmRegistrationCtrl = ($scope, $state, Course, SessionManager, course)->
  $scope.course = course

  $scope.register = (course)->
    $scope.$emit('wholePageLoading', course.register().then ->
      SessionManager.fetchUser().then ->
        $state.go 'courses', {}, reload: true
    )

CourseConfirmRegistrationCtrl.$inject = ['$scope', '$state', 'Course', 'SessionManager', 'course']
DunnoApp.controller 'CourseConfirmRegistrationCtrl', CourseConfirmRegistrationCtrl

