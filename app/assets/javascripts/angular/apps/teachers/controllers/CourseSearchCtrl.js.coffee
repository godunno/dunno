DunnoApp = angular.module('DunnoApp')

CourseSearchCtrl = ($scope, $location, Course, SessionManager, PageLoading)->
  $scope.search = (accessCode)->
    if (SessionManager.currentUser().courses.indexOf accessCode) != -1
      $location.path "/courses/#{accessCode}"
    else
      $scope.error = false
      PageLoading.resolve Course.search(accessCode).then((course)->
        $location.path "/courses/#{accessCode}/confirm_registration"
      ).catch ->
        $scope.error = true

CourseSearchCtrl.$inject = ['$scope', '$location', 'Course', 'SessionManager', 'PageLoading']
DunnoApp.controller 'CourseSearchCtrl', CourseSearchCtrl
