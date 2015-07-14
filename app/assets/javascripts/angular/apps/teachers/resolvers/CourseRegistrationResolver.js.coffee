DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.search($stateParams.id)

resolver.$inject = ['$stateParams', 'PageLoading', 'Course']
DunnoApp.constant 'CourseRegistrationResolver', resolver
