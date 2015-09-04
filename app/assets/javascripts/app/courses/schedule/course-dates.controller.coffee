CourseDatesCtrl = ($scope, $state, $modalInstance, course) ->
  $scope.course = course
  $scope.save = (course) ->
    $scope.$emit('wholePageLoading', course.save().then ->
      $modalInstance.close()
      $state.go('.', null, reload: true)
    )

  $scope.close = -> $modalInstance.close()

  $scope.removeEndDate = ->
    $scope.course.end_date = null

CourseDatesCtrl.$inject = ['$scope', '$state', '$modalInstance', 'course']

angular
  .module('app.courses')
  .controller('CourseDatesCtrl', CourseDatesCtrl)
