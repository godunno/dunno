CourseCatalogCtrl = ($scope, MediaSearcher) ->
  MediaSearcher.extend($scope)
  $scope.fetch()

  courseFor = (media) ->
    media.courses.filter((course) -> course.uuid == $scope.course.uuid)[0]

  $scope.eventFor = (media) ->
    courseFor(media).events[0]

CourseCatalogCtrl.$inject = ['$scope', 'MediaSearcher']

angular
  .module('app.courses')
  .controller('CourseCatalogCtrl', CourseCatalogCtrl)
