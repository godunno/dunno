FolderResolver = ($stateParams, PageLoading, Folder) ->
  PageLoading.resolve Folder.get({ id: $stateParams.folderId }, { course_id: $stateParams.courseId })

FolderResolver.$inject = ['$stateParams', 'PageLoading', 'Folder']

angular
  .module('app.courses')
  .constant('FolderResolver', FolderResolver)

