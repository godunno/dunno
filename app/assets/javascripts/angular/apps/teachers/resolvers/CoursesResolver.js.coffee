DunnoApp = angular.module('DunnoApp')

resolver = (PageLoading, Course) ->
  PageLoading.resolve Course.query()

resolver.$inject = ['PageLoading', 'Course']
DunnoApp.constant 'CoursesResolver', resolver
