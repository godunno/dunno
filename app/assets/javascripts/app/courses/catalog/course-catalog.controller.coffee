CourseCatalogCtrl = ($scope, MediaSearcher) ->
  MediaSearcher.extend($scope)
  $scope.fetch()

  courseFor = (media) ->
    media.courses.filter((course) -> course.uuid == $scope.course.uuid)[0]

  $scope.eventFor = (media) ->
    courseFor(media).events[0]

  $scope.remove = (media) ->
    message = """
      Você tem certeza de que deseja remover este material?
      Esta ação não poderá ser desfeita.
    """
    if confirm(message)
      media.remove().then -> $scope.fetch()

CourseCatalogCtrl.$inject = ['$scope', 'MediaSearcher']

angular
  .module('app.courses')
  .controller('CourseCatalogCtrl', CourseCatalogCtrl)
