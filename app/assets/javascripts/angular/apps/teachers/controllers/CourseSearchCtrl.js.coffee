DunnoApp = angular.module('DunnoApp')

CourseSearchCtrl = ($scope, $location, Course, SessionManager, PageLoading)->
  $scope.search = (access_code)->
    if (SessionManager.currentUser().courses.indexOf access_code) != -1
      $location.path "/courses/#{access_code}"
    else
      $scope.error = false
      PageLoading.resolve Course.search(access_code).then((course)->
        $location.path "/courses/#{access_code}/confirm_registration"
      ).catch ->
        $scope.error = true

CourseSearchCtrl.$inject = ['$scope', '$location', 'Course', 'SessionManager', 'PageLoading']
DunnoApp.controller 'CourseSearchCtrl', CourseSearchCtrl
