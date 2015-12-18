CourseCatalogCtrl = (
  $scope,
  MediaSearcher,
  ModalFactory,
  FoldersResolver
) ->
  MediaSearcher.extend($scope)
  $scope.fetch()

  courseFor = (media) ->
    media.courses.filter((course) -> course.uuid == $scope.course.uuid)[0]

  $scope.eventFor = (media) ->
    courseFor(media).events[0]

  $scope.remove = (media) ->
    message = """
      Você tem certeza de que deseja remover este material?
      Esta ação também removerá este material de todas as
      aulas em que foi utilizado, e não poderá ser desfeita.
    """
    if confirm(message)
      media.remove().then -> $scope.fetch()

  reloadMedia = (media) ->
    (updatedMedia) -> media.folder_id = updatedMedia.folder_id

  $scope.changeFolder = (media) ->
    new ModalFactory
      templateUrl: 'courses/catalog/change-media-folder'
      controller: 'ChangeMediaFolderCtrl'
      controllerAs: 'vm'
      bindToController: true
      resolve:
        media: -> angular.copy(media)
        folders: FoldersResolver
        callback: -> reloadMedia(media)
      scope: $scope
    .activate()

CourseCatalogCtrl.$inject = [
  '$scope',
  'MediaSearcher',
  'ModalFactory',
  'FoldersResolver'
]

angular
  .module('app.courses')
  .controller('CourseCatalogCtrl', CourseCatalogCtrl)
