DunnoAppStudent = angular.module('DunnoAppStudent')

CourseCatalogCtrl = ($scope, MediaSearcher)->
  MediaSearcher.extend($scope)

  $scope.searchParams =
    per_page: 5
    course_uuid: $scope.course.uuid

  $scope.fetch()

CourseCatalogCtrl.$inject = ['$scope', 'MediaSearcher']
DunnoAppStudent.controller 'CourseCatalogCtrl', CourseCatalogCtrl
