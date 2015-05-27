DunnoAppStudent = angular.module('DunnoAppStudent')

CourseMediasCtrl = ($scope, MediaSearcher)->
  MediaSearcher.extend($scope)

  $scope.searchParams =
    per_page: 5
    course_uuid: $scope.course.uuid

  $scope.fetch()

CourseMediasCtrl.$inject = ['$scope', 'MediaSearcher']
DunnoAppStudent.controller 'CourseMediasCtrl', CourseMediasCtrl
