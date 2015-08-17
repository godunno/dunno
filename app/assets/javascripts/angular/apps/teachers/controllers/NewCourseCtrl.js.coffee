NewCourseCtrl = ($scope, $state, $modalInstance, Course, PageLoading) ->
  $scope.course = new Course()

  $scope.save = =>
    PageLoading.resolve($scope.course.save()).then (course) ->
      $state.go('.', null, reload: true)
      $modalInstance.close()

NewCourseCtrl.$inject = ['$scope', '$state', '$modalInstance', 'Course', 'PageLoading']
angular.module('DunnoApp')
  .controller 'NewCourseCtrl', NewCourseCtrl
