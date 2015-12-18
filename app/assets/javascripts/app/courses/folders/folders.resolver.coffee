FoldersResolver = ($stateParams, PageLoading, Folder) ->
  PageLoading.resolve Folder.get({}, { course_id: $stateParams.courseId })

FoldersResolver.$inject = ['$stateParams', 'PageLoading', 'Folder']

angular
  .module('app.courses')
  .constant('FoldersResolver', FoldersResolver)
