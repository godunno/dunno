EditCourseCtrl = ($scope, $modalInstance, $state, PageLoading, course) ->
  $scope.course = course

  $scope.save = ->
    PageLoading.resolve($scope.course.save()).then (course) ->
      $modalInstance.close()
      $state.go('.', null, reload: true)

EditCourseCtrl.$inject = ['$scope', '$modalInstance', '$state', 'PageLoading', 'course']

angular
  .module('DunnoApp')
  .controller('EditCourseCtrl', EditCourseCtrl)
