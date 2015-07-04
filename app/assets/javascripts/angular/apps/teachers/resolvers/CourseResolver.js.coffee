DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.get(uuid: $stateParams.id)

resolver.$inject = ['$stateParams', 'PageLoading', 'Course']
DunnoApp.constant 'CourseResolver', resolver
