DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

resolver = (PageLoading, Course) ->
  PageLoading.resolve Course.query()

resolver.$inject = ['PageLoading', 'Course']
DunnoApp.constant 'CoursesResolver', resolver
DunnoAppStudent.constant 'CoursesResolver', resolver
