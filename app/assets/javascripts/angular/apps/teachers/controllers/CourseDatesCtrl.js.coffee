DunnoApp = angular.module('DunnoApp')

CourseDatesCtrl = ($scope, $state, $modalInstance, course) ->
  $scope.course = course
  $scope.save = (course) ->
    $scope.$emit('wholePageLoading', course.save().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

CourseDatesCtrl.$inject = ['$scope', '$state', '$modalInstance', 'course']
DunnoApp.controller 'CourseDatesCtrl', CourseDatesCtrl
